# frozen_string_literal: true

require "rails_helper"

# RSpec.describe Churps::Mentions::Policy do
#   describe ".allowed?" do
#     let(:author) { instance_double("User", id: "author-id") }
#     let(:mentioned_user) { instance_double("User", id: "mentioned-id") }
#     let(:churp) { instance_double("Churp", private?: false, visible_to?: true) }

#     before do
#       allow(author).to receive(:blocked?).with(mentioned_user).and_return(false)
#       allow(mentioned_user).to receive(:blocked?).with(author).and_return(false)
#     end

#     it "allows mentions when no policy rule blocks it" do
#       result = described_class.allowed?(
#         author: author,
#         mentioned_user: mentioned_user,
#         churp: churp
#       )

#       expect(result).to be(true)
#     end

#     it "disallows self-mentions" do
#       allow(mentioned_user).to receive(:id).and_return("author-id")

#       result = described_class.allowed?(
#         author: author,
#         mentioned_user: mentioned_user,
#         churp: churp
#       )

#       expect(result).to be(false)
#     end

#     it "disallows mentions when author blocks mentioned user" do
#       allow(author).to receive(:blocked?).with(mentioned_user).and_return(true)

#       result = described_class.allowed?(
#         author: author,
#         mentioned_user: mentioned_user,
#         churp: churp
#       )

#       expect(result).to be(false)
#     end

#     it "disallows mentions when mentioned user blocks author" do
#       allow(mentioned_user).to receive(:blocked?).with(author).and_return(true)

#       result = described_class.allowed?(
#         author: author,
#         mentioned_user: mentioned_user,
#         churp: churp
#       )

#       expect(result).to be(false)
#     end

#     it "disallows mentions when churp is private and not visible" do
#       allow(churp).to receive(:private?).and_return(true)
#       allow(churp).to receive(:visible_to?).with(mentioned_user).and_return(false)

#       result = described_class.allowed?(
#         author: author,
#         mentioned_user: mentioned_user,
#         churp: churp
#       )

#       expect(result).to be(false)
#     end
#   end
# end
