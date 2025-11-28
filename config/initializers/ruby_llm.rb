require "ruby_llm"

RubyLLM.configure do |config|
  # Configure your default provider and API keys
  
  config.gemini_api_key = ENV['GEMINI_API_KEY']
  config.default_model = "gemini-2.0-flash" 
end
