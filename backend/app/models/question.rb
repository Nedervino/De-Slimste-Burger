class Question < ApplicationRecord
  belongs_to :game,
             dependent: :destroy,
             counter_cache: true
  
  def answer
    self.body['answer']
  end
end
