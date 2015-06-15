roughly = (test, actual, expected, epsilon) ->
  test.equal((actual - expected) < epsilon, true)

Tinytest.add 'desc dps turret application', (test) ->
  stats =
    turret:
      dps: 55.21825396825397
      optimal: 62118.7658767872
      falloff: 12500
      tracking: 0.031640625
      signatureResolution: 400
    total: 55.21825396825397

  navigation =
    speed: 0
    sig: 140

  dps = Desc.dps stats, navigation, 40000
  roughly test, dps, 56.6, 1e-1
  dps = Desc.dps stats, navigation, 70000
  roughly test, dps, 38, 2

  navigation = 
    speed: 219
    sig: 140

  dps = Desc.dps stats, navigation, 63000
  roughly test, dps, 51, 2

Tinytest.add 'desc dps missile application', (test) ->
  stats =
    missile: 
      dps: 91.08608656580779
      range: 63281.25
      explosionVelocity: 255
      explosionRadius: 30
      drf: 2.8
    total: 91.08608656580779

  navigation =
    speed: 0
    sig: 74.3

  dps = Desc.dps stats, navigation, 50000
  roughly test, dps, 91, 1
  dps = Desc.dps stats, navigation, 70000
  test.equal dps, 0

  navigation =
    speed: 4771
    sig: 74.3

  dps = Desc.dps stats, navigation, 50000
  roughly test, dps, 27, 1

Tinytest.add 'desc dps sentry', (test) ->
  stats = 
    sentry:
      dps: 320
      optimal: 65625
      falloff: 12000
      tracking: 0.03
      signatureResolution: 400
    total: 320

  navigation =
    speed: 0
    sig: 100

  dps = Desc.dps stats, navigation, 50000
  roughly test, dps, 320, 10

Tinytest.add 'desc dps drone', (test) ->
  stats =
    drone:
      dps: 307
      speed: 5654
      range: 60000
    total: 307

  navigation =
    speed: 0
    sig: 100

  dps = Desc.dps stats, navigation, 50000
  roughly test, dps, 307, 1

  dps = Desc.dps stats, navigation, 70000
  roughly test, dps, 0, 1

  navigation =
    speed: 6000
    sig: 75

  dps = Desc.dps stats, navigation, 30000
  roughly test, dps, 0, 1