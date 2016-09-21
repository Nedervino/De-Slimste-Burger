class ResultSerializer < ActiveModel::Serializer
  attributes :id, :name, :organisation, :correct_count, :incorrect_count, :score, :answers
end
