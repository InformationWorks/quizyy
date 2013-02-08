module OrdersHelper
  def self.after_confirmation_offers(user)
    
    offer_messages = []
    
    offers = Offer.add_credits_on_confirm.active
    offers.each do |offer|
      
      if offer.global
        
        # Add credits to the user.
        user.add_credits(offer.credits,-1,"offer - " + offer.code,user.id,"Added credit after confirmation")
        offer_messages << "Added #{offer.credits} credits for the offer #{offer.title}"
        
      elsif offer.valid_for_user?(user)        
        
        # Add credits to the user.
        user.add_credits(offer.credits,-1,"offer - " + offer.code,user.id,"Added credit after confirmation")
        offer_messages << "Added #{offer.credits} credits for the offer #{offer.title}"
        
      end
        
    end
    
    return offer_messages
    
  end
end
