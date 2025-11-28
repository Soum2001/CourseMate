class Students::InterviewsController < ApplicationController
  include ActionController::Live  
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
      redirect_to ask_students_interviews_path(id: @conversation.id)
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
        redirect_to ask_students_interviews_path(id: @conversation.id)
    
      else
        @conversation.update!(
          answers_json: @conversation.answers_json,
          stage: "completed"
        )
        redirect_to finish_students_interviews_path(id: @conversation.id)
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
    
    
    
    
    
    
  end
   
    def finish
      @conversation = Conversation.find(params[:id])
  
      evaluation_prompt = <<~PROMPT
        Evaluate this interview for topic: #{@conversation.topic}
  
        Questions and Answers:
        #{@conversation.questions_json.to_json}
        #{@conversation.answers_json.to_json}
  
        Provide:
        - Skill Level (Beginner / Intermediate / Advanced)
        - Strengths
        - Weaknesses
        - Summary
      PROMPT
  
      result = GeminiClient.generate_content({
        contents: [{ role: "user", parts: [{ text: evaluation_prompt }] }]
      })
      
      analysis = analysis = result.dig("candidates", 0, "content", "parts", 0, "text")
  
      @conversation.update(
        level: extract_level(analysis),
        analysis_text: analysis
      )
  
      @analysis = analysis
    end
  
  
    private
  

  
    def extract_level(analysis)
  
      if analysis.match?(/advanced/i)
        "Advanced"
      elsif analysis.match?(/intermediate/i)
        "Intermediate"  
      elsif analysis.match?(/beginner/i)
        "Beginner"
      else
        "Unknown"
      end
    end
    def stream_gemini_question(topic, previous_questions)
      previous_list =
        if previous_questions.present?
          previous_questions.map { |q| "- #{q}" }.join("\n")
        else
          "(none)"
        end
  
      prompt = <<~TEXT
        Ask one short and clear interview question for a #{topic} developer.
  
        IMPORTANT:
        - Do NOT repeat or be similar to these earlier questions:
        #{previous_list}
  
        Return ONLY the question text.
      TEXT
  
      Google::GenerativeAI::Models.generate_content_stream(
        model: GEN_MODEL,
        contents: [
          {
            role: "user",
            parts: [{ text: prompt }]
          }
        ]
      ) do |event|
  
        # Extract chunk text (may be nil sometimes)
        text = event.dig("candidates", 0, "content", "parts", 0, "text")
        next unless text.present?
  
        # Send to browser immediately
        response.stream.write "data: #{text}\n\n"
      end
    end




    
    