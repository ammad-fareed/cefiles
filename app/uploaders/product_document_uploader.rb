class ProductDocumentUploader < ApplicationUploader
  attr_accessor :version

  def filename
    # This method is called twice - once before instantiating the version and once after -
    # meaning the filenames will no longer match up if a local variable is used
    # 1/+1 are used to keep versions number incrementing correctly from 1, instead of 0
    @version ||= (model.versions.any? ? model.versions.count+1 : 1)
    "#{@version}-#{original_filename}" if original_filename
  end
end
