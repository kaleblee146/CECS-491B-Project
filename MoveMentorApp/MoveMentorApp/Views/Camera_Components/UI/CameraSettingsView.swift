import SwiftUI

struct CameraSettingsView: View {
    @Environment(\.presentationMode) var presentationMode  // ✅ Allows dismissing the view

    @State private var brightness: Double = 0.5
    @State private var contrast: Double = 0.5
    @State private var sharpness: Double = 0.5

    var body: some View {
        VStack(spacing: 20) {
            // Top Bar with Back Button
            HStack {
                Button(action: {
                    presentationMode.wrappedValue.dismiss()  // ✅ Dismiss on tap
                }) {
                    Image(systemName: "chevron.left")
                        .font(.title2)
                        .foregroundColor(.blue)
                        .padding()
                }

                Spacer()

                Text("Camera Settings")
                    .font(.headline)
                    .padding()

                Spacer()

                // Just filler to center title
                Spacer()
                    .frame(width: 44)
            }
            .background(Color(.systemGray6))

            Divider()

            // Example Sliders (Not functional yet)
            Group {
                VStack(alignment: .leading) {
                    Text("Pose Confidence")
                    Slider(value: $brightness, in: 0...1)
                }
                .padding()

                VStack(alignment: .leading) {
                    Text("Joint Confidence")
                    Slider(value: $contrast, in: 0...1)
                }
                .padding()

                VStack(alignment: .leading) {
                    Text("Limb Detection")
                    Slider(value: $sharpness, in: 0...1)
                }
                .padding()
            }

            Spacer()
        }
        .background(Color(.systemBackground))
    }
}

struct CameraSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        CameraSettingsView()
    }
}
