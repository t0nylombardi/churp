# frozen_string_literal: true

namespace :release do
  desc "Create and push a git tag from ChurpSocial::Version"
  task :tag do
    require_relative "../churp_social/version"

    version = ChurpSocial::Version.to_s
    tag = "v#{version}"

    puts "Creating git tag #{tag}..."

    unless system("git diff --quiet")
      abort "❌ Working tree is dirty. Commit changes first."
    end

    unless system("git tag -a #{tag} -m \"Release #{tag}\"")
      abort "❌ Failed to create git tag"
    end

    unless system("git push origin #{tag}")
      abort "❌ Failed to push git tag"
    end

    puts "✅ Released #{tag}"
  end
end
