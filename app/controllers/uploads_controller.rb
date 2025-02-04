class UploadsController < ApplicationController
  before_action :authenticate_request!

  def create
    if params[:file].present?
      uploaded_file = params[:file]
      blob = ActiveStorage::Blob.create_and_upload!(io: uploaded_file, filename: uploaded_file.original_filename, content_type: uploaded_file.content_type)
      render json: { url: url_for(blob) }, status: :created
    else
      render json: { error: "No file attached", error_code: "NO_FILE" }, status: :unprocessable_entity
    end
  end
end
