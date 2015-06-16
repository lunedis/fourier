Template.mitigation.rendered = ->
  this.autorun ->
    panelData = Template.currentData().data
    fittings = Fittings.find({_id: {$in: panelData.fittings}}).fetch()

    $('#dmgMitigation').highcharts
      title:
        text:
          ''
      chart:
        type: 'spline'
      plotOptions:
        series:
          animation: false
        spline:
          marker:
            enabled: false
       tooltip:
        crosshairs: true,
        valueDecimals: 0,
        headerFormat: '<span>{point.key}k:</span><br/>'
      yAxis:
        min: 0
        max: panelData.attackerDamageStats.total
      xAxis:
        min: 0
      series: _.map fittings, (ship) ->
        return {
          name: ship.shipTypeName
          data: _.map _.range(0,100), (distance) ->
            Desc.dps panelData.attackerDamageStats, ship.stats.navigation[1], distance * 1e3
          }

Template.mitigationFittings.helpers
  fittings: ->
    visibleFits = @data.fittings

    doctrineID = Template.parentData(4).doctrine
    fitIDs = Doctrines.findOne({_id: doctrineID}).fittings

    fittings = Fittings.find({_id: {$in: fitIDs}}).fetch()

    for item in fittings
      if _.contains visibleFits, item._id
        item.visible = "checked"
      else
        item.visible = ""

    return fittings

Template.mitigationFittings.events
  'change .visibleCheck input': (event) ->
    panelID = Template.currentData()._id

    if event.target.checked
      Panels.update panelID, {$addToSet: {'data.fittings': @_id}}
    else
      Panels.update panelID, {$pullAll: {'data.fittings': [@_id]}}

