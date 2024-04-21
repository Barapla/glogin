class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: [:google_oauth2]

  has_many :tokens, dependent: :destroy
  
  def self.from_omniauth(auth)
    where(provider: auth.provider, email: auth.info.email).first_or_create do |record|
      record.email = auth.info.email
      record.password = Devise.friendly_token[0, 20]
      record.name = auth.info.name
      record.picture_url = auth.info.image 
      # If you are using confirmable and the provider(s) you use validate emails,
      # uncomment the line below to skip the confirmation emails.
      # record.skip_confirmation!
    end
  end    
end
