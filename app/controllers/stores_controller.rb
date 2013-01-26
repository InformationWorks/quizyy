class StoresController < ApplicationController
  
  before_filter :authenticate_user!
  before_filter :initialize_cart
  
  def timed_tests
    
    @package_1 = Package.find_by_position(1)
    @package_2 = Package.find_by_position(2)
    @package_3 = Package.find_by_position(3)
    
    @full_length_quizzes = Quiz.scoped_timed_full_quizzes(current_user).not_in_account_of_user(current_user).order('id ASC').first(3)
    @full_length_quizzes += current_user.quizzes.full.timed
    
    # Fetch categories & topics that have atleast one quiz.
    # TODO: .where("quizzes.approved = true")
    @categories = Category.with_timed_quiz_for_user(current_user).order('name ASC')
    @topics = Topic.with_timed_quiz_for_user(current_user).order('name ASC')
    
    # Merge categories & topics in the same list.
    @categories_and_topics = []
    @categories_and_topics +=  @categories
    @categories_and_topics +=  @topics
    @categories_and_topics.sort! { |a,b| a.name.downcase <=> b.name.downcase }
  end

  def practice_tests
   
    # Fetch categories & topics that have at-least one quiz.
    # TODO: .where("quizzes.approved = true")
    @categories = Category.with_practice_quiz_for_user(current_user).order('name ASC')
    @topics = Topic.with_practice_quiz_for_user(current_user).order('name ASC')
    
    # Merge categories & topics in the same list.
    @categories_and_topics = []
    @categories_and_topics +=  @categories
    @categories_and_topics +=  @topics
    @categories_and_topics.sort! { |a,b| a.name.downcase <=> b.name.downcase }
  end

  def add_cart_item

    begin

      if params[:quiz_id]
        # Add quiz to cart.
        quiz = Quiz.find(params[:quiz_id])

        cart_item = @cart.cart_items.where(:quiz_id => quiz.id).first

        if cart_item == nil
          @cart.cart_items.create(:quiz_id => quiz.id)
        else
          # If already exists, save to modify updated_at.
          cart_item.save!
        end

        entity = "Test"
      elsif params[:package_id]
        # Add package to cart.
        package = Package.find(params[:package_id])

        cart_item = @cart.cart_items.where(:package_id => package.id).first

        if cart_item == nil
          CartItem.delete_all(["cart_id = ? AND (package_id IS NOT NULL)", @cart.id])
          @cart.cart_items.create(:package_id => package.id)
        else
          # If already exists, save to modify updated_at.
          cart_item.save!
        end

        entity = "Package"
      end

      respond_to do |format|
        format.json { render :json => {:data=>cart_item,:success=>true, :message => "#{entity} added to cart successfully."} }
      end

    rescue Exception => ex
      respond_to do |format|
       format.json { render :json => {:data=>cart_item,:success=>false, :message => ex.message} }
     end
    end

  end

  def destroy_cart_item

   begin

     cart_item = CartItem.find(params[:id])

     if cart_item.package_id == nil
       entity = "Test"
     elsif cart_item.quiz_id == nil
       entity = "Package"
     end

     cart_item.destroy

     respond_to do |format|
       format.json { render :json => {:data=>cart_item,:success=>true, :message => "#{entity} removed from cart."} }
     end

   rescue Exception => ex
     respond_to do |format|
       format.json { render :json => {:data=>cart_item,:success=>false, :message => ex.message} }
     end
   end

  end
  
end
