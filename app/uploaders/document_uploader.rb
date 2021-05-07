class DocumentUploader < ApplicationUploader
  def extension_white_list
    %w(pdf jpeg jpg png doc docx)
  end
end
