class ActivityLog < ActiveRecord::Base
  attr_accessible :action, :activity, :actor_id, :target_id
  
  belongs_to :actor, :class_name => "User"
  belongs_to :target, :class_name => "User"
end
