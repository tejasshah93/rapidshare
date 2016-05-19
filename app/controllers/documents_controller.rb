# Class DocumentsController
class DocumentsController < ApplicationController
  include AbstractController::Callbacks

  # before_action :require_user, only: [:index, :show]
  before_filter :authenticate_user!, except: [:public_documents, :show]

  def index
    @documents = Document.all
  end

  # rubocop:disable AbcSize
  def show
    @document = Document.find(params[:id])
    if @document.is_private? && (!user_signed_in? || current_user.id != \
                                                   @document.user_id)
      redirect_to public_documents_path
    else
      @user = User.find(params[:user_id])
    end
  end
  # rubocop:enable AbcSize

  def new
  end

  def edit
    @document = Document.find(params[:id])
    redirect_to user_path(current_user) if current_user.id != @document.user_id
  end

  def create
    @document = current_user.documents.new(params[:document])

    if @document.save
      redirect_to user_document_path(current_user, @document)
    else
      render 'new'
    end
  end

  def update
    @document = Document.find(params[:id])

    if @document.update_attributes(params[:document])
      redirect_to user_document_path(current_user, @document)
    else
      render 'edit'
    end
  end

  def destroy
    @document = Document.find(params[:id])
    @document.destroy if current_user.id == @document.user_id
    redirect_to user_path(current_user)
  end

  def retrieve_file_path(uploaded_io)
    Rails.root.join('public', 'uploads', uploaded_io.original_filename)
  end

  def public_documents
    @documents = Document.where(is_private: false)
  end

  private

  def document_params
    params.require(:document).permit(:title, :doc_path, :is_private)
  end
end
