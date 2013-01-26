
var generateObstacles = false
var selectedTrack = 0
var selectedTrackVariationType = ""
var selectedVarationSource = "none"

// this is a dirty hack, because the entityManager does not work well when the entityId already exists!
var entityCounter = 0

function createRandomRowForRowNumber(rowNumber) {

  console.debug("createRandomRowForRowNumber:", rowNumber, ", railAmount:", railAmount)

  // generate the switch for the middle track
  selectedTrackVariationType = generateMiddeVariationType()
  selectedVarationSource = generateMiddeVariationSource()

  for(var i=0; i<railAmount; i++) {
    var newTrackCenterPos = Qt.point(rowNumber*trackSectionWidth, startYForFirstRail+i*trackSectionHeight);

    var currentVariationType = "straight"
    var currentVariationSource = "sender"
    var currentTurnDirection = "straight"
    if(i === 1) {
      currentVariationType = selectedTrackVariationType
      currentVariationSource = selectedVarationSource
    } else {
      currentVariationType = generateVariationType(i)
      currentVariationSource = generateVariationSource(i)
    }

    // TODO add variation type of upper  element to decide which element can be added
    var trackId = entityManager.createEntityFromUrlWithProperties(Qt.resolvedUrl("entities/TrackSection.qml"),
                                                    {"x": newTrackCenterPos.x,
                                                     "y": newTrackCenterPos.y,
                                                     "variationTypes": currentVariationType,
                                                     "variationSource": currentVariationSource,
                                                     "turnDirection": currentTurnDirection,
                                                     // comment entityId - restarting would not work any more!
                                                     "entityId": "trackSection" + entityCounter
                                                    });
    entityCounter++

    var track = entityManager.getEntityById(trackId);
    if(!track.visible)
      console.debug("ERRO: TRACK invisible!? - this happens when the entityId was duplicated")

    console.debug("create new trackSection at position", newTrackCenterPos.x, newTrackCenterPos.y)
    if(newTrackCenterPos.x != track.x || newTrackCenterPos.y!=track.y)
      console.debug("ERRO: not the same pos!?- this happens when the entityId was duplicated")

    // add obstacle
    if(generateObstacles) {
      createRandomObstacleInTrack(newTrackCenterPos.x,newTrackCenterPos.y)
    }
  }


}

function generateMiddeVariationSource() {
  if(selectedTrackVariationType === "straight")
    return "none"

  var propability = Math.random()
  // everything is allowed in middle rails
  if(propability < 0.5) {
    return "sender"
  } else {
    return "receiver"
  }
}

function generateMiddeVariationType() {
  var propability = Math.random()
  // everything is allowed in middle rails
  if(propability < 0.1) {
    return "both"
  } else if(propability < 0.3) {
    return "down"
  } else if(propability < 0.4) {
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
    if(selectedTrackVariationType === "up" || selectedTrackVariationType === "both") {
      variation = "down"
    }
    return variation
  }

  // only up and straight is allowed in lowest rail
  if(track === (railAmount-1))
  {
    if(selectedTrackVariationType === "down" || selectedTrackVariationType === "both") {
      variation = "up"
    }
    return variation
  }
  return variation
}

// generates random variation for tracks
function generateVariationSource(track) {
  var variation = "none"
  if(selectedVarationSource === "sender") {
    variation = "receiver"
  } else if (selectedVarationSource === "receiver") {
    variation = "sender"
  }

  return variation
}

function createRandomObstacleInTrack(x,y) {

  // do not create an obstacle in the first section
  if(x<level.width/3)
    return;

  // create an obstacle in 10% of all created blocks
  if(Math.random() < obstacleCreationPropability) {

    // look at 1 grid position above
    var coinCenterPos = Qt.point(x, y);


    /*if(physicsWorld.bodyAt(coinCenterPos)) {
          console.debug("there is a obstacle before the to create block, dont create a coin here!")
          continue;
      }*/


    console.debug("create new obstacle on track ",coinCenterPos.x, coinCenterPos.y)
    entityManager.createEntityFromUrlWithProperties(Qt.resolvedUrl("entities/Obstacle.qml"),
                                                    {"x": coinCenterPos.x,
                                                      "y": coinCenterPos.y
                                                    });
  }
}
