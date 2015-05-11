Meteor.publish('fittings', function() {
	Desc.init();

	//Transform function
	var calculateStats = function(doc) {
		var fit = Desc.FromParse(doc);
		doc.stats = fit.getStats();
		return doc;
	}

	var self = this;

	var observer = Fittings.find().observe({
		added: function (document) {
			self.added('fittings', document._id, calculateStats(document));
		},
		changed: function (newDocument, oldDocument) {
			self.changed('fittings', oldDocument._id, calculateStats(newDocument));
		},
		removed: function (oldDocument) {
			self.removed('fittings', oldDocument._id);
		}
	});

	self.onStop(function () {
		observer.stop();
	});

	self.ready();
});