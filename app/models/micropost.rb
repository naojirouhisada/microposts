class Micropost < ActiveRecord::Base
  belongs_to :user
  validates :user_id, presence: true
  validates :content, presence: true, length: { maximum: 140 }
  
   has_many :favorite_favorites, class_name: "Favorite",
                                 foreign_key: "micropost_id",
                                 dependent: :destroy
    has_many :favorite_users, through: :favorite_favorites, source: :user
    
     #他のユーザーの記事をお気に入りにする
    def favorite(micropost)
        favorite_favorites.created(micropost_id: micropost.id)
    end
end
