require 'rails_helper'

RSpec.describe Event, type: :model do
  subject { build(:event) }
    describe "validations" do
        it 'should be valid with valid attributes' do
            expect(subject).to be_valid
        end
        
        it 'should not be valid without a user' do
            subject.user = nil
            expect(subject).to_not be_valid
        end

        it 'should not be valid without a date' do
            subject.date = nil
            expect(subject).to_not be_valid
        end

        it 'should not be valid with a past date' do
            subject.date = Date.today - 1.day
            expect(subject).to_not be_valid
        end

        it 'should not valid be without an event_status' do
            subject.event_status = nil
            expect(subject).to_not be_valid
        end

        it 'should not valid be with an invalid event_status' do
            subject.event_status = "INVALID_STATUS"
            expect(subject).to_not be_valid
        end
    end

    describe "associations" do
        it { should belong_to(:user) }
        it { should have_many(:slots) }
    end
end