import SwiftUI

struct CameraSettingsView: View {
    var body: some View {
        VStack {
            Text("Camera Settings")
                .font(.largeTitle)
                .padding()

            Text("Settings options coming soon...")
                .foregroundColor(.gray)
                .padding()

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
