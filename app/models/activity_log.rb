class ActivityLog < ActiveRecord::Base
  attr_accessible :action, :activity, :actor_id
  
  belongs_to :actor, :class_name => "User"
end
