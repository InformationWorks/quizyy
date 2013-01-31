class ScaledScore < ActiveRecord::Base
  attr_accessible :quant_score, :value, :verbal_score

  def self.convert(section_type,percentage)
    if percentage == 100
      170
    else
      case section_type
        when :verbal
          self.where('verbal_score >= ?',percentage).first().value
        when :quant
          self.where('quant_score >= ?',percentage).first().value
        else
          0
      end
    end
  end
end
