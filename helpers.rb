def compile_css
  common = 'https://raw.githubusercontent.com/discourse/discourse/master/app/assets/stylesheets/common' # Prefix
  tmp = '/tmp/style'

  system("rm /tmp/style/*")
  system("wget #{common}/foundation/colors.scss -P #{tmp}")
  system("wget #{common}/foundation/variables.scss -P #{tmp}")
  system("wget #{common}/foundation/mixins.scss -P #{tmp}")
  system("wget #{common}/foundation/math.scss -P #{tmp}")
  system("wget #{common}/base/onebox.scss -P #{tmp}")
  system("wget https://raw.githubusercontent.com/phw/discourse-musicbrainz-onebox/master/assets/stylesheets/musicbrainz.scss -P #{tmp}")

  # Append everything here
  scss = File.open("#{tmp}/out.scss", 'a')

  transfer_block("#{tmp}/colors.scss", scss) # All lines
  transfer_excluding_lines("#{tmp}/variables.scss", scss, '@import') # Everything but injected sheets
  transfer_block("#{tmp}/mixins.scss", scss, '@mixin post-aside {') # Just post-aside mix-in block
  transfer_block("#{tmp}/math.scss", scss) # Just sqrt function block
  transfer_block('url-functions.scss', scss) # Just sqrt function block
  transfer_block("#{tmp}/onebox.scss", scss) # All lines
  transfer_block("#{tmp}/musicbrainz.scss", scss) # All lines

  # Discourse-looking font
  scss.puts('aside.onebox, aside.onebox * {
      font-family: Helvetica, Arial, sans-serif;
  }')

  scss.flush
  File.write('style.css', Sass::Engine.new(File.read("#{tmp}/out.scss"), {:syntax => :scss}).render)
end

# Writes from source (path) to destination (File).
# Entire file or a curly bracket contained block beginning with block_opening if supplied.
# Naively assumes that a line beginning in '}' closes the outermost block, which is true for our purposes.
def transfer_block(source, destination, block_opening = nil)
  if block_opening.nil?
    File.open(source) do |f|
      f.each do |line|
        destination.puts line
      end
    end
  else
    File.open(source) do |f|
      block_opened = false
      f.each do |line|
        if !block_opened && line.start_with?(block_opening)
          destination.puts line
          block_opened = true
        elsif block_opened && !line.start_with?('}')
          destination.puts line
        elsif block_opened && line.start_with?('}')
          destination.puts line
          break
        end
      end
    end
  end
end

# Writes from source (path) to destination (File).
# Entire file excluding files including exclusion.
def transfer_excluding_lines(source, destination, exclusion)
  File.open(source) do |f|
    f.each do |line|
      unless line.include?(exclusion)
        destination.puts line
      end
    end
  end
end
