class MultipleChoiceQuestion < Question
  def options=(values = [])
    self.body = {
      options: values
    }
  end
end
