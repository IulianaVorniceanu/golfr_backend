# Model to represent a score played by a golfer
# - total_score: total number of hits to finish all 18 holes
# - played_at: date when the score was played
class Score < ApplicationRecord
  belongs_to :user

  validates :total_score, inclusion: { in: 27..180 }
  validates :number_of_holes, inclusion: {in: [9, 18]}
  validate :future_score

  def serialize
    {
      id: id,
      user_id: user_id,
      user_name: user.name,
      total_score: total_score,
      number_of_holes: number_of_holes,
      played_at: played_at,
    }
  end

  private

  def future_score
    errors.add(:played_at, 'must not be in the future') if played_at > Time.zone.today
  end

  def score_values
    errors.add(:total_score, 'must be a valid score') if
      (number_of_holes == 9 and !total_score.between?(27, 90)) ||
      (number_of_holes == 18 and !total_score.between?(54, 180))
  end
end
