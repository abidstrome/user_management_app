class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  enum status: {active: 0, blocked: 1}

  def after_database_authentication
    self.update(last_login_time: Time.current)
  end
  def active_for_authentication?
    super && self.active?
  end

  def inactive_message
    "Your account has been blocked."
  end
end
