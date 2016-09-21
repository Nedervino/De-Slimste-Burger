class Result < ApplicationRecord
  belongs_to :game,
             dependent: :destroy,
             counter_cache: true

  before_validation :normalize_organisation
  before_save :set_score
  
  def normalize_organisation
    if self.organisation.present?
      self.organisation = self.organisation.downcase.strip
    end
  end
  
  def set_score
    self.correct_count = 0
    self.incorrect_count = 0
    self.answers.each do |answer|
      if self.game.questions.find(answer['question_id']).body['answer'] == answer['answer']
        self.correct_count += 1
      else
        self.incorrect_count += 1
      end
    end
    self.score = self.correct_count
  end
end
