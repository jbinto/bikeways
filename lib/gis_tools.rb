class GISTools < ActiveRecord::Base
  def self.length_m(geom, strategy=:rgeo)
    case strategy
    when :postgis
      # Custom SQL query without Corresponding Table
      # http://stackoverflow.com/a/1285117/19779
      sql = "select st_length(st_geomfromtext(?)::geography) as length;"
      result = self.connection.execute sanitize_sql([sql, geom.as_text])
      result.first['length'].to_f
    when :rgeo
      # reference: http://daniel-azuma.com/articles/georails/part-4
      wgs84_factory = RGeo::Geographic.spherical_factory(:srid => 4326)
      geography = RGeo::Feature.cast(geom, :factory => wgs84_factory, :project => true)
      geography.length
    end
  end

  def self.street_union
    # This query simplifies the geometry significantly, by merging adjacent lines
    # of the same bikeway type.

    # It will reduce the number of records from about 6,800 to about 900.

    # The tradeoff is we lose granularity.
    # The only thing we can keep is the high/low address, the bikeway type, and optionally
    # the street classification.

    # Adapted from https://gis.stackexchange.com/questions/16698/join-intersecting-lines-with-postgis
    sql = '
          select
            st_linemerge(st_union(geom)) as geom,
            full_street_name,
            bikeway_type,
            /* street_classification, */
            max(highest_address_right) as highest_address_right,
            max(highest_address_left) as highest_address_left,
            min(nullif(lowest_address_left, 0)) as lowest_address_left,
            min(nullif(lowest_address_right, 0)) as lowest_address_right
          from segments
          group by full_street_name, bikeway_type
    '

    # note: Could also add sum(length_m) as an aggregate function here, if needed.

    result = self.connection.execute sanitize_sql([sql])
    result.to_a
  end

end