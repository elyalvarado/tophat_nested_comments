require 'rails_helper'

RSpec.describe Comment, type: :model do
  it 'content should not be empty' do
    comment = FactoryBot.build(:comment, content: '')
    expect(comment).not_to be_valid
  end

  it 'content should be present' do
    comment = FactoryBot.build(:comment, content: nil)
    expect(comment).not_to be_valid
  end
end
