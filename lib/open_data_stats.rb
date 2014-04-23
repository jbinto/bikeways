# n.b. for this purpose, "feature" means "LINEAR FEATURE" a.k.a. a road or route.

require 'feature_walker'

class OpenDataStats
  def display_all_routes
    for id in all_feature_ids
      walker = FeatureWalker.new(feature_id: id)
      paths = walker.paths

      path_ids = paths.map { |list| list.map { |path| path.id } }


      if path_ids.length > 1
        puts "lfn_id=#{id} full_street_name=#{full_street_name(id)} num_paths=#{paths.length} paths:"
        puts "  --> #{path_ids}"
      end
    end
  end


  def all_feature_ids
    BikewaySegment.pluck(:city_linear_feature_name_id).uniq.sort
  end

  def full_street_name(feature_id)
    BikewaySegment.where(:city_linear_feature_name_id => feature_id).first!.full_street_name
  end

end