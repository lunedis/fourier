UI.registerHelper 'formatNumber', (context, options) ->
  if context
    decimals = 0
    if typeof options == 'number'
      decimals = options
    
    context.toFixed(decimals).replace /\d(?=(\d{3})+$)/g, '$&,'

Template['fittings'].helpers
  fittingsWithTank: ->
    # data-context: doctrine object
    if !@fittings?
      return [];

    fittings = Fittings.find({_id: {$in: this.fittings}}).fetch()
    totalRep = _.reduce fittings, (memo, ship) ->
      if ship.stats.outgoing.shield?
        memo + ship.stats.outgoing.shield.rr * ship.count
      else if ship.stats.outgoing.armor?
        memo + ship.stats.outgoing.armor.rr * ship.count
      else
        return memo
    , 0

    _.each fittings, (ship) ->
      rep = 0;
      if ship.stats.outgoing.shield?
        rep = ship.stats.outgoing.shield.rr

      if ship.stats.outgoing.armor?
        rep = ship.stats.outgoing.armor.rr

      ship.tank = ship.stats.tank.resishield * (totalRep - rep)
      ship.ttl = ship.stats.tank.ehpshield / ship.tank

    return fittings

  totalDPS: ->
    if(!this.fittings? || this.fittings.length == 0)
      return 0

    _.reduce Fittings.find({_id: {$in: this.fittings}}).fetch(), (memo, ship) ->
      memo + ship.stats.damage.total * ship.count;
    , 0

Template['fittings'].events
  'click .countUp': (event) ->
    Fittings.update @_id, {$inc: {count: 1}}
  'click .countDown': (event) ->
    Fittings.update @_id, {$inc: {count: -1}} unless @count <= 0


Template['addFitting'].helpers
  AddFittingsSchema: ->
    return AddFittingsSchema

sigres = 125;
tracking = 0.033;
optimal = 57600;
falloff = 15000;
Template['graph'].helpers
  dmgGraph: ->
    return {
      chart:
        type: 'spline'
      plotOptions:
        spline:
          marker:
            enabled: false
      yAxis:
        min: 0
        max: 100
      series: _.map Fittings.find({_id: {$in: this.fittings}}).fetch(), (ship) ->
        return {
          name: ship.shipTypeName
          data: _.map _.range(0,100), (distance) ->
            trackingPart = Math.pow((ship.stats.navigation[1].speed / (distance * 1000 * tracking)) * (sigres / ship.stats.navigation[1].sig), 2)
            rangePart = Math.pow(Math.max(0, distance * 1000 - optimal) / falloff, 2)
            chanceToHit = Math.pow(0.5, trackingPart + rangePart)
            if chanceToHit < 0.01
              300 * chanceToHit
            else
              100 * (Math.pow(chanceToHit,2) + chanceToHit + 0.0499) / 2
        }
    }

AutoForm.addHooks 'addFittingForm', 
  after:
    method: (error, result) ->
      if(!error?)
        doctrineID = Router.current().params._id
        check result, String
        Doctrines.update doctrineID, {$push: {fittings: result}}
      else
        console.log error