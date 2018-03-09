# onebox-cli
Generates a [Onebox](https://github.com/discourse/onebox) element from an URL and fetches some stylesheets. Most of the effort went into figuring out what stylesheets from [discourse/discourse](https://github.com/discourse/discourse) that I needed to make it look good. Also necessary parts from [phw/discourse-musicbrainz-onebox](https://github.com/phw/discourse-musicbrainz-onebox), which is written as a Discourse plugin.

Run

    bundle

before running. Additionally depends on `git` and `wget`. Then run

    ruby onebox-cli.rb [url]

which will output an HTML element that you can paste in your HTML and a `style.css` that you can include. Optionally, you can install `xclip` and do

    ruby onebox-cli.rb [url] | xclip -selection c

to get it straight to your clipboard.
