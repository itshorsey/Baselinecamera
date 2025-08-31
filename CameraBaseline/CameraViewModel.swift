import Foundation
import SwiftUI

class CameraViewModel: ObservableObject {
    @Published var exposureCompensationControl = ExposureCompensationControl()
    @Published var focusControl = FocusControl()
    
    var cameraManager: CameraManager?
    
    init() {
        setupControlObservation()
    }
    
    func setCameraManager(_ manager: CameraManager) {
        self.cameraManager = manager
    }
    
    private func setupControlObservation() {
        exposureCompensationControl.objectWillChange.sink { [weak self] _ in
            DispatchQueue.main.async {
                self?.objectWillChange.send()
            }
        }.store(in: &cancellables)
        
        focusControl.objectWillChange.sink { [weak self] _ in
            DispatchQueue.main.async {
                self?.objectWillChange.send()
            }
        }.store(in: &cancellables)
    }
    
    private var cancellables = Set<AnyCancellable>()
    
    func resetAllControls() {
        exposureCompensationControl.reset()
        focusControl.reset()
    }
    
    func getExposureOverlayColor() -> Color {
        let exposure = exposureCompensationControl.value
        if exposure > 0 {
            return Color.white.opacity(exposure * 0.4)
        } else {
            return Color.black.opacity(abs(exposure) * 0.4)
        }
    }
    
    func getBlurRadius() -> CGFloat {
        let focus = focusControl.value
        let maxBlur: CGFloat = 15.0
        let normalizedFocus = 1.0 - focus
        return CGFloat(normalizedFocus * normalizedFocus) * maxBlur
    }
}

import Combine