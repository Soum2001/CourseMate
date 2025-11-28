class WebhooksController < ApplicationController
  skip_before_action :verify_authenticity_token
  
  def stripe
    payload    = request.body.read
    sig_header = request.env['HTTP_STRIPE_SIGNATURE']
    secret     = ENV["STRIPE_WEBHOOK_SECRET"]

    begin
      event = Stripe::Webhook.construct_event(
        payload, sig_header, secret
      )
    rescue Stripe::SignatureVerificationError => e
      Rails.logger.error "Signature error: #{e.message}"
      return render json: { success: false, message: "Invalid signature" }, status: 400
    rescue JSON::ParserError => e
      Rails.logger.error "JSON parse error: #{e.message}"
      return render json: { success: false, message: "Invalid payload" }, status: 400
    end

    # Store event safely
    record = Webhook.create!(
      event_id: event['id'],
      event_type: event['type'],
      payload: payload
    )
    
    if event['type']  == "payment_intent.succeeded"
      PayoutJob.perform_later(record.id)
    end
    
    head :ok
  end
end
