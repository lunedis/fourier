Router.route('/', {
	name: 'home',
	action: function() {
		this.render('doctrines');
  		SEO.set({ title: 'Home - ' + Meteor.App.NAME });
	},
	waitOn: function() {
		return Meteor.subscribe('doctrines');
	},
	fastRender: true
});

Router.route('/doctrines/:_id', {
	action: function() {
		this.render('fittings', {
			data: function() {
				return Doctrines.findOne(this.params._id);
			}
		});
	},
	waitOn: function() {
		return [Meteor.subscribe('fittings'), Meteor.subscribe('doctrines')];
	},
	fastRender: true
})