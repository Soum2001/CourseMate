class Instructors::OnboardingController < ApplicationController
  before_action :authenticate_user!

  def onboard_account
    if current_user.stripe_account_id.blank?
        
      account = Stripe::Account.create({
        type: "express",
        country: "US",
        email: current_user.email,
        business_type: "individual",
        capabilities: {
          card_payments: { requested: true },
          transfers:      { requested: true }
        }
      })
    
      current_user.update!(stripe_account_id: account.id)
    end
    
    link = Stripe::AccountLink.create({
      account: current_user.stripe_account_id,
      refresh_url: instructors_onboarding_refresh_url,
      return_url: instructors_onboarding_return_url,
      type: "account_onboarding"
    })
    
    redirect_to link.url, allow_other_host: true
  end
  def refresh
    # This is where user comes if onboarding fails or expires
    flash[:alert] = "Your onboarding session expired. Please try again."
    redirect_to instructors_profile_path
  end

  def return
    # This is where instructor comes after successful onboarding
    flash[:notice] = "Stripe onboarding completed successfully!"
    redirect_to instructors_profile_path
  end
end
