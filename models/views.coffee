@Views = new Mongo.Collection 'views'

Views.attachSchema new SimpleSchema
  title:
    type: String
    label: "Title"
  layout:
    type: Array
    label: "Layout"
  'layout.$':
    type: Object
    blackbox: true
    optional: true


Views.allow
  insert: ->
    true
  update: ->
    true
  remove: ->
    true