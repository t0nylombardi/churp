# frozen_string_literal: true

class ChurpHashTag < ApplicationRecord
  belongs_to :churp
  belongs_to :hash_tag
end
