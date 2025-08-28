import SwiftUI

struct ThumbnailView: View {
    @ObservedObject var cameraManager: CameraManager
    
    var body: some View {
        VStack {
            if let lastPhoto = cameraManager.lastCapturedPhoto {
                Image(uiImage: lastPhoto)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 60, height: 60)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.white, lineWidth: 2)
                    )
            } else {
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.white.opacity(0.3), lineWidth: 2)
                    .frame(width: 60, height: 60)
                    .overlay(
                        Image(systemName: "photo")
                            .foregroundColor(.white.opacity(0.5))
                            .font(.title3)
                    )
            }
        }
    }
}


struct CaptureButton: View {
    @ObservedObject var cameraManager: CameraManager
    
    var body: some View {
        Button(action: {
            cameraManager.capturePhoto()
        }) {
            ZStack {
                Circle()
                    .fill(Color.white)
                    .frame(width: 70, height: 70)
                
                Circle()
                    .stroke(Color.gray, lineWidth: 2)
                    .frame(width: 60, height: 60)
                
                if cameraManager.isCapturingPhoto {
                    ProgressView()
                        .scaleEffect(0.8)
                        .tint(.gray)
                }
            }
        }
        .disabled(cameraManager.isCapturingPhoto)
    }
}