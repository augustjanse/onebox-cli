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

Onebox.options.load_paths.push(File.join(File.dirname(__FILE__), "discourse-musicbrainz-onebox/templates"))
url = "https://musicbrainz.org/artist/79ba6a62-037c-4f16-bbf3-8fe8b363451b"
preview = Onebox.preview(url)
puts preview.to_s #=> true
