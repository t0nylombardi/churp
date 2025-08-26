# frozen_string_literal: true

module ChurpSocial
  module Version
    module_function

    def major
      0
    end

    def minor
      4
    end

    def patch
      2
    end

    def default_prerelease
      "alpha.0"
    end

    def prerelease
      ENV["CHURP_VERSION_PRERELEASE"].presence || default_prerelease
    end

    def build_metadata
      ENV.fetch("CHURP_VERSION_METADATA", nil)
    end

    def to_a
      [major, minor, patch].compact
    end

    def to_s
      components = [to_a.join(".")]
      components << "-#{prerelease}" if prerelease.present?
      components << "+#{build_metadata}" if build_metadata.present?
      components.join
    end

    # specify git tag or commit hash here
    def source_tag
      ENV.fetch("SOURCE_TAG", nil)
    end
  end
end
