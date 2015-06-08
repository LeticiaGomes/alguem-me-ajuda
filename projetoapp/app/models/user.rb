class User < ActiveRecord::Base
  include ValidateEmailHelper
  
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :confirmable, :lockable, :timeoutable
         
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  
  validates :name, presence: true, length: {maximum: 250}, uniqueness: { case_sensitive: false }
  validates :email, presence: true, uniqueness: { case_sensitive: false }, length: {maximum:255}, format: {with: VALID_EMAIL_REGEX}
  validate :verify_errors, :verify_email
  
  private

  def verify_errors
    errors.messages.each do |field, erro|
        erro.uniq!
    end
  end
  
  def verify_email
    return if email.blank?
    result = get_response_email(email)
    errors.add(:email, "não existe! Verifique.") if result==nil || result["result"] == "invalid"
  end
         
end
