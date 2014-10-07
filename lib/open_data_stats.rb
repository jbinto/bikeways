# n.b. for this purpose, "feature" means "LINEAR FEATURE" a.k.a. a road or route.

require 'feature_walker'

class OpenDataStats
  def display_all_routes
    for id in FeatureWalker.all_feature_ids
      walker = FeatureWalker.new(feature_id: id)
      paths = walker.paths

      path_ids = paths.map { |list| list.map { |path| path.id } }

      if path_ids.length > 1
        puts "lfn_id=#{id} full_street_name=#{FeatureWalker.full_street_name(id)} num_paths=#{paths.length} paths:"
        puts "  --> #{path_ids}"
      end
    end
  end
end