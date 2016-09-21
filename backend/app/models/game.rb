class Game < ApplicationRecord
  has_many :questions
  has_many :results
  before_create :build_questions

  QUESTION_FORMATS = {
    miljoenennota_question: 1,
    national_budget_question: 2,
    cito_question: 1,
    national_budget_percentage_question: 1,
    king_budget_question: 1,
    welfare_question: 1,
    education_question: 1,
    health_question: 1,
    social_question: 1,
    spacial_question: 1,
  }

  def build_questions
    random_formats.each do |format|
      questions << Question.new(QuestionGenerator.send(format))
    end
  end

  def random_formats
    formats = []
    possible_formats = QUESTION_FORMATS

    2.times do
      possible_formats.delete((%i(education_question health_question social_question spacial_question) & possible_formats.keys).sample)
    end

    possible_formats.each do |format, count|
      count.times do
        formats << format
      end
    end
    formats.shuffle[0..9]
  end
end
