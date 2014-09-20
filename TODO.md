## 2014-09-19

* **DONE** ~~load city's updated Sept 2014 dataset, do a quick sanity check~~
* **WONTFIX** (see issue #10) ~~continue work on code to import Intersections dataset~~
  (n.b: there was some sort of doubt the last time I looked at this as to whether the information was complete
  enough to identify an intersection, and I walked away from the issue more confused than ever. Get some clarity on this.)

* update all gems, ruby, rails versions
* update ansible provisioner, 416.bike staging env
* devise way during import process to isolate distinct routes, assign them a unique id
  (this is essentially 'walking' the route as we've already done, but memoizing the route number so we don't have to perform the processing each time)

* continue manual research including:
   * route photography
   * route exploration on street view
   * notekeeping in `doc/`

* once we have distinct routes, add a #show action
   * this will be the same as the Segment show action but will show multiple segments on one map
   * add some nifty statistics like length, etc.

* get some rough statistics showing on the front page of 416.bike, e.g. "total km in city"

* spend some time polishing the front page CSS (foundation?)

* investigate gems for reviews, comments, SSO... maybe just disqus for now?
