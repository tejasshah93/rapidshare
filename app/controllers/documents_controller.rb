# Class DocumentsController
class DocumentsController < ApplicationController
  include AbstractController::Callbacks

  # before_action :require_user, only: [:index, :show]
  before_filter :require_user, except: [:public_documents, :show]

  def index
    @documents = Document.all
    @user = User.find(params[:user_id])
  end

  def show
    @document = Document.find(params[:id])
    @user = User.find(params[:user_id])
  end

  def new
  end

  def edit
    @document = Document.find(params[:id])
    @user = User.find(session[:user_id])
    redirect_to user_path(@user) if @user.id != @document.user_id
  end

  # rubocop:disable AbcSize
  # rubocop:disable MethodLength
  def create
    p params[:document]
    uploaded_io = params[:document][:doc_path]
    file_path = retrieve_file_path(uploaded_io)
    File.open(file_path, 'wb') do |file|
      file.write(uploaded_io.read)
    end

    params[:document][:doc_path] = file_path.to_s
    # @document = Document.new(params[:document])
    @user = User.find(params[:user_id])
    @document = @user.documents.new(params[:document])

    if @document.save
      redirect_to user_document_path(@user, @document)
    else
      render 'new'
    end
  end

  def update
    @user = User.find(params[:user_id])
    @document = Document.find(params[:id])

    p @document
    if @document.update_attributes(params[:document])
      redirect_to user_document_path(@user, @document)
    else
      render 'edit'
    end
  end

  def destroy
    @document = Document.find(params[:id])
    @user = User.find(session[:user_id])
    @document.destroy if @user.id == @document.user_id
    redirect_to user_path(@user)
  end

  def retrieve_file_path(uploaded_io)
    Rails.root.join('public', 'uploads', uploaded_io.original_filename)
  end

  def download_file
    @document = Document.find(params[:id])
    send_file @document.doc_path, disposition: 'attachment'
  end

  def public_documents
    @documents = Document.where(is_private: false)
  end

  private

  def document_params
    params.require(:document).permit(:title, :doc_path, :is_private)
  end
end
