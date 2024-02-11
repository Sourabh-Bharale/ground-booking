# spec/models/registration_spec.rb
require 'rails_helper'

RSpec.describe Registration, type: :model do
  subject { build(:registration) }

  describe "validations" do
    it 'is valid with valid attributes' do
        expect(subject).to be_valid
    end

    it 'is not valid without a user' do
        subject.user = nil
        expect(subject).to_not be_valid
    end

    it 'is not valid without a slot' do
        subject.slot = nil
        expect(subject).to_not be_valid
    end

    it 'is not valid without a status' do
        subject.status = nil
        expect(subject).to_not be_valid
    end

    it 'is not valid with an invalid status' do
        subject.status = "INVALID_STATUS"
        expect(subject).to_not be_valid
    end
  end

  describe "associations" do
    it { should belong_to(:user) }
    it { should belong_to(:slot) }
    it { should have_one(:payment) }
  end
end