class Category < ActiveRecord::Base

  has_and_belongs_to_many :apps

  validates :name,
    presence: true,
    length: { minimum: 1 }

end
