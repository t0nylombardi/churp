# frozen_string_literal: true

namespace :seed do
  def hash_tags
    %w[#train #transport #railway #bridge #metro #trains
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
       #saftb #whatisgoingon #youcantseeme #thebird]
  end

  # Populates churps.
  #   Api `rails 'seed:create_churps'`
  desc 'seed n amount of churps'
  task :create_churps, [:num_of_churps] => :environment do |_t, args|
    0.upto(args[:num_of_churps]) do |_i|
      sentence = Faker::Lorem.paragraph_by_chars(number: 200, supplemental: false)
      hash_tag = 5.times.map { hash_tags.sample }.join(' ')

      churp = Churp.create(
        body: sentence + hash_tag,
        user_id: User.all.sample.id
      )
      Rake::Task['seed:create_comments'].invoke(churp:)
      Rake::Task['seed:create_comments'].reenable
      puts "Created churp: #{churp.id} from: #{churp.user.email}"
    end
  end

  task :create_comments, %i[churp] => :environment do |_t, args|
    churp = args[:churp].values.first
    0.upto(10) do |_i|
      churp.comments.create(
        content: Faker::Lorem.sentence(word_count: 20) + 5.times.map { hash_tags.sample }.join(' '),
        user_id: User.all.sample.id
      )
    end
  end
end
