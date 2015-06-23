Template.damageStats.helpers
  'type': ->
    if @turret?
      type = 'Turret'
    else if @missile?
      type = 'Missile'
    else if @sentry?
      type = 'Sentry'
    else if @drone?
      type = 'Drone'

    'damageStats' + type