# spec/models/access_role_spec.rb
require 'rails_helper'

RSpec.describe AccessRole, type: :model do
  subject { build(:access_role) }

  it 'should be valid with valid attributes' do
    expect(subject).to be_valid
  end

  it 'should not be valid without a role' do
    subject.role = nil
    expect(subject).to_not be_valid
  end

  it 'is not valid with an invalid role' do
    subject.role = nil
    expect(subject).to_not be_valid
  end
end