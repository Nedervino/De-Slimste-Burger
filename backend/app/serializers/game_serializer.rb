class GameSerializer < ActiveModel::Serializer
  attributes :id, :results_count, :questions_count, :created_at, :updated_at
  has_many :questions
end
