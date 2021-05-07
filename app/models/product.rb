class Product < ApplicationRecord
  belongs_to :company
  belongs_to :supplier,optional: true
  belongs_to :manufacturer,optional: true
  belongs_to :eu_representative,optional: true
  belongs_to :product_category
  has_one :product_declaration
  has_and_belongs_to_many :directives
  has_and_belongs_to_many :standards
  has_many :ce_categories, through: :directives
  has_many :documents, dependent: :destroy
  has_many :product_suppliers
  has_many :all_suppliers, source: :supplier, through: :product_suppliers
  has_one :product_remark

  # attr_accessible :barcode, :description, :directives, :eu_representative_attributes, :image,
  #                 :image_cache, :manufacturer_attributes, :model_number, :name, :notes, :published, :all_suppliers_attributes,
  #                 :product_category_id,  :remove_image,:serial_number, :standards, :standard_ids,:sales_rep_check,:prod_declaration_check,:p_xml_id,:company_id,:p_xml_image,:is_imported,:is_approved,
  #                 as: [:default, :admin]
  # attr_accessible :company_id, as: [:admin]
  attr_accessor :sales_rep_check
  validates :name,:description, :company_id, :model_number,:product_category_id, presence: true
  #validates   :all_suppliers,  presence: true, if: :validation_checked?
  validates :barcode, uniqueness: true, allow_nil: true
  validates :description, length: { maximum: 100 }
  validates :notes, length: { maximum: 1000 }
  #validate :company_published_products_under_limit, if: :published?
  # accepts_nested_attributes_for :product_declaration, reject_if: :prod_declaration_check?, allow_destroy: true
  # accepts_nested_attributes_for :supplier, :eu_representative, reject_if: :nested_addressable_not_required?
  accepts_nested_attributes_for :all_suppliers, reject_if: :validation_checked?, allow_destroy: true
  # accepts_nested_attributes_for :manufacturer, allow_destroy: true, reject_if: :nested_attributes_blank?
  accepts_nested_attributes_for :product_remark
  mount_uploader :image, ProductImageUploader


  scope :published, lambda { where(published: true) }
  scope :pending_approval,-> {where("is_imported=?  AND is_approved IS NULL",false)}
  #scope :approved,-> {where("is_approved=?",true)}
  scope :imported, lambda{ where("is_imported = ? OR is_imported = ?",true,false) }
  scope :admin_approved,lambda{where("is_approved IS NULL OR is_approved = ? ",true)}
  scope :searchable, lambda{where("searchable IS NULL OR searchable=?",true)}
  #scope :pending_approval,-> {where("is_imported=?  and (is_approved IS NULL)",false)}
  scope :approved,-> {where("is_approved=?",true)}
  #scope :admin_approved, -> {where(published: true).where("is_imported is NOT NULL").where("is_approved IS NOT NULL")}
  before_save { self.share_code ||= SecureRandom.hex(6) }
  scope :period_limit_products, lambda { |start_date, end_date| where("created_at BETWEEN ? AND ?",start_date,end_date) }



  def p_company
    Company.where("id = ? or c_xml_id = ?",self.company_id,self.company_id).first
  end
  def validation_checked?
    sales_rep_check == "0"
  end
  def prod_declaration_check?
    prod_declaration_check=="0"
  end

  def to_s
    name
  end

  def self.sort_order(column, direction)
    if column == 'category'
      sort = "product_categories.name"
    elsif column == 'company'
      sort = 'companies.name'
    elsif column_names.include?(column)
      sort = "products.#{column }"
    else
      sort = "id"
    end
    "#{sort} #{direction}"
  end

  def directives=(directives)
    self.directive_ids = directives.split(' ').uniq
  end

  def standards=(standards)
    self.standard_ids = standards.split(' ').uniq
  end
  def approve!
    self.update_attributes(is_approved:true)
  end
  def reject!
    self.update_attributes(is_approved:false)
  end
  def is_rejected?
    self.is_approved==false
  end

  private

  def declaration_not_required?(attributes)
    !published? && attributes.all? { |key, value| ['_destroy', 'remove_file'].include?(key) || value.blank? }
  end

  def nested_addressable_not_required?(attributes)
    !published? && nested_attributes_blank?(attributes)
  end

  def nested_attributes_blank?(attributes)
    attributes['name'].blank? && attributes['address_attributes'].values.uniq == ['']
  end

  def company_published_products_under_limit
    # This only applies if the product is becoming published, not was already published
    if company.present? && published_changed? && company.exceeds_published_product_limit?
      errors.add(:published, I18n.t('errors.messages.over_product_limit', limit: company.published_product_limit))
    end
  end

end
