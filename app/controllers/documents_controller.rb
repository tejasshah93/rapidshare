# Class DocumentsController
class DocumentsController < ApplicationController
  include AbstractController::Callbacks

  # before_action :require_user, only: [:index, :show]
  before_filter :require_user

  def index
    @documents = Document.all
  end

  def show
    @document = Document.find(params[:id])
  end

  def new
  end

  # rubocop:disable AbcSize
  # rubocop:disable MethodLength
  def create
    uploaded_io = params[:document][:doc_path]
    file_path = retrieve_file_path(uploaded_io)
    File.open(file_path, 'wb') do |file|
      file.write(uploaded_io.read)
    end

    params[:document][:doc_path] = file_path.to_s
    @document = Document.new(params[:document])

    if @document.save
      redirect_to @document
    else
      render 'new'
    end
  end
  # rubocop:enable AbcSize
  # rubocop:enable MethodLength

  def retrieve_file_path(uploaded_io)
    Rails.root.join('public', 'uploads', uploaded_io.original_filename)
  end

  def download_file
    @document = Document.find(params[:id])
    send_file @document.doc_path, disposition: 'attachment'
  end

  def destroy
    @document = Document.find(params[:id])
    @document.destroy
    redirect_to documents_path
  end

  private

  def document_params
    params.require(:document).permit(:title)
  end
end
