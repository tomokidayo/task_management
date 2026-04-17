require "net/http"
require "json"

class GeminiClient
  # API_URL = "https://generativelanguage.googleapis.com/v1beta/models/gemini-pro:generateContent"
  API_URL = "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent"

  # 単発の質問（AIアドバイス機能）
  def self.ask(prompt)
    body = {
      contents: [
        { parts: [ { text: prompt } ] }
      ]
    }

    request(body)
  end

  # 会話履歴を送る（AIチャット機能）
  def self.chat(messages)
    contents = messages.map do |msg|
      {
        role: msg.role, # "user" or "assistant"
        parts: [ { text: msg.content } ]
      }
    end

    body = { contents: contents }

    request(body)
  end

  private

  def self.request(body)
    uri = URI("#{API_URL}?key=#{ENV['GEMINI_API_KEY']}")
    headers = { "Content-Type" => "application/json" }

    response = Net::HTTP.post(uri, body.to_json, headers)
    json = JSON.parse(response.body)

    puts "=== Gemini API Response ==="
    puts response.body.force_encoding("UTF-8")
    # puts response.body
    json = JSON.parse(response.body)

    json.dig("candidates", 0, "content", "parts", 0, "text")
  end
end
