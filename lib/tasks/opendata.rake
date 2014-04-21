require 'open_data_import'
require 'open_data_stats'

namespace :opendata do
  desc "Downloads the Bikeways ESRI shape file from the Toronto open data catalogue (MTM3)"
  task init: :environment do
    OpenDataImport.new.reset
  end

  desc "Downloads the Bikeways data even if it already exists"
  task reset: :environment do
    OpenDataImport.new(force: true).reset
  end

  task download: :environment do
    OpenDataImport.new.download
  end

  task unzip: :environment do
    OpenDataImport.new.unzip
  end

  task import: :environment do
    OpenDataImport.new.import
  end

  namespace :stats do
    desc "uses SegmentWalker to walk all of the routes, output to console"
    task walk_all_routes: :environment do
      OpenDataStats.new.walk_all_routes
    end
  end
end

