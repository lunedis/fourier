@Doctrines = new Mongo.Collection 'doctrines'

Doctrines.attachSchema new SimpleSchema
	name:
		type: String
		label: "Name"
		max: 100
	links:
		type: String
		label: "Links"
		allowedValues: ['none', 'kiting', 'armor', 'shield']
	description:
		type: String
		label: "Description"
		optional: true
		autoform:
			rows: 5
	fittings:
		type: Array
		label: "Fittings"
		optional: true
		autoform:
			omit: true
	'fittings.$':
		type: String

Doctrines.allow
	insert: ->
		true
	update: ->
		true
	remove: ->
		true