# Writes from source (path) to destination (File).
# Entire file or a curly bracket contained block beginning with block_opening if supplied.
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
        if !block_opened && line.include?(block_opening)
          destination.puts line
          block_opened = true
        elsif block_opened && !line.include?('}')
          destination.puts line
        elsif block_opened && line.include?('}')
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
