class ChurpSerializer
  include JSONAPI::Serializer

  attributes :churp_id, :body, :created_at
end
