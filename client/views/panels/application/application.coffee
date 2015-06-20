Template.application.rendered = ->
  this.autorun ->
    panelData = Template.currentData().data
    fittings = Fittings.find({_id: {$in: panelData.fittings}}).fetch()

    navigation = Desc.applyEwar panelData.targetNavigation, panelData.webs, panelData.tps

    if panelData.staticY
      maxDPS = _.max (fit.stats.damage.total for fit in fittings)
    else 
      maxDPS = null

    $('#dmgApplication').highcharts
      chart:
        type: 'spline'
      title:
        text:
          ''
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
          data: _.map _.range(0,120), (distance) ->
            Desc.dps ship.stats.damage, navigation, distance * 1e3
        }

Template.application.helpers
  'TargetPresets': ->
    return TargetPresets.find {}

Template.application.events
  'change .speed': (event) ->
    speed = parseInt(event.target.value)
    unless speed == NaN
      Panels.update @_id,
        $set:
          'data.targetNavigation.speed': speed

  'change .sig': (event) ->
    sig = parseInt(event.target.value)
    unless sig == NaN
      Panels.update @_id,
       $set:
         'data.targetNavigation.sig': sig

  'change .preset': (event) ->
    id = event.target.value
    unless id == ''
      preset = TargetPresets.findOne _id: id
      Panels.update @_id,
        $set:
          'data.targetNavigation.sig': preset.sig
          'data.targetNavigation.speed': preset.speed


  'click .plusEwar': (event) ->
    update = {$push: {}}
    target = 'data.' + event.target.getAttribute 'data-target'
    update.$push[target] = event.target.getAttribute 'data-value'
    Panels.update @_id, update

  'click .minusEwar': (event) ->
    update = {$pop: {}}
    target = 'data.' + event.target.getAttribute 'data-target'
    update.$pop[target] = 1
    Panels.update @_id, update  
