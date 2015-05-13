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

Template['fittings'].helpers({
	fittings: function() {
		var fittings = Fittings.find().fetch();
		var totalRep = _.reduce(fittings, function(memo, ship) {
			if(typeof ship.stats.outgoing.shield !== 'undefined') {
				return memo + ship.stats.outgoing.shield.rr * ship.count;
			} else {
				return memo;
			}
		}, 0);

		_.each(fittings, function(ship) {
			var rep = 0;
			if (typeof ship.stats.outgoing.shield !== 'undefined') {
				rep = ship.stats.outgoing.shield.rr;
			}
			ship.tank = ship.stats.tank.resishield * (totalRep - rep);
			ship.ttl = ship.stats.tank.ehpshield / ship.tank;
		});

		console.log(fittings);
		return fittings;
	},
	totalDPS: function() {
		return _.reduce(Fittings.find().fetch(), function(memo, ship) {
			return memo + ship.stats.damage.total * ship.count;
		}, 0);
	}
});

Template['addFitting'].helpers({
	AddFittingsSchema: function() {
		return AddFittingsSchema;
	}
});