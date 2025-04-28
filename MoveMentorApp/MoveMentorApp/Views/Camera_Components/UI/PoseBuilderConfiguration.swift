import Foundation

struct PoseBuilderConfiguration {
    var algorithm: Algorithm = .single
    var jointConfidenceThreshold: Double = 0.5
    var poseConfidenceThreshold: Double = 0.5
    
    // These are important for multiple-person pose estimation (calibration tuning)
    var localSearchRadius: Int = 3
    var matchingJointDistance: = Float(15.0)
    var adjacentJointOffsetRefinementSteps: Int = 5
}
