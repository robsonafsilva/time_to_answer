class UserStatistic < ApplicationRecord
  belongs_to :user

  # Virtual Atributes
  def total_questions
    self.right_questions + self.wrong_questions
  end

  # Class Methods
  def self.set_statistic(answer, current_user)
    if !!current_user # negando 2x o valor passa a ser T ou F ao invés de nill ou usuário.
      user_statistic = UserStatistic.find_or_create_by(user: current_user)
      if answer.correct?
        user_statistic.right_questions += 1
      else
        user_statistic.wrong_questions += 1
      end
      user_statistic.save
    end
  end
end
