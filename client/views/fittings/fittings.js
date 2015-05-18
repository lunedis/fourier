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
	fittingsWithTank: function() {
		//data-context: doctrine object
		if(typeof this.fittings === 'undefined' || this.fittings.length === 0) {
			return [];
		}
		var fittings = Fittings.find({_id: {$in: this.fittings}}).fetch();
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

		return fittings;
	},
	totalDPS: function() {
		if(typeof this.fittings === 'undefined' || this.fittings.length === 0) {
			return 0;
		}
		return _.reduce(Fittings.find({_id: {$in: this.fittings}}).fetch(), function(memo, ship) {
			return memo + ship.stats.damage.total * ship.count;
		}, 0);
	}
});

Template['addFitting'].helpers({
	AddFittingsSchema: function() {
		return AddFittingsSchema;
	}
});

AutoForm.addHooks("addFittingForm", {
	after: {
		method: function(error, result) {
			if(typeof error === 'undefined') {
				var doctrineID = Router.current().params._id;
				Doctrines.update(doctrineID, {$push: {fittings: result}});
			} else {
				console.log(error);
			}
		}
	}
})