require 'rails_helper'

RSpec.describe Payment, type: :model do
  subject { build(:payment) }
    describe "validations" do
        it 'is valid with valid attributes' do
            expect(subject).to be_valid
        end

        it 'is not valid without a user' do
            subject.user = nil
            expect(subject).to_not be_valid
        end

        it 'is not valid without a registration' do
            subject.registration = nil
            expect(subject).to_not be_valid
        end

        it 'is not valid without an amount' do
            subject.amount = nil
            expect(subject).to_not be_valid
        end

        it 'is not valid with a non-numeric amount' do
            subject.amount = "one hundred"
            expect(subject).to_not be_valid
        end

        it 'is not valid with an amount less than or equal to 0' do
            subject.amount = 0
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
        it { should belong_to(:registration) }
    end
end