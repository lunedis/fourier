Template.mitigation.rendered = ->
  this.autorun ->
    panelData = Template.currentData().data
    fittings = Fittings.find({_id: {$in: panelData.fittings}}).fetch()

    if panelData.staticY
      maxDPS = panelData.attackerDamageStats.total
    else
      maxDPS = null

    $('#dmgMitigation' + Template.currentData()._id).highcharts
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
        max: maxDPS
      xAxis:
        min: 0
      series: _.map fittings, (ship) ->
        return {
          name: ship.shipTypeName
          data: _.map _.range(0,100), (distance) ->
            nav = Desc.applyEwar ship.stats.navigation[1], panelData.webs, panelData.tps
            Desc.dps panelData.attackerDamageStats, nav, distance * 1e3
          }