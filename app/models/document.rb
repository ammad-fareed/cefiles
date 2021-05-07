class Document < ApplicationRecord
  DOCUMENT_TOTAL_SIZE_LIMIT = 500.megabytes

  has_paper_trail class_name: "Version"

  belongs_to :product

  attr_accessor :file_cache
  validates :title, :file, :product_id, presence: true
  validate :product_documents_under_size_limit

  mount_uploader :file, ProductDocumentUploader

  scope :public_docs, -> { where(public: true) }

  before_validation :update_file_attributes

  private

  def update_file_attributes
    if file.present? && file_changed?
      self.file_size = file.file.size
    end
  end

  def product_documents_under_size_limit
    if product.present?
      file_size = product.documents.map(&:file_size).compact.sum

      # If this is a new record, it will not appear in product.documents so add its file size in
      file_size += self.file_size if file.present? and self.new_record?

      if file_size >= DOCUMENT_TOTAL_SIZE_LIMIT
        errors.add(:file, I18n.t('errors.messages.over_size_limit'))
      end
    end
  end

end
