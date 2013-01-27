import QtQuick 1.1
import VPlay 1.0

Particle {
  id: snowing

  // Particle location properties
  x: scene.gameWindowAnchorItem.width
  y:0
  sourcePositionVariance: Qt.point(0,scene.height)

  // Particle configuration properties
  maxParticles: 290
  particleLifespan: 2.00
  particleLifespanVariance: 1.00
  startParticleSize: 6
  startParticleSizeVariance: 2
  finishParticleSize: 8
  finishParticleSizeVariance: 2
  rotation: 0
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
  gravity: Qt.point(-100,0)
  speed: 0
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
