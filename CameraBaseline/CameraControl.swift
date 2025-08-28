import Foundation

protocol CameraControl: ObservableObject {
    var value: Double { get set }
    var range: ClosedRange<Double> { get }
    var defaultValue: Double { get }
    var name: String { get }
    
    func reset()
    func normalizedValue() -> Double
}

extension CameraControl {
    func reset() {
        value = defaultValue
    }
    
    func normalizedValue() -> Double {
        let normalizedValue = (value - range.lowerBound) / (range.upperBound - range.lowerBound)
        return max(0, min(1, normalizedValue))
    }
}

class BrightnessControl: CameraControl {
    @Published var value: Double
    let range: ClosedRange<Double> = -1.0...1.0
    let defaultValue: Double = 0.0
    let name: String = "Brightness"
    
    init() {
        self.value = defaultValue
    }
}

class FocusControl: CameraControl {
    @Published var value: Double
    let range: ClosedRange<Double> = 0.0...1.0
    let defaultValue: Double = 0.5
    let name: String = "Focus"
    
    init() {
        self.value = defaultValue
    }
}

class ShutterSpeedControl: CameraControl {
    @Published var value: Double
    let range: ClosedRange<Double> = -2.0...2.0
    let defaultValue: Double = 0.0
    let name: String = "Shutter Speed"
    
    init() {
        self.value = defaultValue
    }
}