import QtQuick 1.1
import VPlay 1.0

Particle {
  id: smokeParticle


  // Particle location properties
  x: 0
  y: 0
  sourcePositionVariance: Qt.point(5,5)

  // Particle configuration properties
  maxParticles: 20
  particleLifespan: 0.5
  particleLifespanVariance: 0.3
  startParticleSize: 2
  startParticleSizeVariance: 3
  finishParticleSize: 40
  finishParticleSizeVariance: 10
  //rotation: 90
  angleVariance: 60
  rotationStart: 0
  rotationStartVariance: 0
  rotationEnd: 0
  rotationEndVariance: 0

  // Emitter Behaviour
  emitterType: Particle.Gravity
  duration: 5
  positionType: Particle.Relative

  // Gravity Mode (Gravity + Tangential Accel + Radial Accel)
  gravity: Qt.point(0,300)
  speed: 10
  speedVariance: 0
  tangentialAcceleration: 0
  tangentialAccelVariance: 0
  radialAcceleration: -30
  radialAccelVariance: 10

  // Radiation Mode (circular movement)
  minRadius: 0
  minRadiusVariance: 0
  maxRadius: 0
  maxRadiusVariance: 0
  rotatePerSecond: 0
  rotatePerSecondVariance: 0

  // Appearance
  startColor: Qt.rgba(1.0,1.0,1.0,0.8);
  startColorVariance: Qt.rgba(0,0,0,0);
  finishColor: Qt.rgba(1.0,1.0,1.0,0);
  finishColorVariance: Qt.rgba(0,0,0,0);
  blendFuncSource: Particle.GL_SRC_ALPHA
  blendFuncDestination: Particle.GL_ONE_MINUS_SRC_ALPHA
  textureFileName: "particleSmoke_32.png"

  Component.onCompleted: {
    smokeParticle.start()
  }
}
