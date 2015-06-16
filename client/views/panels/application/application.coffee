Template.application.rendered = ->
  Tracker.autorun =>
    panelData = @data.data
    fittings = Fittings.find({_id: {$in: panelData.fittings}}).fetch()

    $('#dmgApplication').highcharts
      chart:
        type: 'spline'
      title:
        text:
          @data.title
      plotOptions:
        series:
          animation: false
        spline:
          marker:
            enabled: false
      yAxis:
        min: 0
      series: _.map fittings, (ship) ->
        return {
          name: ship.shipTypeName
          data: _.map _.range(0,120), (distance) ->
            Desc.dps ship.stats.damage, panelData.targetNavigation, distance * 1e3
        }     