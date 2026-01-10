# frozen_string_literal: true

module Results
  class Result
    def success?
      raise NotImplementedError
    end

    def failure?
      !success?
    end
  end
end
