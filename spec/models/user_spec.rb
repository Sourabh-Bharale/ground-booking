require 'rails_helper'

RSpec.describe User, type: :model do
  let(:spec_access_role) { create(:access_role) }
  subject{ build(:user) }

  describe "validations" do
    it 'should be valid with valid attributes' do
      expect(subject).to be_valid
    end

    it 'should not be valid without a user_name' do
      subject.user_name = nil
      expect(subject).to_not be_valid
    end

    it 'should not be valid without a mobile_no' do
      subject.mobile_no = nil
      expect(subject).to_not be_valid
    end

    it 'should not be valid without a password' do
      subject.password = nil
      expect(subject).to_not be_valid
    end

    it 'should not be valid without a access_role_id' do
      subject.access_role_id = nil
      expect(subject).to_not be_valid
    end

    it 'should not be valid with a mobile_no less than 10' do
      subject.mobile_no = "123456789"
      expect(subject).to_not be_valid
    end

    it 'should not be valid with a mobile_no greater than 15' do
      subject.mobile_no = "1234567890123456"
      expect(subject).to_not be_valid
    end

    it 'should not be valid with a mobile_no that is not a number' do
      subject.mobile_no = "123456789a"
      expect(subject).to_not be_valid
    end

    it 'should not be valid with a password less than 6' do
      subject.password = "12345"
      expect(subject).to_not be_valid
    end

    it 'should not be valid with a password greater than 15' do
      subject.password = "1234567890123456"
      expect(subject).to_not be_valid
    end

    it 'should not be valid with a mobile_no that is not unique' do
      subject.save
      duplicate_user = User.new(
        user_name: "Jane",
        mobile_no: "1234567890",
        password: "password",
        access_role_id: spec_access_role
      )
      expect(duplicate_user).to_not be_valid
    end
  end

  describe "associations" do
    it { should belong_to(:access_role) }
    it { should have_many(:events) }
    it { should have_many(:registrations) }
    it { should have_many(:payments) }
  end

end
