require 'rails_helper'

RSpec.describe Slot, type: :model do
  subject { build(:slot) }
    describe "validations" do
        
        it 'should be valid with valid attributes' do
            expect(subject).to be_valid
        end

        it 'should not be valid without an event' do
            subject.event = nil
            expect(subject).to_not be_valid
        end

        it 'should not be valid without a time_slot' do
            subject.time_slot = nil
            expect(subject).to_not be_valid
        end

        it 'should not be valid with an invalid time_slot' do
            subject.time_slot = "INVALID_TIME_SLOT"
            expect(subject).to_not be_valid
        end

        it 'should not be valid without a status' do
            subject.status = nil
            expect(subject).to_not be_valid
        end

        it 'should not be valid with an invalid status' do
            subject.status = "INVALID_STATUS"
            expect(subject).to_not be_valid
        end
    end

    describe "associations" do
        it { should belong_to(:event) }
        it { should have_one(:registration) }
    end
end