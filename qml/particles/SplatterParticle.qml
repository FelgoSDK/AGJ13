import VPlay 1.0
import QtQuick 1.1

Particle {
  id: splatterParticle

  property string particleConfigurationProperties : "Particle Configuration"
  property string gravityMode : "Gravity Mode"
  property string radiationMode : "Radiation Mode"
  property string colorAppearance : "Color"
  property string appearance : "Appearance"
  property string emitterLocation: "Emitter Location"
  property string emmiterBehaviour: "Emitter Behaviour"
  // The EditableComponent is used by the Particle Editor for automatic generation of the property GUI.
  // It is not needed for particles which finished and added to a game.
  EditableComponent {
    id: editableEditorComponent
    target: splatterParticle
    type: "SplatterParticle"
    properties: {
      // Particle location properties
      //"x":                          {"minimum": 0, "maximum": typeof gameWindow !== "undefined" ? gameWindow.width : 512, "label": "Position X", "group": emitterLocation},
      //"y":                          {"minimum": 0, "maximum": typeof gameWindow !== "undefined" ? gameWindow.height : 512, "label": "Position Y", "group": emitterLocation},
      "sourcePositionVariance":     {"minimum": {x:0,y:0}, "maximum": {x:1000,y:1000}, "invert": true, "label": "Position Variance", "group": emitterLocation},

      // Particle configuration properties
      "maxParticles":               {"minimum": 0, "maximum": 50, "label": "Particle Count", "color": "red","group": particleConfigurationProperties},
      "particleLifespan":           {"minimum": 0, "maximum": 1, "stepsize": 0.01, "label": "Lifespan", "color": "red","group": particleConfigurationProperties},
      "particleLifespanVariance":   {"minimum": 0, "maximum": 1, "stepsize": 0.01, "label": "Lifespan Variance", "group": particleConfigurationProperties},
      "startParticleSize":          {"minimum": 0, "maximum": 512, "label": "Start Size", "group": particleConfigurationProperties},
      "startParticleSizeVariance":  {"minimum": 0, "maximum": 512, "label": "Start Size Variance", "group": particleConfigurationProperties},
      "finishParticleSize":         {"minimum": 0, "maximum": 512, "label": "End Size Variance", "group": particleConfigurationProperties},
      "finishParticleSizeVariance": {"minimum": 0, "maximum": 512, "label": "End Size Variance", "group": particleConfigurationProperties},
      "rotation":                   {"minimum": 0, "maximum": 360, "label": "Emit Angle", "group": particleConfigurationProperties},
      "angleVariance":              {"minimum": 0, "maximum": 360, "label": "Emit Angle Variance", "group": particleConfigurationProperties},
      "rotationStart":              {"minimum": -360, "maximum": 360, "label": "Start Spin", "group": particleConfigurationProperties},
      "rotationStartVariance":      {"minimum": -360, "maximum": 360, "label": "Start Spin Variance", "group": particleConfigurationProperties},
      "rotationEnd":                {"minimum": -360, "maximum": 360, "label": "End Spin", "group": particleConfigurationProperties},
      "rotationEndVariance":        {"minimum": -360, "maximum": 360, "label": "End Spin Variance", "group": particleConfigurationProperties},

      // Emitter Behaviour
      "emitterType":                {"minimum": Particle.Gravity, "maximum": Particle.Radius, "stepsize": 1, "label": "Particle Mode", "group": emmiterBehaviour},
      "duration":                   {"minimum": Particle.Infinite, "maximum": 10, "stepsize": 0.01, "label": "Duration", "group": emmiterBehaviour},
      "positionType":               {"minimum": Particle.Free, "maximum": Particle.Grouped, "stepsize": 1, "label": "Position Type", "group": emmiterBehaviour},

      // Gravity Mode (Gravity + Tangential Accel + Radial Accel)
      "gravity":                    {"minimum": {x:-1000,y:-1000}, "maximum": {x:1000,y:1000}, "label": "Gravity", "group": gravityMode},
      "speed":                      {"minimum": 0, "maximum": 1000, "label": "Speed", "color": "red","group": gravityMode},
      "speedVariance":              {"minimum": 0, "maximum": 1000, "label": "Speed Variance", "group": gravityMode},
      "tangentialAcceleration":     {"minimum": -1000, "maximum": 1000, "label": "Tangential Acceleration", "group": gravityMode},
      "tangentialAccelVariance":    {"minimum": -1000, "maximum": 1000, "label": "Tangential Acceleration Variance", "group": gravityMode},
      "radialAcceleration":         {"minimum": -1000, "maximum": 1000, "label": "Radial Acceleration", "group": gravityMode},
      "radialAccelVariance":        {"minimum": -1000, "maximum": 1000, "label": "Radial Acceleration Variance", "group": gravityMode},

      // Radiation Mode (circular movement)
      "minRadius":                  {"minimum": 0, "maximum": 512, "label": "Minimal Radius", "group": radiationMode},
      "minRadiusVariance":          {"minimum": 0, "maximum": 512, "label": "Minimal Radius Variance", "group": radiationMode},
      "maxRadius":                  {"minimum": 0, "maximum": 512, "label": "Maximal Radius", "group": radiationMode},
      "maxRadiusVariance":          {"minimum": 0, "maximum": 512, "label": "Maximal Radius Variance", "group": radiationMode},
      "rotatePerSecond":            {"minimum": 0, "maximum": 360, "label": "Rotation per second", "group": radiationMode},
      "rotatePerSecondVariance":    {"minimum": 0, "maximum": 360, "label": "Rotation per second Variance", "group": radiationMode},

      // Currently not supported by itemIditor
      // Appearance // use minimum 1 so the oppacity of the color rectangle does not vanish
      "startColor":                 {"minimum": 1, "maximum": 255,"stepsize": 1, "label": "Start Color", "group": colorAppearance},
      "startColorVariance":         {"minimum": 1, "maximum": 255,"stepsize": 1, "label": "Start Color Variance", "group": colorAppearance},
      "finishColor":                {"minimum": 1, "maximum": 255,"stepsize": 1, "label": "End Color", "group": colorAppearance},
      "finishColorVariance":        {"minimum": 1, "maximum": 255,"stepsize": 1, "label": "End Color Variance", "group": colorAppearance},
      "blendFuncSource":            {"minimum": Particle.GL_ONE, "maximum": Particle.GL_ONE_MINUS_SRC_ALPHA, "label": "Blend Source", "group": appearance},
      "blendFuncDestination":       {"minimum": Particle.GL_ONE, "maximum": Particle.GL_ONE_MINUS_SRC_ALPHA, "label": "Blend Destination", "group": appearance},
      "textureFileName":            {"label": "Texture", "group": appearance},

      // Following properties do not have any group and go to the default group: Properties
      // should not be changable, depends on particle count
      //"emissionRate":    {"minimum": 0, "maximum": 1000, "label": "EmissionRate WARNING!", "color": "red"},
      // should not be selectable, but to measure performance it's nice to disable the particle effect
      "visible": {"default": true, "label": "Visible"},
    }
  }

  // Particle location properties
  x:-10
  y: 0
  sourcePositionVariance: Qt.point(0,0)

  // Particle configuration properties
  maxParticles: 20
  particleLifespan: 0.3
  particleLifespanVariance: 0.2
  startParticleSize: 15
  startParticleSizeVariance: 6
  finishParticleSize: 5
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
  startColor: Qt.rgba(0.75,0.75,0.75,0.8);
  startColorVariance: Qt.rgba(0,0,0,0);
  finishColor: Qt.rgba(0.3,0.3,0.3,0);
  finishColorVariance: Qt.rgba(0,0,0,0);
  blendFuncSource: Particle.GL_SRC_ALPHA
  blendFuncDestination: Particle.GL_ONE_MINUS_SRC_ALPHA
  textureFileName: "particleSplatter.png"

  Component.onCompleted: {
    splatterParticle.start()
  }
}
