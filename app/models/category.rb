class Category < ActiveRecord::Base

  has_and_belongs_to_many :apps

  validates :name,
    presence: true,
    length: { minimum: 1 }

  def has_apps?
    self.apps.size > 0
  end

end
