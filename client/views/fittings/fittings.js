Meteor.subscribe('fittings');

UI.registerHelper('formatNumber', function(context, options) {
	if(context) {
		var decimals = 0;
		if(typeof options === 'number') {
			decimals = options;
		}
		return context.toFixed(decimals).replace(/\d(?=(\d{3})+$)/g, '$&,');
	}
});

var fittings = [];
var totalRep = 0;
Meteor.startup(function() {
	Tracker.autorun(function() {
		fittings = Fittings.find();
		totalRep = _.reduce(fittings.fetch(), function(memo, ship) {
				if(typeof ship.stats.outgoing.shield !== 'undefined') {
					return memo + ship.stats.outgoing.shield.rr * ship.count;
				} else {
					return memo;
				}
			}, 0);
	});
});

Template['fittings'].helpers({
	fittings: function() {
		return Fittings.find();
	},
	totalDPS: function() {
		return _.reduce(Fittings.find().fetch(), function(memo, ship) {
			return memo + ship.stats.damage.total * ship.count;
		}, 0);
	},
	totalRep: function() {
		return totalRep;
	}
});

Template['fittingRow'].helpers({
	'tank': function() {
		if(typeof this.stats.outgoing.shield === 'undefined') {
			return this.stats.tank.resishield * totalRep;
		} else {
			return this.stats.tank.resishield * (totalRep - this.stats.outgoing.shield.rr);
		}
	}
});

Template['addFitting'].helpers({
	AddFittingsSchema: function() {
		return AddFittingsSchema;
	}
});