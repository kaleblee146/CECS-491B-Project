import Foundation

struct PoseBuilderConfiguration {
    var algorithm: Algorithm = .single
    var jointConfidenceThreshold: Float = 0.5
    var poseConfidenceThreshold: Float = 0.5
    
    // These are important for multiple-person pose estimation (calibration tuning)
    var localSearchRadius: Float = 3.0
    var matchingJointDistance:  Float = 15.0
    var adjacentJointOffsetRefinementSteps: Float = 5.0
}
