import VPlay 1.0
import QtQuick 1.1

Particle {
  id: splatterParticle

  // Particle location properties
  x:13
  y:13
  sourcePositionVariance: Qt.point(0,0)

  // Particle configuration properties
  maxParticles: 21
  particleLifespan: 0
  particleLifespanVariance: 1.02
  startParticleSize: 0
  startParticleSizeVariance: 0
  finishParticleSize: 48
  finishParticleSizeVariance: 0
  rotation: 0
  angleVariance: 360
  rotationStart: 0
  rotationStartVariance: 0
  rotationEnd: 0
  rotationEndVariance: 0

  // Emitter Behaviour
  emitterType: Particle.Gravity
  duration: 0.1
  positionType: Particle.Relative

  // Gravity Mode (Gravity + Tangential Accel + Radial Accel)
  gravity: Qt.point(2,0)
  speed: 81
  speedVariance: 0
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
  startColor: Qt.rgba(1.0,1.0,0,1.0);
  startColorVariance: Qt.rgba(0,0,0,0);
  finishColor: Qt.rgba(1.0,1.0,0,1.0);
  finishColorVariance: Qt.rgba(0,0,0,0);
  blendFuncSource: Particle.GL_SRC_ALPHA
  blendFuncDestination: Particle.GL_ONE_MINUS_SRC_ALPHA
  textureFileName: "scull.png"
}
