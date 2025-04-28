import Foundation

struct PoseBuilderConfiguration {
    var algorithm: Algorithm = .single
    var jointConfidenceThreshold: Double = 0.5
    var poseConfidenceThreshold: Double = 0.5
}
