
var generateObstacles = false
var selectedTrack = 0
var middleRailVariationType = "straight"
var middleRailVariationSource = "none"

// this is a dirty hack, because the entityManager does not work well when the entityId already exists!
var entityCounter = 0

// too many switches
var switchDepths = 0
var maximalSwitchDepths = 1

function init() {
  switchDepths = 0
}

function createRandomRowForRowNumber(rowNumber) {

  console.debug("createRandomRowForRowNumber:", rowNumber, ", railAmount:", railAmount)


  // initialize
  middleRailVariationType = "straight"
  middleRailVariationSource = "none"

  // generate the switch for the middle track
  // it determines the direction of the switch below and above
  // switchDepths is used to avoid 2 switches being at to neighbour COLUMNS!
  if(switchDepths < maximalSwitchDepths) {
    middleRailVariationType = generateMiddeVariationType()
    middleRailVariationSource = generateMiddeVariationSource()
    switchDepths++
  } else {
    switchDepths = 0
  }

  for(var i=0; i<railAmount; i++) {

    var newTrackCenterPos = Qt.point(rowNumber*trackSectionWidth, startYForFirstRail+i*trackSectionHeight);

    // the next 2 get overwritten anyway below
    var currentVariationType// = "straight"
    var currentVariationSource// = "none"
    var currentTurnDirection = "straight"
    if(i === 1) {
      currentVariationType = middleRailVariationType
      currentVariationSource = middleRailVariationSource
    } else {
      currentVariationType = generateVariationType(i)
      currentVariationSource = generateVariationSource(i)
    }

    var input = ""
    if(currentVariationType !== "straight" && currentVariationSource==="receiver") {
      input = currentVariationSource
    }

    var variationType = currentVariationType + input;
    // for testing, if different varTypes has an impact on the holes
    // with the following test, the issue occurs that the first time when a pooled entity is created, the straight sectio is removed immediately, because it was on the old position
    // also, for testing, set the numVisibleTracks in level to 3
    // this got fixed in box2dbody.cpp now
//    variationType = "straight"; // if all are the same variationType, it works with pooling
//    if(entityCounter % 7 == 0) {
//      variationType = "up"
//    } else if(entityCounter % 6 == 0) {
//      variationType = "both"
//    } else if(entityCounter % 5 == 0) {
//      variationType = "down"
//    }else if(entityCounter % 4 == 0) {
//      variationType = "bothreceiver"
//    }else if(entityCounter % 3 == 0) {
//      variationType = "downreceiver"
//    }else if(entityCounter % 2 == 0) {
//      variationType = "upreceiver"
//    }

    // TODO add variation type of upper  element to decide which element can be added
    var trackId = entityManager.createEntityFromUrlWithProperties(Qt.resolvedUrl("entities/TrackSection.qml"),
                                                    {"x": newTrackCenterPos.x,
                                                     "y": newTrackCenterPos.y,
                                                     "variationType": variationType,
                                                     "variationSource": currentVariationSource,
                                                     "turnDirection": currentTurnDirection,
                                                     // comment entityId - restarting would not work any more!
                                                     "entityId": "trackSection" + entityCounter
                                                    });

    entityCounter++

    var track = entityManager.getEntityById(trackId);
    if(!track.visible) {
      console.debug("ERRO: TRACK invisible!? - this happens when the entityId was duplicated - for id:", trackId, "or this one:", track.entityId, "variationType:", track.variationType, "local variationType:", variationType)
      track.visible = true
      console.debug("track is visible now:", track.visible)
    }

    console.debug("create new trackSection at position", newTrackCenterPos.x, newTrackCenterPos.y)
    if(newTrackCenterPos.x !== track.x || newTrackCenterPos.y !== track.y)
      console.debug("ERRO: not the same pos!?- this happens when the entityId was duplicated")

    // add obstacle
    if(generateObstacles) {
      createRandomObstacleInTrack(currentVariationType,newTrackCenterPos.x,newTrackCenterPos.y)
    }
  }

}

function generateMiddeVariationSource() {
  if(middleRailVariationType === "straight")
    return "none"

  var propability = Math.random()
  // everything is allowed in middle rails
  if(propability < 0.5) {
    return "sender"
  } else {
    return "receiver"
  }
}

var probabilityMiddleBoth = 0.1
var probabilityMiddleUpOrDown = 0.15

function generateMiddeVariationType() {
  var propability = Math.random()
  // everything is allowed in middle rails
  if(propability < probabilityMiddleBoth) {
    return "both"
  } else if(propability < probabilityMiddleBoth + probabilityMiddleUpOrDown) {
    return "down"
  } else if(propability < probabilityMiddleBoth + 2*probabilityMiddleUpOrDown) {
    return "up"
  } else {
    return "straight"
  }
}

// generates random variation for tracks
function generateVariationType(track) {
  var propability = Math.random()
  var variation = "straight"

  // only down and straight is allowed in highest rail
  if(track === 0)
  {
    if(middleRailVariationType === "up" || middleRailVariationType === "both") {
      variation = "down"
    }
    return variation
  }

  // only up and straight is allowed in lowest rail
  if(track === (railAmount-1))
  {
    if(middleRailVariationType === "down" || middleRailVariationType === "both") {
      variation = "up"
    }
    return variation
  }
  return variation
}

// generates random variation for tracks
function generateVariationSource(track) {
  var variation = "none"
  if(middleRailVariationSource === "sender") {
    variation = "receiver"
  } else if (middleRailVariationSource === "receiver") {
    variation = "sender"
  }

  return variation
}

function createRandomObstacleInTrack(currentVariationType,x,y) {

  // do not place a obstacle on a switch
  if(currentVariationType !== "straight")
    return

  // do not create an obstacle in the first section
  if(x<level.width/3)
    return;

  // create an obstacle in 30% of all created blocks
  if(Math.random() < obstacleCreationPropability) {

    // look at 1 grid position above
    var coinCenterPos = Qt.point(x, y);

    console.debug("create new obstacle on track ",coinCenterPos.x, coinCenterPos.y)
    entityManager.createEntityFromUrlWithProperties(Qt.resolvedUrl("entities/Obstacle.qml"),
                                                    {"x": coinCenterPos.x,
                                                      "y": coinCenterPos.y,
                                                      "entityId": "obstacle" + entityCounter
                                                    });
  }
}
