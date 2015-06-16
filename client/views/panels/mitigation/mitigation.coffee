Template.mitigation.rendered = ->
  Tracker.autorun =>
    panelData = @data.data
    fittings = Fittings.find({_id: {$in: panelData.fittings}}).fetch()

    $('#dmgMitigation').highcharts
      title:
        text:
          @data.title
      chart:
        type: 'spline'
      plotOptions:
        series:
          animation: false
        spline:
          marker:
            enabled: false
      yAxis:
        min: 0
        max: 100
      series: _.map fittings, (ship) ->
        return {
          name: ship.shipTypeName
          data: _.map _.range(0,100), (distance) ->
            Desc.dps panelData.attackerDamageStats, ship.stats.navigation[1], distance * 1e3
          }