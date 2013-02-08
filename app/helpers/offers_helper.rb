module OffersHelper
  def self.after_confirmation_offers(user)
    
    offer_messages = []
    
    ##############################################
    ### Handle "add_credits_on_confirm" offers
    add_credits_on_confirm_offers = Offer.add_credits_on_confirm.active
    add_credits_on_confirm_offers.each do |offer|
      
      if offer.global || offer.valid_for_user?(user)
        
        # Add credits to the user.
        user.add_credits(offer.credits,-1,"offer - " + offer.code,user.id,"Added credit after confirmation")
        offer_messages << "Added #{offer.credits} credits for the offer - #{offer.title}"
       
      end
        
    end

    ##############################################
    ### Handle "add_items_on_confirm" offers
    add_items_on_confirm_offers = Offer.add_items_on_confirm.active
    add_items_on_confirm_offers.each do |offer|
      
      if offer.global || offer.valid_for_user?(user)
        
        offer.offer_items.each do |offer_item|
          
          if offer_item.quiz_id != nil
            quiz_to_add = Quiz.find(offer_item.quiz_id)
            
            # Add items to the user.
            user.add_quiz(quiz_to_add,-1,"offer - " + offer.code,user.id,"Added quiz after confirmation")
            offer_messages << "Added a test #{quiz_to_add.name} for the offer - #{offer.title}"
          end
          
          if offer_item.package_id != nil
            package_to_add = Package.find(offer_item.package_id)
            
            # Add items to the user.
            user.add_package(package_to_add,-1,"offer - " + offer.code,user.id,"Added quiz after confirmation")
            offer_messages << "Added a package #{package_to_add.name} for the offer - #{offer.title}"
          end
          
        end
        
      end
        
    end
    
    return offer_messages
    
  end
end
