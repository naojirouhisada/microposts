class User < ActiveRecord::Base
    mount_uploader :avatar, AvatarUploader
    before_save { self.email = email.downcase }
    validates :name, presence: true, length: { maximum: 50 }
    VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
    validates :email, presence: true, length: {maximum: 255},
                      format: { with: VALID_EMAIL_REGEX },
                      uniqueness: { case_sensitive: false }
    has_secure_password
    has_many :microposts
    
   
    has_many :following_relationships, class_name:  "Relationship",
                                     foreign_key: "follower_id",
                                     dependent:   :destroy
    has_many :following_users, through: :following_relationships, source: :followed
    
    has_many :follower_relationships, class_name:  "Relationship",
                                    foreign_key: "followed_id",
                                    dependent:   :destroy
    has_many :follower_users, through: :follower_relationships, source: :follower
    
    
    has_many :favorited_favorites, class_name: "Favorite",
                                 foreign_key: "user_id",
                                 dependent: :destroy
    has_many :favorited_micropost, through: :favorited_favorites, source: :micropost
    
  
    
    # 他のユーザーをフォローする
    def follow(other_user)
        following_relationships.create(followed_id: other_user.id)
    end

    # フォローしているユーザーをアンフォローする
    def unfollow(other_user)
        following_relationships.find_by(followed_id: other_user.id).destroy
    end

    # あるユーザーをフォローしているかどうか？
    def following?(other_user)
        following_users.include?(other_user)
    end
    
    def feed_items
        Micropost.where(user_id: following_user_ids + [self.id])
    end
    
   #他のユーザーの記事をお気に入りにする
    def favorite(micropost)
        favorited_favorites.create(micropost_id: micropost.id)
    end
    
    #お気に入りの記事をお気に入りから外す
    def unfavorite(micropost)
        favorited_favorites.find_by(micropost_id: micropost.id).destroy
    end
    
    #ある記事がお気に入りされているかどうか
    def favoriting?(micropost)
        favorited_micropost.include?(micropost)
    end
        
end

 