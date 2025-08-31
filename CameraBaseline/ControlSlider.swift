import SwiftUI

struct ControlSlider<T: CameraControl>: View {
    @ObservedObject var control: T
    var showLabel: Bool = true
    var trackColor: Color = .white.opacity(0.3)
    var thumbColor: Color = .white
    
    var body: some View {
        VStack(spacing: 8) {
            if showLabel {
                HStack {
                    Text(control.name)
                        .font(.caption)
                        .foregroundColor(.white)
                    Spacer()
                    Text(String(format: "%.2f", control.value))
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.8))
                }
            }
            
            Slider(
                value: $control.value,
                in: control.range,
                step: 0.01
            )
            .accentColor(thumbColor)
            .background(
                RoundedRectangle(cornerRadius: 2)
                    .fill(trackColor)
                    .frame(height: 4)
            )
        }
        .padding(.horizontal, 20)
    }
}

struct BaselineControls: View {
    @ObservedObject var viewModel: CameraViewModel
    
    var body: some View {
        VStack {
            Spacer()
            
            VStack(spacing: 20) {
                ControlSlider(control: viewModel.exposureCompensationControl)
                ControlSlider(control: viewModel.focusControl)
            }
            .padding(20)
            .padding(.horizontal, 20)
        }
    }
}