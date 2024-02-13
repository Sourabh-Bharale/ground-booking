require 'rails_helper'

RSpec.describe UsersController, type: :controller do

  before do
    @user = create :user
    add_headers(@user)
    seed_data
  end

  describe "GET search" do
    context "when users are found" do 
      it "should return a 200" do
        get :search, params: {user_name: @user.user_name}
        expect(response).to have_http_status(:ok)
      end
    end

    context "when no users are found" do 
      it "should return a 404" do
        get :search, params: {user_name: "randomNonExistingUserName"}
        expect(response).to have_http_status(:not_found)
      end
    end
  end

  describe "GET current_user_registrations" do
    it "should return registrations of current user" do
      get :current_user_registrations
      expect(response).to have_http_status(:ok)
    end
  end

  describe "POST create" do
    it "should return error if role is invalid" do
      post :create, params: {user: {role_type: 'SUPER_ADMIN'}}
      expect(response).to have_http_status(:bad_request)
    end

    it "should create a user with valid params" do
      post :create, params: {user: 
      {
        user_name:"sourabh_admin2",
        role_type:"ADMIN",
        mobile_no:"0000000000",
        password: "0000000000"
        }}

      expect(response).to have_http_status(:created)
  end

end
  
  describe "POST all_registration of a user" do
    let(:admin_role) { AccessRole.find_by(role: 'ADMIN') }
    let(:admin) { create(:user , access_role: admin_role ) }
    let(:user) {create(:user)}
    let(:registrations) { create_list(:registration, 3, user: user) }
     
    context "when access_role is admin" do
      before do
        add_headers(admin)
      end
  
      it "should return all registration of user" do
        post :all_registrations, params: { user_id: admin.id }
        expect(response).to have_http_status(:ok)
      end
    end

    context "when access_role is not admin" do
      it "should return forbidden status" do
        post :all_registrations, params: { user_id: user.id }
        expect(response).to have_http_status(:forbidden)
      end
    end
  end


end