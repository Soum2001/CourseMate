require 'gemini-ai'

GeminiClient = Gemini.new(
  credentials: {
    service: 'generative-language-api',
    api_key: ENV['GEMINI_API_KEY'],
    version: 'v1beta'  # This is crucial!
  },
  options: {
    model: 'gemini-2.0-flash',
    server_sent_events: false  # Disable SSE for now
  }
)


