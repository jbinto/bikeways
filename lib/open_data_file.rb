class OpenDataFile
  OPENDATA_DIR = Rails.root.join('vendor/opendata')
  attr_accessor :url, :zipfile, :shapefile

  def initialize(opts)
    @url = opts[:url]
    @zipfile = opts[:zipfile]
    @shapefile = opts[:shapefile]
    @force = opts[:force] ||= false
  end

  def download
    if File.exists?(@zipfile)
      print "#{@zipfile} already exists"
      unless @force
        puts ", please delete to redownload or use rake opendata:reset to start over"
        return false
      end
    end

    FileUtils.mkdir_p OPENDATA_DIR
    print "downloading #{@url} ... "
    File.open(@zipfile, 'wb') do |f|
      len = f.write HTTParty.get(@url).parsed_response
      puts "#{number_to_human_size(len)} received"
    end

    true
  end

  def unzip
    Zip::File.open(@zipfile) do |zip|
      zip.each do |file|
        dest = File.join('vendor/opendata', file.to_s)
        if File.exists? dest
          puts "already exists, skipping: #{file}"
          next
        end

        puts "extracting: #{file}"
        file.extract File.join('vendor/opendata', file.to_s)
      end
    end

    true
  end
end