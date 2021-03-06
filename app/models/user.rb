class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # When a user is deleted, their participation must be deleted.
  has_many :user_events, dependent: :destroy
  # When a user is deleted, note that events they participate in must NOT be deleted.
  has_many :events, through: :user_events

  # When a user is deleted, events owned by them must be deleted.
  has_many :created_events, class_name: 'Event', foreign_key: :owner_id, dependent: :destroy
end
