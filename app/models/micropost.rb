class Micropost < ApplicationRecord
  belongs_to :user
  mount_uploader :picture, PictureUploader
  validates :user_id, presence: true
  validates :content, presence: true, length: {maximum:
    Settings.micropost_max_length}
  validate :picture_size
  scope :newest, -> {order(created_at: :desc)}

  private

  def picture_size
    if picture.size > Settings.max_picture_size.megabytes
      errors.add :picture, I18n.t("hello")
    end
  end
end
