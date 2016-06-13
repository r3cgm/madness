module Madness
  # Handle the navigation links for a given directory
  class Navigation
    include ServerHelper

    attr_reader :links, :caption

    def initialize(dir)
      @links = make_links dir
      @caption = File.basename(dir) unless dir == docroot
    end

    private

    # Prepare a list of links from all the accepted items in the directory
    def make_links
      files = get_files dir
      dirs  = get_dirs dir

      links = []

      dirs.sort.each do |item|
        links.push link(item, :dir)
      end

      files.each do |item|
        links.push link(item, :file)
      end

      links
    end

    def get_files(dir)
      files = Dir["#{dir}/*.md"].map { |f| f.sub(/\.md$/, '') }
      files.reject! { |f| File.basename(f) == 'README' }
      files.sort
    end

    def get_dirs(dir)
      dirs  = Dir["#{dir}/*"].select { |f| File.directory? f }
      dirs.reject! do |f| 
        basename = File.basename(f)
        basename[0] == '_' || basename == 'public'}
      end
      dirs
    end

    def link(item, type)
      OpenStruct.new({ 
        label: File.basename(item).tr('-', ' '), 
        href: URI.escape(item.sub(/^#{docroot}/, '')), 
        type: type 
      })
    end
  end
end