class QuestionSerializer < ActiveModel::Serializer
  attributes :id, :type, :title, :body, :correct_count, :wrong_count, :created_at
  belongs_to :game
end
