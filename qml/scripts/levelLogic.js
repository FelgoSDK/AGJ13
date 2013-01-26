
function createRandomRowForRowNumber(rowNumber) {

  console.debug("createRandomRowForRowNumber:", rowNumber, ", railAmount:", railAmount)

  for(var i=0; i<railAmount; i++) {
    var newTrackCenterPos = Qt.point(rowNumber*trackSectionWidth, startYForFirstRail+i*trackSectionHeight);


    // TODO add variation type of upper  element to decide which element can be added
    entityManager.createEntityFromUrlWithProperties(Qt.resolvedUrl("entities/TrackSection.qml"),
                                                    {"x": newTrackCenterPos.x,
                                                     "y": newTrackCenterPos.y,
                                                      "variationTypes": generateVariationType()
                                                    });
    console.debug("create new trackSection at position", newTrackCenterPos.x, newTrackCenterPos.y)
    // add obstacle
    createRandomObstacleInTrack(newTrackCenterPos.x,newTrackCenterPos.y)
  }

}

function generateVariationType() {
  var propability = Math.random()
  if(Math.random() < 0.1) {
    return "both"
  } else if(Math.random() < 0.3) {
    return "down"
  } else if(Math.random() < 0.6) {
    return "up"
  } else {
    return "straight"
  }
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
