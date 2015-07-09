# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  firstname              :string(255)
#  lastname               :string(255)
#  created_at             :datetime
#  updated_at             :datetime
#  email                  :string(255)      default(""), not null
#  encrypted_password     :string(255)      default(""), not null
#  reset_password_token   :string(255)
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string(255)
#  last_sign_in_ip        :string(255)
#
# Indexes
#
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#

class User < ActiveRecord::Base
  include Authority::UserAbilities
  rolify
  include Authority::Abilities
  self.authorizer_name = 'UserAuthorizer'

  has_many :programs, :dependent=>:destroy
  has_many :projects, :dependent=>:destroy

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  validates :email, :uniqueness => {:case_sensitive => false}

  def name
    "#{firstname} #{lastname}"
  end

  def is_teacher?
    Teacher.where(:user_id => self.id).present?
  end

  def teacher
    return Teacher.find_by(:user=>self)
  end

  def is_student?
    Student.where(:user_id => self.id).present?
  end

  def student
    return Student.find_by(:user=>self)
  end

  def before_destroy
    Teacher.where(:user_id => self.id).destroy_all
    Student.where(:user_id => self.id).destroy_all
  end

end
