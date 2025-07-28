# frozen_string_literal: true

LetterAvatar.setup do |config|
  config.fill_color = "rgba(255, 255, 255, 1)"
  config.cache_base_path = "public/images"
  config.colors_palette = :iwanthue
  config.weight = 600
  config.annotate_position = "-0+10"
  config.letters_count = 2
  config.pointsize = 220
end
