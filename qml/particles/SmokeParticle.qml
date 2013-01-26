import QtQuick 1.1
import VPlay 1.0

Particle {
  id: smokeParticle

  // Particle location properties
  x: 0
  y: 0
  sourcePositionVariance: Qt.point(10.988023952095814,0)

  // Particle configuration properties
  maxParticles: 36
  particleLifespan: 0.8300000000000001
  particleLifespanVariance: 0
  startParticleSize: 20//36.125748502994014
  startParticleSizeVariance: 2//19.862275449101798
  finishParticleSize: 100
  finishParticleSizeVariance: 0
  rotation: 0
  angleVariance: 60
  rotationStart: -360
  rotationStartVariance: -360
  rotationEnd: -360
  rotationEndVariance: -360

  // Emitter Behaviour
  emitterType: Particle.Gravity
  duration: Particle.Infinite
  positionType: Particle.Free

  // Gravity Mode (Gravity + Tangential Accel + Radial Accel)
  gravity: Qt.point(-287.4251497005988,30)
  speed:0
  speedVariance:0
  tangentialAcceleration:0
  tangentialAccelVariance:0
  radialAcceleration:-30
  radialAccelVariance:-163.65269461077833
  startColor: Qt.rgba(0.69,0.69,0.69,0.2)
  startColorVariance: Qt.rgba(0.0,0.0,0.0,0.0)
  finishColor: Qt.rgba(0.11,0.11,0.11,0.2)
  finishColorVariance: Qt.rgba(0.0,0.0,0.0,0.0)
  blendFuncSource: Particle.GL_SRC_ALPHA
  blendFuncDestination: Particle.GL_ONE_MINUS_SRC_ALPHA
  textureFileName: "particleSmoke_32.png"
}
