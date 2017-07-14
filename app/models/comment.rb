class Comment < ApplicationRecord
  belongs_to :article
  validates :commenter, :article_id, presence: true
  validates :body, presence: true, length: { minimum: 5 }
end
