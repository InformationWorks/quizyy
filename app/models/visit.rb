class Visit < ActiveRecord::Base
  belongs_to :attempt
  belongs_to :question
  attr_accessible :attempt_id, :question_id, :start, :end
  def self.update(attempt_id,question_id,time)
    visit = Visit.where(:attempt_id => attempt_id,:question_id=>question_id).last
    if visit
	    visit.end = time 
	    visit.save
	end
  end
end
