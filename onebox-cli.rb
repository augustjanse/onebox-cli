require "onebox"
require_relative "helpers"

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
  common = 'https://raw.githubusercontent.com/discourse/discourse/master/app/assets/stylesheets/common' # Prefix
  tmp = '/tmp/style'

  system("rm /tmp/style/*")
  system("wget #{common}/base/onebox.scss -P #{tmp}")
  system("wget #{common}/foundation/mixins.scss -P #{tmp}")
  system("wget #{common}/foundation/colors.scss -P #{tmp}")
  system("wget #{common}/foundation/variables.scss -P #{tmp}")
  system("wget https://raw.githubusercontent.com/phw/discourse-musicbrainz-onebox/master/assets/stylesheets/musicbrainz.scss -P #{tmp}")

  # Append everything here
  scss = File.open("#{tmp}/out.scss", 'a')

  transfer_block("#{tmp}/colors.scss", scss) # All lines
  transfer_excluding_lines("#{tmp}/variables.scss", scss, '@import') # Everything but injected sheets
  transfer_block("#{tmp}/mixins.scss", scss, '@mixin post-aside {') # Just post-aside mix-in block
  transfer_block("#{tmp}/onebox.scss", scss) # All lines
  transfer_block("#{tmp}/musicbrainz.scss", scss) # All lines

  # Discourse-looking font
  scss.puts('aside, aside * {
      font-family: Helvetica, Arial, sans-serif;
  }')
end

Onebox.options.load_paths.push(File.join(File.dirname(__FILE__), "discourse-musicbrainz-onebox/templates"))
url = "https://musicbrainz.org/artist/79ba6a62-037c-4f16-bbf3-8fe8b363451b"
preview = Onebox.preview(url)
puts preview.to_s #=> true
