Meteor.subscribe('fittings');

Template['fittings'].helpers({
	fittings: function() {
		return Fittings.find({});
	}
})

Template['addFitting'].helpers({
	AddFittingsSchema: function() {
		return AddFittingsSchema;
	}
});