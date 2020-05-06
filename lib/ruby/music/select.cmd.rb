require 'music/music_db.rb'

module MusicCMD

  def select(opts)
    opts.banner = "Usage: select [OPTS]"
    opts.info = "Select items to set as the playlist using `cmus-remote`"
    opts.on("-f", "--filter FILTER", "Any string that `jq` will accept -- default: .playlist") { |jqf|
      $options[:filter] = jqf
    }
    opts.on("-t", "--filter-by-tags", "Filter by tags") {
      $options[:filter] = "select(.tags) | .tags | .[]"
    }
    lambda {
      $options[:filter] = ".playlist" if not $options[:filter]
      result = self.search_impl()
      items = result.split "\n"
      p "items: #{items}" if $options[:verbose]
      if not items.empty?
        %x< cmus-remote -c >
        items.each do |item|
          files = MusicDB.find item, $options[:filter]
          files.split("\n").each do |f|
            %x< cmus-remote $MUSIC_DIR/#{f} >
          end
        end
      end
    }
  end

end
