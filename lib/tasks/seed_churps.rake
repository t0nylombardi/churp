# frozen_string_literal: true

namespace :seed do
  def hash_tags
    %w(#train #transport #railway #bridge #metro #trains
       #trainspotting #trainphotography #ns #rail #freight #railroad
       #railwayphotography #railways_of_our_world #trainstation #railwaystation
       #station #railways #tram #trainstagram #trainspotter #railfan
       #railfans_of_instagram #locomotive #publictransport #railfanning
       #railroadphotography #traingraffiti #freightgraffiti #towers
       #easterbasket #goose #birdfeeder #audobonsociety #greatblueheron
       #petbirds #xslasvegas #birdfeeding #feedthebirds #chirpchirp
       #cedarwaxwing #babygeese #whatsgoingon #worlddomination #babyducks
       #getoffmylawn #chirp #localwildlife #cheezits #goldeneagles #redbirds
       #cloudywithachanceofmeatballs #highjumper #canadiangeese #daft #whatsinaname
       #saftb #whatisgoingon #youcantseeme #thebird)
  end

  # Populates churps.
  #   Api `rails 'seed:create_churps'`
  desc 'seed n amount of churps'
  task :create_churps, [:num_of_churps] => :environment do |_t, args|
    valid_churps = []
    invalid_churps = []
    0.upto(args[:num_of_churps]) do |_i|
      sentence = Faker::Lorem.paragraph_by_chars(number: 200, supplemental: false)
      hash_tag = Array.new(5) { hash_tags.sample }.join(' ')

      churp = Churp.new(
        content: sentence + " #{User.all.sample.username} " + hash_tag,
        user_id: User.all.sample.id
      )

      0.upto(10) do |_i|
        churp.comments.build(
          content: Faker::Lorem.sentence(word_count: 20) + Array(5) { hash_tags.sample }.join(' '),
          user_id: User.all.sample.id
        )
      end
      if churp.valid?
        valid_churps << churp
      else
        invalid_churps << churp
      end

      valid_churps.each do |c|
        c.run_callbacks(:save) { false }
        c.run_callbacks(:create) { false }
      end
    end

    Churp.import valid_churps, recursive: true
  end
end
