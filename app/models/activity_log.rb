##
# This class represents an ActivityLog item
class ActivityLog < ActiveRecord::Base
  
  ############################################################
  # Basic setup
  ############################################################
  
  # ----------------------------------------------------------
  # Attributes
  attr_accessible :action, :activity, :actor_id, :target_id, :desc
  
  ############################################################
  # Relations
  ############################################################
  
  # ----------------------------------------------------------
  # belongs_to
  belongs_to :actor, :class_name => "User"
  belongs_to :target, :class_name => "User"
  
end
