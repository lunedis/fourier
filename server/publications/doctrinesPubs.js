Meteor.publish('doctrines', function() {
	return Doctrines.find();
});