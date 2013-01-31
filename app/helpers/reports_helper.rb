module ReportsHelper
  def section_scaled_score(section_type,percentage)
    ScaledScore.convert(section_type,percentage)
  end
end
