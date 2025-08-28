import AVFoundation
import UIKit

class CameraManager: NSObject, ObservableObject {
    @Published var isAuthorized = false
    @Published var captureSession = AVCaptureSession()
    @Published var photoOutput = AVCapturePhotoOutput()
    @Published var lastCapturedPhoto: UIImage?
    @Published var isCapturingPhoto = false
    @Published var captureError: String?
    
    private var captureDevice: AVCaptureDevice?
    private var captureInput: AVCaptureDeviceInput?
    
    override init() {
        super.init()
        setupCamera()
    }
    
    private func setupCamera() {
        checkCameraPermission()
    }
    
    private func checkCameraPermission() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            isAuthorized = true
            configureCaptureSession()
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { granted in
                DispatchQueue.main.async {
                    self.isAuthorized = granted
                    if granted {
                        self.configureCaptureSession()
                    }
                }
            }
        case .denied, .restricted:
            isAuthorized = false
        @unknown default:
            isAuthorized = false
        }
    }
    
    private func configureCaptureSession() {
        captureSession.beginConfiguration()
        
        guard let camera = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back) else {
            print("Failed to get camera device")
            return
        }
        
        do {
            let input = try AVCaptureDeviceInput(device: camera)
            if captureSession.canAddInput(input) {
                captureSession.addInput(input)
                self.captureInput = input
                self.captureDevice = camera
            }
        } catch {
            print("Failed to create camera input: \(error)")
        }
        
        if captureSession.canAddOutput(photoOutput) {
            captureSession.addOutput(photoOutput)
        }
        
        captureSession.commitConfiguration()
    }
    
    func startSession() {
        guard isAuthorized else { return }
        DispatchQueue.global(qos: .userInitiated).async {
            self.captureSession.startRunning()
        }
    }
    
    func stopSession() {
        DispatchQueue.global(qos: .userInitiated).async {
            self.captureSession.stopRunning()
        }
    }
    
    func capturePhoto() {
        guard isAuthorized else {
            captureError = "Camera access not authorized"
            return
        }
        
        guard !isCapturingPhoto else { return }
        
        isCapturingPhoto = true
        captureError = nil
        
        let settings: AVCapturePhotoSettings
        
        if photoOutput.availablePhotoCodecTypes.contains(.hevc) {
            settings = AVCapturePhotoSettings(format: [AVVideoCodecKey: AVVideoCodecType.hevc])
        } else {
            settings = AVCapturePhotoSettings()
        }
        
        // Only set quality prioritization if it's supported
        if photoOutput.maxPhotoQualityPrioritization.rawValue >= AVCapturePhotoOutput.QualityPrioritization.quality.rawValue {
            settings.photoQualityPrioritization = .quality
        } else {
            settings.photoQualityPrioritization = photoOutput.maxPhotoQualityPrioritization
        }
        
        photoOutput.capturePhoto(with: settings, delegate: self)
    }
}

extension CameraManager: AVCapturePhotoCaptureDelegate {
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        defer {
            DispatchQueue.main.async {
                self.isCapturingPhoto = false
            }
        }
        
        if let error = error {
            DispatchQueue.main.async {
                self.captureError = "Failed to capture photo: \(error.localizedDescription)"
            }
            return
        }
        
        guard let imageData = photo.fileDataRepresentation(),
              let image = UIImage(data: imageData) else {
            DispatchQueue.main.async {
                self.captureError = "Failed to process photo data"
            }
            return
        }
        
        DispatchQueue.main.async {
            self.lastCapturedPhoto = image
            self.savePhotoToLibrary(image)
        }
    }
    
    private func savePhotoToLibrary(_ image: UIImage) {
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
    }
    
    @objc private func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            DispatchQueue.main.async {
                self.captureError = "Failed to save photo: \(error.localizedDescription)"
            }
        }
    }
}