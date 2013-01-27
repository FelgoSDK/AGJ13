
var generateObstacles = false
var selectedTrack = 0
var middleRailVariationType = "straight"
var middleRailVariationSource = "none"

// too many switches
var switchDepths = 0
var maximalSwitchDepths = 1

// holds the last 3 switches - needed to create cows after switches with a higher p
var lastTrackSwitches

function init() {
  switchDepths = 0

  // initialize with each of the tracks being empty

  lastTrackSwitches = new Array()
  for( var i=0; i< railAmount; i++) {
    lastTrackSwitches[i] = 0
  }

}

function createRandomRowForRowNumber(rowNumber) {

  console.debug("createRandomRowForRowNumber:", rowNumber, ", railAmount:", railAmount)

  var currentTrackArray = new Array()
  // if a switch is created at any of the rails, create one here
  for( var i=0; i< railAmount; i++) {
    currentTrackArray[i] = 0
//    console.debug("currentTrackArray at pos", i, currentTrackArray[i])
  }


//  var r1 = Mat.random()
//  if(r1<pSwitchAtPlayerRail) {
//    // create a switch where the player is
  // the player is at its current position - but the switches are created out of screen on the right

//    if()
//  }


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
      currentVariationSource = generateVariationSource(i,currentVariationType)
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
                                                     "turnDirection": currentTurnDirection
                                                    });

    // set a 1 on all non-straight tracks - only on straight tracks obstacles should be created
    // only add obstacles after senders, not receivers - it would be unfair to place a cow at a receiver!
    if( currentVariationSource === "sender" /*currentVariationType !== "straight"*/) {

      // we set a 2 if the switch was created at the player rail, 1 if it was created at another
      if(i == playerRowActive) {
        currentTrackArray[i] = 2
        console.debug("setting trackArray at row", i, "to 2, because player is on this row")
      } else {
        currentTrackArray[i] = 1
        console.debug("setting trackArray at row", i, "to 1, because player is on another row")
      }


    } else {
      // add obstacle, if we have a straight track
      if(generateObstacles) {
        createRandomObstacleInTrack(i, currentVariationType, newTrackCenterPos.x,newTrackCenterPos.y)
      }
    }


  } // end of for loop over all rails

  // for debugging only
  for( var i=0; i< railAmount; i++) {
    console.debug("currentTrackArray at pos", i, currentTrackArray[i])
  }

  // set the last trackArray to the current one, because obstacles are also built according to the last column
  lastTrackSwitches = currentTrackArray;

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
function generateVariationSource(track,variationType) {
  if(variationType === "straight")
    return "none"

  var variation = "none"
  if(middleRailVariationSource === "sender") {
    variation = "receiver"
  } else if (middleRailVariationSource === "receiver") {
    variation = "sender"
  }

  return variation
}

function
createRandomObstacleInTrack(railNumber, currentVariationType,x,y) {

  // this is checked before already
  // do not place a obstacle on a switch
//  if(currentVariationType !== "straight")
//    return

  var createHere = false;
  console.debug("last track at rail:", lastTrackSwitches[railNumber], "for railNumber", railNumber)

  if(lastTrackSwitches[railNumber] === 2) {
    if(Math.random() < pCowAfterPlayerSwitchInLastColumn) {
      createHere = true;
    }
  } else  if(lastTrackSwitches[railNumber] === 1){
    if(Math.random() < pCowAfterNonPlayerSwitch) {
      createHere = true;
    }
  } else {
    if(Math.random() < pCowFreePos) {
      createHere = true;
    }
  }

  console.debug("createHEre:", createHere)

  if(!createHere)
    return;


  // do not create an obstacle in the first section
  if(x<level.width/3)
    return;

  var borders = level.trackSectionWidth*0.4
  // e.g. create in between 20...80, when the trackSectionWidth is 100
  var randomPosForCow = (Math.random()*level.trackSectionWidth-borders*2) + borders
  // the x is in the middle, so add an offset between -30 ... +30
  randomPosForCow -= level.trackSectionWidth/2
  // for testing if creation is correct, reset the random xOffset
  randomPosForCow = 0

  var cowCenterPos = Qt.point(x+randomPosForCow, y);
  console.debug("create new obstacle on track ",cowCenterPos.x, cowCenterPos.y)
  entityManager.createEntityFromUrlWithProperties(Qt.resolvedUrl("entities/Obstacle.qml"),
                                                  {"x": cowCenterPos.x,
                                                    "y": cowCenterPos.y
                                                  });


  // OLD:
  // create an obstacle in 30% of all created blocks
//  if(Math.random() < obstacleCreationPropability) {

//    // look at 1 grid position above
//    var coinCenterPos = Qt.point(x, y);

//    console.debug("create new obstacle on track ",coinCenterPos.x, coinCenterPos.y)
//    entityManager.createEntityFromUrlWithProperties(Qt.resolvedUrl("entities/Obstacle.qml"),
//                                                    {"x": coinCenterPos.x,
//                                                      "y": coinCenterPos.y
//                                                    });
//  }
}
