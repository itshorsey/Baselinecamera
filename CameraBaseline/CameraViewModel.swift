import Foundation
import SwiftUI

class CameraViewModel: ObservableObject {
    @Published var brightnessControl = BrightnessControl()
    @Published var focusControl = FocusControl()
    @Published var shutterSpeedControl = ShutterSpeedControl()
    
    var cameraManager: CameraManager?
    
    init() {
        setupControlObservation()
    }
    
    func setCameraManager(_ manager: CameraManager) {
        self.cameraManager = manager
    }
    
    private func setupControlObservation() {
        brightnessControl.objectWillChange.sink { [weak self] _ in
            DispatchQueue.main.async {
                self?.objectWillChange.send()
            }
        }.store(in: &cancellables)
        
        focusControl.objectWillChange.sink { [weak self] _ in
            DispatchQueue.main.async {
                self?.objectWillChange.send()
            }
        }.store(in: &cancellables)
        
        shutterSpeedControl.objectWillChange.sink { [weak self] _ in
            DispatchQueue.main.async {
                self?.objectWillChange.send()
            }
        }.store(in: &cancellables)
    }
    
    private var cancellables = Set<AnyCancellable>()
    
    func resetAllControls() {
        brightnessControl.reset()
        focusControl.reset()
        shutterSpeedControl.reset()
    }
    
    func getBrightnessOverlayColor() -> Color {
        let brightness = brightnessControl.value
        if brightness > 0 {
            return Color.white.opacity(brightness * 0.4)
        } else {
            return Color.black.opacity(abs(brightness) * 0.4)
        }
    }
    
    func getBlurRadius() -> CGFloat {
        let focus = focusControl.value
        let maxBlur: CGFloat = 15.0
        let normalizedFocus = 1.0 - focus
        return CGFloat(normalizedFocus * normalizedFocus) * maxBlur
    }
    
    func getExposureOverlayColor() -> Color {
        let shutterSpeed = shutterSpeedControl.value
        let intensity = abs(shutterSpeed) / 2.0
        
        if shutterSpeed > 0 {
            return Color.black.opacity(intensity * 0.3)
        } else {
            return Color.white.opacity(intensity * 0.15)
        }
    }
    
    func getFocusIndicatorOpacity() -> Double {
        let focus = focusControl.value
        return 1.0 - focus
    }
    
    func getShutterSpeedDisplay() -> String {
        let speed = shutterSpeedControl.value
        if speed == 0 {
            return "1/60"
        } else if speed > 0 {
            let denominator = Int(60 * pow(2, speed))
            return "1/\(denominator)"
        } else {
            let denominator = Int(60 / pow(2, abs(speed)))
            return "1/\(denominator)"
        }
    }
}

import Combine