import SwiftUI

struct EffectsOverlay: View {
    @ObservedObject var viewModel: CameraViewModel
    
    var body: some View {
        ZStack {
            // Brightness overlay
            Rectangle()
                .fill(viewModel.getBrightnessOverlayColor())
                .blendMode(.normal)
                .allowsHitTesting(false)
            
            // Shutter speed overlay (exposure simulation)
            Rectangle()
                .fill(viewModel.getExposureOverlayColor())
                .blendMode(.multiply)
                .allowsHitTesting(false)
        }
        .blur(radius: viewModel.getBlurRadius())
        .animation(.easeInOut(duration: 0.1), value: viewModel.brightnessControl.value)
        .animation(.easeInOut(duration: 0.1), value: viewModel.focusControl.value)
        .animation(.easeInOut(duration: 0.1), value: viewModel.shutterSpeedControl.value)
    }
}

struct CameraViewWithEffects: View {
    @ObservedObject var cameraManager: CameraManager
    @ObservedObject var viewModel: CameraViewModel
    
    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                // 3:4 aspect ratio camera preview
                ZStack {
                    CameraPreviewView(cameraManager: cameraManager)
                    EffectsOverlay(viewModel: viewModel)
                }
                .frame(width: geometry.size.width, height: geometry.size.width * 4/3)
                .clipped()
                
                // Black space below camera
                Rectangle()
                    .fill(Color.black)
                    .frame(maxHeight: .infinity)
            }
        }
        .ignoresSafeArea()
        .background(Color.black)
    }
}