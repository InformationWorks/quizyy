module ReportsHelper
  def total_scaled_score(score_in_percent)
    ((340 * score_in_percent)/100).to_i
  end
  def section_scaled_score(score_in_percent)
    ((170 * score_in_percent)/100).to_i
  end
end
