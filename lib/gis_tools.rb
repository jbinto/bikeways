class GISTools < ActiveRecord::Base
  def self.length_m(geom, strategy=:rgeo)
    case strategy
    when :postgis
      # Custom SQL query without Corresponding Table
      # http://stackoverflow.com/a/1285117/19779
      sql = "select st_length(st_geomfromtext(?)::geography) as length;"
      result = self.connection.execute sanitize_sql([sql, geom.as_text])
      binding.pry
      result.first['length'].to_f
    when :rgeo
      # reference: http://daniel-azuma.com/articles/georails/part-4
      wgs84_factory = RGeo::Geographic.spherical_factory(:srid => 4326)
      geography = RGeo::Feature.cast(geom, :factory => wgs84_factory, :project => true)
      geography.length
    end
  end
end