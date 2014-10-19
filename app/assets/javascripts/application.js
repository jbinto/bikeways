//= require jquery
//= require jquery_ujs
//= require bootstrap
//= require underscore
//= require gmaps/google
//= require gistyle
//= require_tree .

// XXX make this only required on the segments#index page
//= require dataTables/jquery.dataTables
//= require dataTables/bootstrap/3/jquery.dataTables.bootstrap


// I have come to the conclusion that Turbolinks is evil.
//
// To be fair, I gave it a chance. I listened on 'page:load', I used `jquery-turbolinks`,
// but it doesn't play nicely with the gmaps4rails gem and the maintainer of that gem has
// arrived at the same conclusion as I.
//
// It breaks the Principle of Least Astonishment which is very un-Ruby like.
// Whereas I could test my pages before in isolation, now I need to build up crufty state
// to cause application breakage. ("It only breaks when you go from here, to there, THEN here".
//
// This note left for posterity.
//  require turbolinks

