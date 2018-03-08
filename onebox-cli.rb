require "onebox"

2.times do
  begin
    require_relative 'discourse-musicbrainz-onebox/engine/musicbrainz_artist_onebox'
    require_relative 'discourse-musicbrainz-onebox/engine/musicbrainz_event_onebox'
    require_relative 'discourse-musicbrainz-onebox/engine/musicbrainz_label_onebox'
    require_relative 'discourse-musicbrainz-onebox/engine/musicbrainz_place_onebox'
    require_relative 'discourse-musicbrainz-onebox/engine/musicbrainz_recording_onebox'
    require_relative 'discourse-musicbrainz-onebox/engine/musicbrainz_release_onebox'
    require_relative 'discourse-musicbrainz-onebox/engine/musicbrainz_releasegroup_onebox'
    require_relative 'discourse-musicbrainz-onebox/engine/musicbrainz_work_onebox'
  rescue LoadError
    system('git clone https://github.com/phw/discourse-musicbrainz-onebox.git')
  end
end

unless File.exist?('style.css')
  common = 'https://raw.githubusercontent.com/discourse/discourse/master/app/assets/stylesheets/common/' # Prefix
  tmp = '/tmp/style/'

  system("rm /tmp/style/*")
  system("wget #{common}/base/onebox.scss -P #{tmp}")
  system("wget #{common}/foundation/mixins.scss -P #{tmp}")
  system("wget #{common}/foundation/colors.scss -P #{tmp}")
  system("wget #{common}/foundation/variables.scss -P #{tmp}")
  system("wget https://raw.githubusercontent.com/phw/discourse-musicbrainz-onebox/master/assets/stylesheets/musicbrainz.scss -P #{tmp}")

  # Onebox Sass, append everything here
  scss = File.open("#{tmp}/onebox.scss", 'a')

  # Just post-aside mix-in block
  File.open("#{tmp}/mixins.scss") do |f|
    block_opened = false
    f.each do |line|
      if !block_opened && line.include?('@mixin post-aside {')
        scss.puts line
        block_opened = true
      elsif block_opened && !line.include?('}')
        scss.puts line
      elsif block_opened && line.include?('}')
        scss.puts line
        break
      end
    end
  end

  # All lines
  File.open("#{tmp}/colors.scss") do |f|
    f.each do |line|
      scss.puts line
    end
  end

  # Everything but injected sheets
  File.open("#{tmp}/variables.scss") do |f|
    f.each do |line|
      unless line.include?('@import')
        scss.puts line
      end
    end
  end

  # All lines
  File.open("#{tmp}/musicbrainz.scss") do |f|
    f.each do |line|
      scss.puts line
    end
  end

  # Discourse-looking font
  scss.puts('aside, aside * {
      font-family: Helvetica, Arial, sans-serif;
  }')
end

Onebox.options.load_paths.push(File.join(File.dirname(__FILE__), "discourse-musicbrainz-onebox/templates"))
url = "https://musicbrainz.org/artist/79ba6a62-037c-4f16-bbf3-8fe8b363451b"
preview = Onebox.preview(url)
puts preview.to_s #=> true
