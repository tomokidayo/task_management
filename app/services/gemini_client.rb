require "net/http"
require "json"

# Gemini API と通信するクライアントクラス
#
# 単発の質問（ask）と、会話履歴を送るチャット（chat）の2種類のメソッドを提供する。
# Google Generative Language API にリクエストを送り、AI の返答テキストを抽出して返す。
# 429 エラー時は指数バックオフで最大3回リトライする。
#
# @see https://ai.google.dev/ Google Generative Language API
class GeminiClient
  # 利用する Gemini モデルのエンドポイント
  #
  # @return [String]
  API_URL = "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash:generateContent"

  # 単発の質問を送信する（AI アドバイス機能）
  #
  # @param prompt [String] ユーザーからの質問文
  # @return [String, nil] AI の返答テキスト。APIエラー時は nil を返す
  def self.ask(prompt)
    body = {
      contents: [
        { parts: [ { text: prompt } ] }
      ]
    }
    request(body)
  end

  # 会話履歴を送信する（AI チャット機能）
  #
  # @param messages [Array<ChatMessage>] ChatMessage の配列（system / user / assistant ロールを含む）
  # @return [String, nil] AI の返答テキスト。APIエラー時は nil を返す
  #
  # @note system メッセージは Gemini API の仕様上 user として扱う
  def self.chat(messages)
    contents = messages.map do |msg|
      role = case msg.role
      when "system"    then "user"
      when "assistant" then "model"  # ← これが抜けていた
      else msg.role
      end
      {
        role: role,
        parts: [ { text: msg.content } ]
      }
    end
    request({ contents: contents })
  end

  private

  # Gemini API に HTTP リクエストを送信し、返答テキストを抽出する
  #
  # @param body [Hash] API に送信する JSON ボディ
  # @return [String, nil] AI の返答テキスト。APIエラー時は nil を返す
  #
  # @note レスポンスに "error" キーが含まれる場合はエラーログを出力して nil を返す
  # @note 429 エラー(RESOURCE_EXHAUSTED)時は指数バックオフ(2・4・8秒)で最大3回リトライする
  def self.request(body)
    uri = URI("#{API_URL}?key=#{ENV['GEMINI_API_KEY']}")
    headers = { "Content-Type" => "application/json" }
    max_retries = 3
    retry_count = 0

    begin
      # Gemini API に POST リクエストを送信し、レスポンスを JSON としてパースする
      response = Net::HTTP.post(uri, body.to_json, headers)
      json = JSON.parse(response.body)
      Rails.logger.debug("=== Gemini API Response ===\n#{response.body.force_encoding('UTF-8')}")

      if json["error"]
        code    = json["error"]["code"]
        message = json["error"]["message"]
        Rails.logger.error("Gemini API Error #{code}: #{message}")

        # 429（レート制限超過）の場合は指数バックオフでリトライ
        # 待機時間: 1回目=2秒, 2回目=4秒, 3回目=8秒
        if code == 429 && retry_count < max_retries
          retry_count += 1
          wait = 2 ** retry_count
          Rails.logger.info("Retrying in #{wait}s... (attempt #{retry_count}/#{max_retries})")
          sleep(wait)
          # rescue 節の retry を呼び出すために意図的に例外を発生させる
          raise "Retrying request due to 429 error"
        end

        return nil
      end

      # 正常レスポンスから AI の返答テキストを抽出して返す
      json.dig("candidates", 0, "content", "parts", 0, "text")

    rescue => e
      # 429 リトライ中は再試行、リトライ上限に達した場合はエラーログを出力して nil を返す
      retry if retry_count < max_retries
      Rails.logger.error("Request failed after retries: #{e.message}")
      nil
    end
  end
end
