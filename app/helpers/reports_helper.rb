module ReportsHelper
  def total_scaled_score(raw_score)
    (340 * raw_score).to_i
  end
  def section_scaled_score(raw_score)
    (170 * raw_score).to_i
  end
end
