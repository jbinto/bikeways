# Load the Rails application.
require File.expand_path('../application', __FILE__)

STYLE_ID_CODES = {
  "Suggested On-Street Connections" => "suggestedConnections",
  "Sharrows" => "sharrows",
  "Signed Routes" => "signedRoutes",
  "Cycle Tracks" => "cycleTracks",
  "Contra-Flow Bike Lanes" => "contraFlow",
  "Suggested On-Street Routes" => "suggestedOnStreet",
  "Minor Multi-use Pathway" => "minorMultiUse",
  "Park Roads Cycling Connections" => "parkRoads",
  "Major Multi-use Pathway" => "majorMultiUse",
  "Bike Lanes" => "bikeLanes",
  "Informal Dirt Footpath" => "informalDirtFootpath"
}

# Initialize the Rails application.
Rails.application.initialize!
