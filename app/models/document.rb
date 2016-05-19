# Class Document
class Document < ActiveRecord::Base
  belongs_to :user
  has_attached_file :doc

  validates :title, presence: true
end
