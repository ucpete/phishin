# frozen_string_literal: true
require 'rails_helper'

RSpec.describe PlaylistBookmark do
  subject { build(:playlist_bookmark) }

  it { is_expected.to belong_to(:playlist) }
  it { is_expected.to belong_to(:user) }
end