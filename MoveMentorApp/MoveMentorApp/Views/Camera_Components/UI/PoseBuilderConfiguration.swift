import Foundation

struct PoseBuilderConfiguration {
    var algorithm: Algorithm = .single
    var jointConfidenceThreshold: Float = Float(0.5)
    var poseConfidenceThreshold: Float = Float(0.5)
    
    // These are important for multiple-person pose estimation (calibration tuning)
    var localSearchRadius: Float = Float(3.0)
    var matchingJointDistance:  Float = Float(15.0)
    var adjacentJointOffsetRefinementSteps: Float = Float(5.0)
}
