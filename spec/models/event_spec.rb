require 'rails_helper'

RSpec.describe Event, type: :model do
  describe ".create" do
    subject { Event.create!(name: name, user: user, payload: payload) }

    let(:user) { create(:user) }
    let(:name) { "event-name" }
    let(:payload) { { "foo" => "bar", "baz" => "bing" }.to_json }

    it { is_expected.to be_present }
    its(:name) { should eql name }
    its(:user) { should eql user }
    its(:payload) { should eql payload }
  end
end
