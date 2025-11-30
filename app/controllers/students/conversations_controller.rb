class Students::ConversationsController < ApplicationController
  include ActionController::Live  
  before_action :authenticate_user!
  def language
    end
  
    def ask
      @conversation = Conversation.find(params[:id])
    end

    def start
      topic = params[:tech]
      
      @conversation = Conversation.create!(
        user_id: current_user.id,
        topic: topic,
        stage: "asking",
        question_no: 1,
        questions_json: {},
        answers_json: {}
      )
      redirect_to ask_students_conversation_path(@conversation)
    end
  

    def answer
      @conversation = Conversation.find(params[:id])
      q_no = @conversation.question_no
    
      # Save answer
      @conversation.answers_json["a#{q_no}"] = params[:answer]
    
      if q_no < 5
        @conversation.update!(
          answers_json: @conversation.answers_json,
          question_no: q_no + 1
        )
        redirect_to ask_students_conversation_path(@conversation)
    
      else
        @conversation.update!(
          answers_json: @conversation.answers_json,
          stage: "completed"
        )
      
        redirect_to finish_students_conversation_path(@conversation)
        
      end
    end
    
    
  
    def stream_question
      response.headers["Content-Type"] = "text/event-stream"
      response.headers["Cache-Control"] = "no-cache"
      response.headers["X-Accel-Buffering"] = "no"
    
      convo = Conversation.find(params[:id])
      topic = convo.topic

      # previous questions already asked
      previous = convo.questions_json.values
    
      prompt = <<~TEXT
        Ask one short and clear interview question for a #{topic} developer.
    
        Important:
        - Do NOT repeat any of these questions:
        #{previous.map { |q| "- #{q}" }.join("\n")}
        - Return only the question text.
      TEXT
    
      chat = RubyLLM.chat(model: "gemini-2.0-flash")
      full_question = ""
    
      chat.ask(prompt) do |chunk|
        token = chunk.content.to_s
        next if token.blank?
    
        full_question << token
        response.stream.write("data: #{token}\n\n")
        sleep(0.02)
      end
    
      # Save question in DB once fully generated
      next_no = convo.question_no
      convo.update!(
        questions_json: convo.questions_json.merge("q#{next_no}" => full_question)
      )
    
      response.stream.write("data: [END]\n\n")
    
    rescue => e
      response.stream.write("data: ERROR: #{e.message}\n\n")
    ensure
      response.stream.close
    end
   
    def finish

      @conversation = Conversation.find(params[:id])
  
      evaluation_prompt = <<~PROMPT
          Evaluate this interview based on the topic: #{@conversation.topic}

          Questions and Answers:
          #{@conversation.questions_json.to_json}
          #{@conversation.answers_json.to_json}

          Determine the user's skill level.

          Respond with ONLY ONE WORD:
          - Beginner
          - Intermediate
          - Advanced

          Do not include explanations or extra text. Your entire reply must be exactly one of the above words.
        PROMPT
      chat = RubyLLM.chat(model: "gemini-2.0-flash")
      answer = chat.ask(evaluation_prompt)
      evaluated_level = answer.content.to_s.gsub(/\s+/, " ").strip
      binding.pry
      @conversation.update(
        level: evaluated_level
      )
      mapped_name = Conversation::TOPIC_MAP[@conversation.topic.downcase] || @conversation.topic
      category = Category.find_by(name: mapped_name)
      
      redirect_to students_courses_path(
        level: evaluated_level,
        category: category&.id,
        topic: @conversation.topic
      )
    end
  
  end





    
    