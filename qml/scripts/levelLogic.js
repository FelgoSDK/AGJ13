
var generateObstacles = false
var selectedTrack = 0
var selectedTrackVariationType = ""

function createRandomRowForRowNumber(rowNumber) {

  console.debug("createRandomRowForRowNumber:", rowNumber, ", railAmount:", railAmount)

  // generate the switch for the middle track
  selectedTrackVariationType = generateMiddeVariationType()

  for(var i=0; i<railAmount; i++) {
    var newTrackCenterPos = Qt.point(rowNumber*trackSectionWidth, startYForFirstRail+i*trackSectionHeight);

    var currentVariationType = "straight"
    if(i === 1) {
      currentVariationType = selectedTrackVariationType
    } else {
      currentVariationType = generateVariationType(i)
    }

    // TODO add variation type of upper  element to decide which element can be added
    entityManager.createEntityFromUrlWithProperties(Qt.resolvedUrl("entities/TrackSection.qml"),
                                                    {"x": newTrackCenterPos.x,
                                                     "y": newTrackCenterPos.y,
                                                     "variationTypes": currentVariationType
                                                    });

    console.debug("create new trackSection at position", newTrackCenterPos.x, newTrackCenterPos.y)
    // add obstacle
    if(generateObstacles) {
      createRandomObstacleInTrack(newTrackCenterPos.x,newTrackCenterPos.y)
    }
  }


}

function generateMiddeVariationType() {
  // everything is allowed in middle rails
  if(Math.random() < 0.1) {
    return "both"
  } else if(Math.random() < 0.2) {
    return "down"
  } else if(Math.random() < 0.3) {
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
