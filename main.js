
Publisher = Backbone.View.extend({
    initialize: function() {
      _.bindAll(this, 'render');
      this.model.bind('change', this.render);
    },
    
    render: function() {
      $(this.el).html(this.model.get('html'));
    }
})


var body_model = new Backbone.Model();
var header_model = new Backbone.Model();
var header_view = new Publisher({ el: $("#header"), model: header_model });
var body_view = new Publisher({ el: $("#body"), model: body_model});  


AppRouter = Backbone.Router.extend({
  routes: {
    ":id": "set",
    "*actions": "set",
  },
  set: function(id) {
    try {

      header_model.set({html: _.template( $("#_header").html(), {active: id} )});      
      $(".menuBar").lavaLamp({ fx: "backout", speed: 300 })
      
      
      body_model.set({html: _.template( $("#_body_" + id).html(), {} )});
    } catch (err) {
      //run page 0 as the default page
      this.set('home');
    }
  },
});

var app_router = new AppRouter;
Backbone.history.start();
