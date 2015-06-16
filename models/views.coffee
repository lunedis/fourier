@Views = new Mongo.Collection 'views'

Views.attachSchema new SimpleSchema
  doctrine:
    type: String
    label: "Doctrine"
  title:
    type: String
    label: "Title"

Views.allow
  insert: ->
    true
  update: ->
    true
  remove: ->
    true