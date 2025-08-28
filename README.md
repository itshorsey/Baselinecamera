# Camera Baseline 📱

A clean, modular iOS camera app boilerplate built with SwiftUI. Perfect for rapid prototyping of camera UI concepts without rebuilding core functionality every time.

## ✨ Features

- **Full camera functionality** with AVFoundation
- **Real-time visual effects** (brightness, focus, shutter speed simulation)
- **Modular control system** - easily swap UI components
- **Photo capture & thumbnail** with full-screen preview
- **Professional layout** following camera app conventions
- **Comprehensive error handling** with user-friendly messages
- **Modern SwiftUI architecture** with MVVM pattern

## 🚀 Quick Start

1. **Clone the repository**
   ```bash
   git clone <your-repo-url>
   cd CameraBaseline
   ```

2. **Open in Xcode**
   ```bash
   open CameraBaseline.xcodeproj
   ```

3. **Run on device** (camera won't work in simulator)
   - Select your iOS device as the target
   - Build and run (⌘+R)
   - Grant camera permissions when prompted

4. **Start prototyping!**
   - Modify files in the `UI/` folder for your concepts
   - Core camera functionality stays untouched

## 📁 Project Structure

```
CameraBaseline/
├── Core/                          # 🔒 Don't modify (camera logic)
│   ├── CameraManager.swift        # AVFoundation session management
│   ├── CameraViewModel.swift      # Control coordination & state
│   └── CameraControl.swift        # Control protocols & implementations
│
├── Camera/                        # 🔒 Rarely modify (display logic)
│   ├── CameraPreviewView.swift    # Camera viewfinder
│   └── EffectsOverlay.swift       # Real-time visual effects
│
├── UI/                            # 🎨 Your playground (modify freely)
│   ├── CameraUI.swift             # Main UI composition
│   ├── ControlSlider.swift        # Control components
│   ├── ThumbnailView.swift        # Photo thumbnail & full view
│   ├── ContentView.swift          # App entry point
│   └── CameraBaselineApp.swift    # App configuration
│
└── README.md                      # This file
```

## 🎛️ Controls System

The baseline includes three main controls that affect the viewfinder in real-time:

### Brightness Control
- **Range**: -1.0 to 1.0 
- **Effect**: White/black overlay on viewfinder
- **Use case**: Exposure simulation, lighting adjustments

### Focus Control  
- **Range**: 0.0 to 1.0
- **Effect**: Gaussian blur (0 = very blurry, 1 = sharp)
- **Use case**: Manual focus simulation, depth effects

### Shutter Speed Control
- **Range**: -2.0 to 2.0
- **Effect**: Exposure overlay (simulates fast/slow shutter)
- **Use case**: Motion blur concepts, exposure effects

## 🔧 Customization Guide

### Creating New Control Types

1. **Create a new control class**:
   ```swift
   class ExposureControl: CameraControl {
       @Published var value: Double
       let range: ClosedRange<Double> = -3.0...3.0
       let defaultValue: Double = 0.0
       let name: String = "Exposure"
       
       init() {
           self.value = defaultValue
       }
   }
   ```

2. **Add to CameraViewModel**:
   ```swift
   @Published var exposureControl = ExposureControl()
   ```

3. **Create visual effects** in `EffectsOverlay.swift`

### Swapping Control UI

Replace `ControlSlider` with custom components:

```swift
// Instead of:
ControlSlider(control: viewModel.brightnessControl)

// Use:
MyCustomDial(control: viewModel.brightnessControl)
MyGestureControl(control: viewModel.brightnessControl)
MyButtonArray(control: viewModel.brightnessControl)
```

### Layout Variations

Create new layout files in `UI/`:

```swift
struct MinimalLayout: View {
    // Your custom camera layout
}

struct ProLayout: View {
    // Professional camera layout  
}
```

Then swap in `CameraUI.swift`:
```swift
// Replace BaselineControls with:
MinimalLayout(viewModel: cameraViewModel)
```

## 📱 Key Components

### CameraManager
- Handles AVFoundation camera session
- Photo capture with HEVC support
- Permission management
- Error handling & feedback

### CameraViewModel  
- Coordinates all controls
- Calculates visual effects
- Manages UI state with @Published properties
- Protocol-based control system

### Control Components
- **ControlSlider**: Basic slider implementation
- **BaselineControls**: Default control panel with show/hide
- **CaptureButton**: Enhanced capture with haptics & animation
- **ThumbnailView**: Photo preview with zoom & pan

## 🎯 Perfect For

- **UI/UX designers** prototyping camera interfaces
- **iOS developers** building camera features  
- **Design agencies** creating camera app concepts
- **Startups** needing quick camera prototypes
- **Students** learning camera app development

## 🛠️ Requirements

- iOS 15.0+
- Xcode 14.0+
- Physical iOS device (camera doesn't work in simulator)
- Camera and Photo Library permissions

## 🔍 Troubleshooting

**Camera not working?**
- Make sure you're running on a physical device
- Check camera permissions in Settings > Privacy & Security > Camera

**Build errors?**
- Ensure you're using Xcode 14+ with iOS 15+ deployment target
- Clean build folder (⌘+Shift+K) and rebuild

**Controls not responding?**
- Check that CameraViewModel is properly connected in CameraUI
- Ensure @ObservedObject and @Published are set up correctly

## 🚀 Pro Tips

1. **Start simple**: Use the baseline controls first, then customize
2. **Keep Core/ untouched**: All camera logic is stable and tested
3. **Prototype in UI/**: This is where your creativity lives  
4. **Test on device**: Camera features don't work in simulator
5. **Copy don't modify**: Clone the whole project for each new concept

## 📝 License

MIT License - Use freely for prototyping and commercial projects.

---

**Happy prototyping!** 🎉

Built with ❤️ for rapid camera UI development.