@Panels = new Mongo.Collection 'panels'

Panels.attachSchema new SimpleSchema
  view:
    type: String
    label: "Parent View"
  type:
    type: String
    label: "Type"
  title:
    type: String
    label: "Title"
    optional: true
  data:
    type: Object
    optional: true
    blackbox: true

Panels.allow
  insert: ->
    true
  update: ->
    true
  remove: ->
    true