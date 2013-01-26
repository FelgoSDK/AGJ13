import QtQuick 1.1
import VPlay 1.0

Particle {
  id: snowing

  // Particle location properties
  x: scene.gameWindowAnchorItem.width
  y:0
  sourcePositionVariance: Qt.point(scene.width,0)

  // Particle configuration properties
  maxParticles: 290
  particleLifespan: 5.00
  particleLifespanVariance: 1.00
  startParticleSize: 10
  startParticleSizeVariance: 10
  finishParticleSize: 15
  finishParticleSizeVariance: 10
  rotation: 81
  angleVariance: 27
  rotationStart: 0
  rotationStartVariance: 0
  rotationEnd: 0
  rotationEndVariance: 0

  // Emitter Behaviour
  emitterType: Particle.Gravity
  duration: Particle.Infinite
  positionType: Particle.Relative

  // Gravity Mode (Gravity + Tangential Accel + Radial Accel)
  gravity: Qt.point(0,-177)
  speed: 200
  speedVariance: 300
  tangentialAcceleration: 0
  tangentialAccelVariance: 0
  radialAcceleration: 0
  radialAccelVariance: 0

  // Radiation Mode (circular movement)
  minRadius: 0
  minRadiusVariance: 0
  maxRadius: 0
  maxRadiusVariance: 0
  rotatePerSecond: 0
  rotatePerSecondVariance: 0

  // Appearance
  startColor: Qt.rgba(1.00, 1.00, 1.00, 1.00);
  startColorVariance: Qt.rgba(0.00, 0.00, 0.00, 0.00);
  finishColor: Qt.rgba(1.00, 1.00, 1.00, 1.00);
  finishColorVariance: Qt.rgba(0.00, 0.00, 0.00, 0.00);
  blendFuncSource: Particle.GL_SRC_ALPHA
  blendFuncDestination: Particle.GL_ONE
  textureFileName: "snow.png"
}
