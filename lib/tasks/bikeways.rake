require 'httparty'
require 'zip'

require 'action_view'
include ActionView::Helpers::NumberHelper   # for number_to_human_size

require 'fileutils'


BIKEWAYS_URL = 'http://opendata.toronto.ca/gcc/bikeways_mtm3.zip'
OPENDATA_DIR = Rails.root.join('vendor/opendata')
BIKEWAYS_FILE = File.join(OPENDATA_DIR, 'bikeways-mtm3.zip')

namespace :bikeways do
  desc "Downloads the Bikeways ESRI shape file from the Toronto open data catalogue (MTM3)"

  task getopendata: :environment do
    if File.exists?(BIKEWAYS_FILE)
      puts "#{BIKEWAYS_FILE} already exists, please delete to redownload"
      next    # n.b. can't `return` from a rake task, ruby explodes
    end

    # download
    FileUtils.mkdir_p OPENDATA_DIR
    print "downloading #{BIKEWAYS_URL} ... "
    File.open(BIKEWAYS_FILE, 'wb') do |f|
      len = f.write HTTParty.get(BIKEWAYS_URL).parsed_response
      puts "#{number_to_human_size(len)} received"
    end

    # unzip
    Zip::File.open(BIKEWAYS_FILE) do |zip|
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
  end

end