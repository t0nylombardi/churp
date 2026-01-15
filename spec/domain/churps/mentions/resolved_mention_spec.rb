# frozen_string_literal: true

# require "rails_helper"

# RSpec.describe Churps::Mentions::ResolvedMention do
#   describe ".new" do
#     it "builds a resolved mention with a mention and user id" do
#       mention = Churps::Mentions::Mention.new(
#         username: "alice",
#         start_index: 0,
#         end_index: 6
#       )

#       resolved = described_class.new(
#         mention: mention,
#         mentioned_user_id: "user-id"
#       )

#       expect(resolved.mention).to eq(mention)
#       expect(resolved.mentioned_user_id).to eq("user-id")
#     end

#     it "rejects invalid mention types" do
#       expect do
#         described_class.new(
#           mention: "not-a-mention",
#           mentioned_user_id: "user-id"
#         )
#       end.to raise_error(Dry::Struct::Error)
#     end
#   end
# end
