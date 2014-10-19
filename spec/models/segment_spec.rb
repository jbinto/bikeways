require 'spec_helper'

describe BikewaySegment do

  # XXX HACK FIXME:
  # This is a pretty brittle test.
  # Excuse: I wanted to get *something* done in a TDD fashion to whet my appetite.
  #
  # Problems with this test:
  # 1) It has hardcoded expected and actuals that are opaque and based on the result
  #    of running it by hand in postgresql.
  #
  # 2) It is tightly coupled to the SRID of the database (though perhaps this could be
  #    argued to be a poor-mans-smoke-test, if the SRID ever changes this will fail)
  #
  # 3) It actually hits the DB, which is bad form, but so is the .kml method itself.
  #
  # 4) The rounding/floating point semantics may change between platforms/implementations.

  # It does function as a fine smoke test to ensure the SRID is correct.

  it "should be able to render itself as KML" do
    segment = FactoryGirl.create(:bikeway_segment,
      :geom => "MULTILINESTRING ((-79.521209665 43.590895067, -79.522533939 43.590800049))")

    actual = segment.kml
    expected = "<MultiGeometry><LineString><coordinates>-79.521209665000001,43.590895066999998 -79.522533938999999,43.590800049000002</coordinates></LineString></MultiGeometry>"

    expect(actual).to eq(expected)
  end

end
