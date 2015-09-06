class User < ActiveRecord::Base

  include ActiveUUID::UUID

  before_validation :set_random_uuid, if: -> (user) { user.uuid.blank? }

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  private

  def set_random_uuid
    return unless uuid.blank?

    while uuid.blank?
      random_uuid = SecureRandom.uuid
      self.uuid = random_uuid unless User.exists?(uuid: random_uuid)
    end
  end

end
