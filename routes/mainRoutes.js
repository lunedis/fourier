Router.route('/', {
	name: 'home',
	action: function() {
		this.render('fittings');
  		SEO.set({ title: 'Home - ' + Meteor.App.NAME });
	},
	fastRender: true
});