require "net/http"
require "json"

# Gemini API と通信するクライアントクラス
#
# 単発の質問（ask）と、会話履歴を送るチャット（chat）の2種類のメソッドを提供する。
# Google Generative Language API にリクエストを送り、AI の返答テキストを抽出して返す。
#
# @see https://ai.google.dev/ Google Generative Language API
class GeminiClient
  # 利用する Gemini モデルのエンドポイント
  #
  # @return [String]
  API_URL = "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent"

  # 単発の質問を送信する（AI アドバイス機能）
  #
  # @param prompt [String] ユーザーからの質問文
  # @return [String, nil] AI の返答テキスト
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
  # @param messages [Array<ChatMessage>] ChatMessage の配列
  # @return [String, nil] AI の返答テキスト
  #
  # @note system メッセージは Gemini API の仕様上 user として扱う
  def self.chat(messages)
    contents = messages.map do |msg|
      {
        role: msg.role == "system" ? "user" : msg.role,
        parts: [ { text: msg.content } ]
      }
    end

    body = { contents: contents }

    request(body)
  end

  private

  # Gemini API に HTTP リクエストを送信する
  #
  # @param body [Hash] API に送信する JSON ボディ
  # @return [String, nil] AI の返答テキスト
  #
  # @note レスポンスの JSON から text 部分のみを抽出して返す
  def self.request(body)
    uri = URI("#{API_URL}?key=#{ENV['GEMINI_API_KEY']}")
    headers = { "Content-Type" => "application/json" }

    response = Net::HTTP.post(uri, body.to_json, headers)
    json = JSON.parse(response.body)

    puts "=== Gemini API Response ==="
    puts response.body.force_encoding("UTF-8")

    json = JSON.parse(response.body)

    # AI の返答テキストを抽出
    json.dig("candidates", 0, "content", "parts", 0, "text")
  end
end
