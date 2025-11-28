import "@hotwired/turbo-rails"
import "controllers"
import "bootstrap"

document.addEventListener("turbo:load", () => {
    const btn = document.getElementById("checkout-button");
    if (!btn) return;
  
    const publishableKey = document
      .querySelector("meta[name='stripe-publishable-key']")
      .content;
  
    const stripe = Stripe(publishableKey);
  
    const courseIds = JSON.parse(btn.dataset.courseIds);
    const csrfToken = btn.dataset.csrfToken;
  
    btn.addEventListener("click", async () => {
      const response = await fetch("/students/checkouts", {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
          "X-CSRF-Token": csrfToken
        },
        body: JSON.stringify({ course_ids: courseIds })
      });
  
      const session = await response.json();
      stripe.redirectToCheckout({ sessionId: session.id });
    });
  });
  
  