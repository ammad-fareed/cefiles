class ProductCategory < ApplicationRecord
  has_many :products

  validates :name, presence: true
  has_many :children,class_name:"ProductCategory",foreign_key:"parent_id"
  belongs_to :parent,class_name:"ProductCategory",foreign_key:"parent_id",optional: true
  scope  :parent_categories, -> {where("parent_id is null")  }
  def descendents
    ProductCategory.where("parent_id = ? ",self.id)
  end
  def to_s
    name
  end
  def self.formatted_categories
    ProductCategory.parent_categories.order("name ASC").map{|c| [c.name.titleize.gsub(/(T Vs & Monitors)/,"TV, Monitors & Projectors").gsub(/(Telecom)/,"Telecoms"), c.id] }
  end
  def self.filtered_categories
    ProductCategory.parent_categories.order("name ASC").map{|c| [c.name.titleize, c.id]  }
  end
end
