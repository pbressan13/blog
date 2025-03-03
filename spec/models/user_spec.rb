# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  it { should have_many(:posts).dependent(:destroy) }
  it { should have_many(:ratings).dependent(:destroy) }

  it { should validate_presence_of(:login) }
end
