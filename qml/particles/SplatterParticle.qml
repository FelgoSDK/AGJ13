import VPlay 1.0
import QtQuick 1.1

Particle {
  id: splatterParticle

  // Particle location properties
  x:-10
  y: 0
  sourcePositionVariance: Qt.point(0,0)

  // Particle configuration properties
  maxParticles: 20
  particleLifespan: 0.3
  particleLifespanVariance: 0.2
  startParticleSize: 150
  startParticleSizeVariance: 6
  finishParticleSize: 150
  finishParticleSizeVariance: 0
  rotation: 180
  angleVariance: 45
  rotationStart: 0
  rotationEnd: 0
  rotationStartVariance: 0
  rotationEndVariance: 0

  // Emitter Behaviour
  emitterType: Particle.Gravity
  duration: 0.5
  positionType: Particle.Relative

  // Gravity Mode (Gravity + Tangential Accel + Radial Accel)
  gravity: Qt.point(0,0)
  speed: 60
  speedVariance: 0
  tangentialAcceleration: 0
  tangentialAccelVariance: 0
  radialAcceleration: -45
  radialAccelVariance: 20

  // Radiation Mode (circular movement)
  minRadius: 0
  minRadiusVariance: 0
  maxRadius: 0
  maxRadiusVariance: 0
  rotatePerSecond: 0
  rotatePerSecondVariance: 0

  // Appearance
  startColor: Qt.rgba(0.75,0.75,0.75,0.9);
  startColorVariance: Qt.rgba(0,0,0,0);
  finishColor: Qt.rgba(1,1,1,1);
  finishColorVariance: Qt.rgba(0,0,0,0);
  blendFuncSource: Particle.GL_SRC_ALPHA
  blendFuncDestination: Particle.GL_ONE_MINUS_SRC_ALPHA
  textureFileName: "particleSplatter.png"

  Component.onCompleted: {
    splatterParticle.start()
  }
}
