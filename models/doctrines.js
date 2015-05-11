Doctrines = new Mongo.Collection('doctrines');

Doctrines.attachSchema(new SimpleSchema(
{
	name: {
		type: String,
		label: "Name",
		max: 100,
	},
	links: {
		type: String,
		label: "Links",
		allowedValues: ['none', 'kiting', 'armor', 'shield']
	},
	description: {
		type: String,
		label: "Description",
		autoform: {
			rows: 5
		}
	},
	fittings: {
		type: Array,
		label: "Fittings",
		optional: true
	},
	'fittings.$': {
		type: String,
	}
}));

Doctrines.allow( {
	insert: function() {
		return true;
	},
	update: function() {
		return true;
	},
	remove: function() {
		return true;
	}
});