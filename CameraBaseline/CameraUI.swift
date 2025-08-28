import SwiftUI

struct CameraUI: View {
    @StateObject private var cameraManager = CameraManager()
    @StateObject private var cameraViewModel = CameraViewModel()
    
    var body: some View {
        ZStack {
            if cameraManager.isAuthorized {
                // Camera view with effects
                CameraViewWithEffects(cameraManager: cameraManager, viewModel: cameraViewModel)
                    .onAppear {
                        cameraManager.startSession()
                        cameraViewModel.setCameraManager(cameraManager)
                    }
                    .onDisappear {
                        cameraManager.stopSession()
                    }
                
                // Overlay UI elements
                VStack {
                    Spacer()
                    
                    // Controls panel
                    BaselineControls(viewModel: cameraViewModel)
                    
                    // Camera controls (capture button, thumbnail)
                    CameraControlsPanel(cameraManager: cameraManager)
                }
                
                // Error display (separate from main VStack)
                if let error = cameraManager.captureError {
                    VStack {
                        Spacer()
                        ErrorDisplay(error: error) {
                            cameraManager.captureError = nil
                        }
                    }
                }
            } else {
                CameraPermissionView()
            }
        }
    }
}

struct CameraControlsPanel: View {
    @ObservedObject var cameraManager: CameraManager
    
    var body: some View {
        HStack(alignment: .bottom, spacing: 20) {
            // Thumbnail on the left
            ThumbnailView(cameraManager: cameraManager)
                .padding(.leading, 30)
                .padding(.bottom, 10)
            
            Spacer()
            
            // Capture button in center
            CaptureButton(cameraManager: cameraManager)
            
            Spacer()
            
            // Empty space on right (for symmetry)
            Rectangle()
                .fill(Color.clear)
                .frame(width: 60, height: 60)
                .padding(.trailing, 30)
        }
        .padding(.bottom, 50)
    }
}


struct ErrorDisplay: View {
    let error: String
    let onDismiss: () -> Void
    
    var body: some View {
        HStack {
            Spacer()
            Text(error)
                .font(.caption)
                .foregroundColor(.white)
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background(Color.red.opacity(0.8))
                .cornerRadius(8)
            Spacer()
        }
        .padding(.bottom, 20)
    }
}

struct CameraPermissionView: View {
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "camera.fill")
                .font(.system(size: 50))
                .foregroundColor(.gray)
            
            Text("Camera access required")
                .font(.headline)
                .padding()
            
            Text("Please enable camera access in Settings")
                .font(.caption)
                .foregroundColor(.gray)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.black)
    }
}