class Api::V1::ContactsController < Api::V1::ApiController
  before_action :set_contact, only: [:show, :update, :destroy]
  before_action :require_authorization!, only: [:show, :update, :destroy]

  # GET /api/v1/contacts
  def index
    @contacts = current_user.contacts

    render json: @contacts
  end

  # GET /api/v1/contacts/1
  def show
    render json: @contact
  end

  # POST /api/v1/contacts
  def create
    @contact = Contact.new(contact_params.merge(user: current_user))

    if @contact.save
      render json: @contact, status: :created
    else
      render json: @contact.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /api/v1/contacts/1
  def update
    if @contact.update(contact_params)
      render json: @contact
    else
      render json: @contact.errors, status: :unprocessable_entity
    end
  end

  # DELETE /api/v1/contacts/1
  def destroy
    @contact.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_contact
      @contact = Contact.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def contact_params
      params.require(:contact).permit(:name, :email, :phone, :description)
    end

    def require_authorization!
      unless current_user == @contact.user
        render json: {}, status: :forbidden
      end
    end
end
