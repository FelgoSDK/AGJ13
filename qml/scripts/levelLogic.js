
var generateObstacles = false

function createRandomRowForRowNumber(rowNumber) {

  console.debug("createRandomRowForRowNumber:", rowNumber, ", railAmount:", railAmount)

  for(var i=0; i<railAmount; i++) {
    var newTrackCenterPos = Qt.point(rowNumber*trackSectionWidth, startYForFirstRail+i*trackSectionHeight);


    // TODO add variation type of upper  element to decide which element can be added
    entityManager.createEntityFromUrlWithProperties(Qt.resolvedUrl("entities/TrackSection.qml"),
                                                    {"x": newTrackCenterPos.x,
                                                     "y": newTrackCenterPos.y,
                                                     "variationTypes": generateVariationType(i)
                                                    });
    console.debug("create new trackSection at position", newTrackCenterPos.x, newTrackCenterPos.y)
    // add obstacle
    if(generateObstacles) {
      createRandomObstacleInTrack(newTrackCenterPos.x,newTrackCenterPos.y)
    }
  }

}

// generates random variation for tracks
function generateVariationType(track) {
  var propability = Math.random()
  var variation = ""

  // only up and straight is allowed in lowest rail
  if(track === (railAmount-1))
  {
    if(Math.random() < 0.4) {
      variation = "up"
    } else {
      variation = "straight"
    }
    return variation
  }

  // only down and straight is allowed in highest rail
  if(track === 0)
  {
    if(Math.random() < 0.4) {
      variation = "down"
    } else {
      variation = "straight"
    }
    return variation
  }

  // everything is allowed in middle rails
  if(Math.random() < 0.1) {
    variation = "both"
  } else if(Math.random() < 0.2) {
    variation = "down"
  } else if(Math.random() < 0.3) {
    variation = "up"
  } else {
    variation = "straight"
  }
  return variation
}

function createRandomObstacleInTrack(x,y) {
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
