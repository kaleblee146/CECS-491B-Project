

import SwiftUI
import UIKit
import AVFoundation

struct SettingsView: View {
    let columns = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]
    
    let items = [
        ("slider.horizontal.3", "Preferences"),
        ("person", "Profile"),
        ("lock", "Data & Privacy"),
        ("camera", "Camera"),
        ("paintbrush", "Appearance"),
        ("book", "Terms of Service"),
        ("questionmark.circle", "FAQ"),
        ("exclamationmark.circle", "Report a Bug"),
        ("trash", "Delete Account")
    ]
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Settings")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding(.top, 20)
                    .overlay(
                        Image(systemName: "gearshape")
                            .foregroundColor(.white)
                            .offset(x: -80)
                            .offset(y: 10)
                    )
                
                Button(action: {
                    // Logout Button
                }) {
                    Text("Logout")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color(.pink))
                        .cornerRadius(10)
                        .padding(.horizontal, 40)
                }
                .padding(.top, 10)
                
                LazyVGrid(columns: columns, spacing: 20) {
                    ForEach(items.indices, id: \.self) { index in
                        let item = items[index]
                        NavigationLink(destination: destinationView(for: item.1)) {
                            VStack {
                                Image(systemName: item.0)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 30, height: 30)
                                    .foregroundColor(Color.pink)
                                Text(item.1)
                                    .foregroundColor(.white)
                                    .font(.footnote)
                            }
                            .frame(width: 100, height: 80)
                            .background(Color.black.opacity(0.3))
                            .cornerRadius(10)
                        }
                    }
                }
                .padding(.top, 20)
                .padding(.horizontal)
                
                Spacer()
                
                SettingsNavBarView()
            }
            .background(Color(hex: "#2A2E43").edgesIgnoringSafeArea(.all))
        }
    }
    
    @ViewBuilder
    private func destinationView(for item: String) -> some View {
        switch item {
        case "Preferences": PreferencesView()
        case "Profile": ProfileView()
        case "Data & Privacy": DataPrivacyView()
        case "Camera": CameraCalibrationView()
        case "Appearance": AppearanceView()
        case "Terms of Service": TermsOfServiceView()
        case "FAQ": FAQView()
        case "Report a Bug": BugReportView()
        //case "Delete Account": DeleteAccountView()
        default: EmptyView()
        }
    }
}

//Preference Settings
struct PreferencesView: View {
    @State private var allowNotifications = UserDefaults.standard.bool(forKey: "allowNotifications")
    @State private var autoTracking = UserDefaults.standard.bool(forKey: "autoTracking")
    @State private var privateProfile = UserDefaults.standard.bool(forKey: "privateProfile")
    @State private var measurementSystem = UserDefaults.standard.string(forKey: "measurementSystem") ?? "Imperial"
    @State private var selectedLanguage = UserDefaults.standard.string(forKey: "selectedLanguage") ?? "English"
    
    @State private var showLanguagePicker = false
    @State private var showingApplyAlert = false
    
    let languages = ["English", "Spanish", "French", "German", "Chinese", "Japanese"]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Preferences")
                .font(.largeTitle)
                .foregroundColor(.white)
                .bold()
                .padding(.top)
            
            preferenceToggle(title: "Allow Notifications", isOn: $allowNotifications)
            preferenceToggle(title: "Automatic activity tracking", isOn: $autoTracking)
            preferenceToggle(title: "Set profile to private", isOn: $privateProfile)
            
            preferencePicker(title: "Unit of Measurement", selection: $measurementSystem, options: ["Imperial", "Metric"])
            
            preferencePicker(title: "Language", selection: $selectedLanguage, options: languages)
                .onChange(of: selectedLanguage) { _ in saveSettings() }
          
            Spacer()
            HStack(spacing: 16) {
                Button(action: {
                    resetSettings()
                }) {
                    Text("Reset")
                        .foregroundColor(.white)
                        .frame(width: 150, height: 50)
                        .background(Color.blue)
                        .cornerRadius(12)
                        .contentShape(Rectangle())
                }

                Spacer(minLength: 5)

                Button(action: {
                    saveSettings()
                    showingApplyAlert = true
                }) {
                    Text("Apply")
                        .foregroundColor(.white)
                        .frame(width: 150, height: 50)
                        .background(Color.pink)
                        .cornerRadius(12)
                        .contentShape(Rectangle())
                }
                .alert(isPresented: $showingApplyAlert) {
                    Alert(title: Text("Settings updated"))
                }
            }
            Spacer()
            }
            .padding()
            .background(Color(hex: "#2A2E43").edgesIgnoringSafeArea(.all))
            .onAppear { loadSettings() }    }
    
    private func preferenceToggle(title: String, isOn: Binding<Bool>) -> some View {
        HStack {
            Text(title)
                .foregroundColor(.white)
                .frame(width: 170, alignment: .leading)
            
            Spacer()
            
            Toggle("", isOn: isOn)
                .toggleStyle(SwitchToggleStyle(tint: .purple))
                .labelsHidden()
                .frame(width: 150)
                .onChange(of: isOn.wrappedValue) { _ in saveSettings() }
        }
    }
    
    private func preferencePicker(title: String, selection: Binding<String>, options: [String]) -> some View {
        HStack {
            Text(title)
                .foregroundColor(.white)
                .frame(width: 170, alignment: .leading)
            
            Spacer()
            
            Picker(title, selection: selection) {
                ForEach(options, id: \.self) { option in
                    Text(option).tag(option)
                }
            }
            .pickerStyle(MenuPickerStyle())
            .foregroundColor(.white)
            .padding()
            .frame(width: 150)
            .background(Color.black.opacity(0.3))
            .cornerRadius(8)
            .onChange(of: selection.wrappedValue) { _ in saveSettings() }
        }
    }

    private func saveSettings() {
        UserDefaults.standard.set(allowNotifications, forKey: "allowNotifications")
        UserDefaults.standard.set(autoTracking, forKey: "autoTracking")
        UserDefaults.standard.set(privateProfile, forKey: "privateProfile")
        UserDefaults.standard.set(measurementSystem, forKey: "measurementSystem")
        UserDefaults.standard.set(selectedLanguage, forKey: "selectedLanguage")
    }
    
    private func loadSettings() {
        allowNotifications = UserDefaults.standard.bool(forKey: "allowNotifications")
        autoTracking = UserDefaults.standard.bool(forKey: "autoTracking")
        privateProfile = UserDefaults.standard.bool(forKey: "privateProfile")
        measurementSystem = UserDefaults.standard.string(forKey: "measurementSystem") ?? "Imperial"
        selectedLanguage = UserDefaults.standard.string(forKey: "selectedLanguage") ?? "English"
    }
    
    private func resetSettings() {
        allowNotifications = false
        autoTracking = false
        privateProfile = false
        measurementSystem = "Metric"
        selectedLanguage = "English"
        
        saveSettings()
    }
}

struct LanguagePickerView: View {
    @Binding var selectedLanguage: String
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            List {
                ForEach(["English", "Spanish", "French", "German", "Chinese", "Japanese"], id: \.self) { language in
                    Button(action: {
                        selectedLanguage = language
                    }) {
                        HStack {
                            Text(language)
                                .foregroundColor(.primary)
                            Spacer()
                            if selectedLanguage == language {
                                Image(systemName: "checkmark")
                                    .foregroundColor(.blue)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Select Language")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                    .foregroundColor(.blue)
                }
            }
        }
    }
}

// Profile View
struct ProfileView: View {
    @State private var username: String = "......."
    @State private var phone: String = "Please add a valid phone number"
    
    @State private var newUsername: String = ""
    @State private var newPhone: String = ""
    @State private var isEditingUsername = false
    @State private var isEditingPhone = false
    @State private var showPasswordAlert = false
    @State private var showDeactivateConfirmation = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Account Settings")
                .font(.largeTitle)
                .foregroundColor(.white)
                .bold()
                .padding(.top)
            
            // Username
            SettingItem(title: "Username", subtitle: username) {
                isEditingUsername.toggle()
            }
            .sheet(isPresented: $isEditingUsername) {
                VStack {
                    Text("Enter New Username")
                        .font(.title)
                        .padding()
                    
                    TextField("New Username", text: $newUsername)
                        .padding()
                        .background(Color.black.opacity(0.3))
                        .cornerRadius(10)
                        .foregroundColor(.white)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                    
                    Button("Save") {
                        if !newUsername.isEmpty {
                            username = newUsername
                        }
                        isEditingUsername = false
                    }
                    .padding()
                    .background(Color.pink)
                    .cornerRadius(10)
                    .foregroundColor(.white)
                    
                    Button("Cancel") {
                        isEditingUsername = false
                    }
                    .padding()
                }
                .background(Color(hex: "#2A2E43").edgesIgnoringSafeArea(.all))
            }
            
            // Phone
            SettingItem(title: "Phone", subtitle: phone) {
                isEditingPhone.toggle()
            }
            .sheet(isPresented: $isEditingPhone) {
                VStack {
                    Text("Enter New Phone Number")
                        .font(.title)
                        .padding()
                    
                    TextField("New Phone Number", text: $newPhone)
                        .padding()
                        .background(Color.black.opacity(0.3))
                        .cornerRadius(10)
                        .foregroundColor(.white)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                    
                    Button("Save") {
                        if !newPhone.isEmpty {
                            phone = newPhone
                        }
                        isEditingPhone = false
                    }
                    .padding()
                    .background(Color.pink)
                    .cornerRadius(10)
                    .foregroundColor(.white)
                    
                    Button("Cancel") {
                        isEditingPhone = false
                    }
                    .padding()
                }
                .background(Color(hex: "#2A2E43").edgesIgnoringSafeArea(.all))
            }
            
            // Password
            SettingItem(title: "Password", subtitle: "Change password") {
                showPasswordAlert.toggle()
            }
            .alert(isPresented: $showPasswordAlert) {
                Alert(
                    title: Text("Password Reset"),
                    message: Text("A link to reset your password has been sent to your email."),
                    dismissButton: .default(Text("OK"))
                )
            }
            
            // Notifications - This will link to NotificationSettingsView
            NavigationLink(destination: NotificationSettingsView()) {
                SettingItem(title: "Notifications", subtitle: "Change notification settings") {
                    // Navigate to the NotificationSettingsView
                }
            }
            
            // Deactivate Account
            SettingItem(title: "Deactivate Account", subtitle: "Reactivate your account anytime") {
                showDeactivateConfirmation.toggle()
            }
            .alert(isPresented: $showDeactivateConfirmation) {
                Alert(
                    title: Text("Confirm Deactivation"),
                    message: Text("Are you sure you want to deactivate your account?"),
                    primaryButton: .destructive(Text("Deactivate")) {
                        // Deactivate account logic
                    },
                    secondaryButton: .cancel()
                )
            }
            
            Spacer()
        }
        .padding()
        .background(Color(hex: "#2A2E43").edgesIgnoringSafeArea(.all))
    }
}

struct SettingItem: View {
    let title: String
    let subtitle: String
    let action: () -> Void
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .foregroundColor(.white)
                .bold()
            Text(subtitle)
                .foregroundColor(.gray)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.black.opacity(0.3))
        .cornerRadius(10)
        .onTapGesture {
            action()
        }
    }
}

struct NotificationSettingsView: View {
    @State private var emailNotifications: Bool = false
    @State private var pushNotifications: Bool = false
    @State private var smsNotifications: Bool = false

    var body: some View {
        VStack(spacing: 20) {
            Text("Notification Settings")
                .font(.largeTitle)
                .foregroundColor(.white)
                .bold()

            Toggle("Email Notifications", isOn: $emailNotifications)
                .toggleStyle(SwitchToggleStyle(tint: Color.pink))
            Toggle("Push Notifications", isOn: $pushNotifications)
                .toggleStyle(SwitchToggleStyle(tint: Color.pink))
            Toggle("SMS Notifications", isOn: $smsNotifications)
                .toggleStyle(SwitchToggleStyle(tint: Color.pink))

            HStack {
                Button("Reset") {
                    // Reset notification preferences
                    emailNotifications = false
                    pushNotifications = false
                    smsNotifications = false
                }
                .foregroundColor(.pink)

                Spacer()

                Button("Apply") {
                    // Apply changes to notification settings
                }
                .foregroundColor(.pink)
            }
        }
        .padding()
        .background(Color(hex: "#2A2E43").edgesIgnoringSafeArea(.all))
    }
}
// Data & Privacy View
struct DataPrivacyView: View {
    @AppStorage("useLocation") private var useLocation = true
    @AppStorage("preciseLocation") private var preciseLocation = true
    @AppStorage("doNotSellInfo") private var doNotSellInfo = true

    // Regular properties to store original values
    @State private var originalUseLocation: Bool
    @State private var originalPreciseLocation: Bool
    @State private var originalDoNotSellInfo: Bool

    // State for the confirmation alert
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var alertTitle = ""

    // Custom initializer to set original values
    init() {
        // Initialize the stored values here instead of in @State properties
        _originalUseLocation = State(initialValue: true) // Default value, you can change this if needed
        _originalPreciseLocation = State(initialValue: true) // Default value
        _originalDoNotSellInfo = State(initialValue: true) // Default value
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Data & Privacy")
                .font(.largeTitle)
                .bold()
                .foregroundColor(.white)

            toggleRow("Use my location", isOn: $useLocation)
            toggleRow("Allow precise location", isOn: $preciseLocation)
            toggleRow("Sell my information", isOn: $doNotSellInfo)

            Spacer()
            
            HStack {
                Button(action: resetDefaults) {
                    Text("Reset")
                        .foregroundColor(.white)
                        .frame(width: 150, height: 50)
                        .background(Color.blue)
                        .cornerRadius(12)
                        .contentShape(Rectangle())
                }

                Spacer(minLength: 5)

                Button(action: applyChanges) {
                    Text("Apply")
                        .foregroundColor(.white)
                        .frame(width: 150, height: 50)
                        .background(Color.pink)
                        .cornerRadius(12)
                        .contentShape(Rectangle())
                }
                .alert(isPresented: $showAlert) {
                    Alert(title: Text(alertTitle),
                          message: Text(alertMessage),
                          dismissButton: .default(Text("OK")))
                }
            }
        }
        .padding()
        .background(Color(hex: "#2A2E43").edgesIgnoringSafeArea(.all))
    }

    func toggleRow(_ title: String, isOn: Binding<Bool>) -> some View {
        HStack {
            Text(title)
                .foregroundColor(.white)
            Spacer()
            Toggle("", isOn: isOn)
                .toggleStyle(SwitchToggleStyle(tint: Color.purple))
        }
    }

    func resetDefaults() {
        // Reset to the original values
        useLocation = originalUseLocation
        preciseLocation = originalPreciseLocation
        doNotSellInfo = originalDoNotSellInfo
    }

    func applyChanges() {
        // Show the "Settings Applied" message with the OK button
        alertTitle = "Settings Applied"
        showAlert = true
    }
}

// Camera Calibration View
struct CameraCalibrationView: View {
    @Environment(\.dismiss) var dismiss

    @State private var calibrationSteps = [
        ("Setting 1", false),
        ("Setting 1", false),
        ("Setting 1", true),
        ("Setting 1", false),
        ("Setting 1", true),
        ("Setting 1", true),
        ("Setting 1", false),
        ("Setting 1", false)
    ]

    var body: some View {
        VStack(spacing: 20) {
            Text("Calibration")
                .font(.headline)
                .foregroundColor(.white)
                .padding(.top)

            Text("Welcome to Camera Calibration")
                .font(.subheadline)
                .foregroundColor(.gray)
                .padding(.horizontal)
                .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity)

            HStack(spacing: 16) {
                // Camera Preview Area (Simulated)
                ZStack(alignment: .topLeading) {
                    CameraPreview()
                        .scaledToFill()
                        .frame(width: 200, height: 300)
                        .clipped()
                        .cornerRadius(12)

                }

                // Calibration Steps
                ScrollView {
                    VStack(spacing: 12) {
                        ForEach(0..<calibrationSteps.count, id: \.self) { index in
                            HStack {
                                Text(calibrationSteps[index].0)
                                    .foregroundColor(.white)
                                    .font(.subheadline)

                                Spacer()

                                Image(systemName: calibrationSteps[index].1 ? "checkmark" : "xmark")
                                    .foregroundColor(calibrationSteps[index].1 ? .white : .pink)
                            }
                            .padding(.horizontal)
                            .frame(height: 40)
                            .background(Color(hex: "#FF4081")) // Pink for all cells
                            .cornerRadius(8)
                        }
                    }
                }
                .frame(height: 300)
                .frame(maxWidth: 160)
            }
            .padding(.horizontal)

            Button(action: {
                dismiss()
            }) {
                Text("CONFIRM")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .background(Color(hex: "#FF4081"))
                    .cornerRadius(12)
                    .padding(.horizontal, 60)
            }

            Spacer()
        }
        .background(Color(hex: "#2A2E43").edgesIgnoringSafeArea(.all))
    }
}

//Camera Preview (Should work when ruuning app)
struct CameraPreview: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> some UIViewController {
        let controller = CameraViewController()
        return controller
    }

    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {}
}

class CameraViewController: UIViewController {
    private var captureSession: AVCaptureSession?

    override func viewDidLoad() {
        super.viewDidLoad()

        checkPermissionAndSetup()
    }

    private func checkPermissionAndSetup() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            setupCamera()
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { granted in
                if granted {
                    DispatchQueue.main.async {
                        self.setupCamera()
                    }
                }
            }
        default:
            // Show alert or instructions
            break
        }
    }

    private func setupCamera() {
        let session = AVCaptureSession()
        session.sessionPreset = .photo

        guard let device = AVCaptureDevice.default(for: .video),
              let input = try? AVCaptureDeviceInput(device: device) else {
            return
        }

        if session.canAddInput(input) {
            session.addInput(input)
        }

        let previewLayer = AVCaptureVideoPreviewLayer(session: session)
        previewLayer.videoGravity = .resizeAspectFill
        previewLayer.frame = view.bounds

        view.layer.addSublayer(previewLayer)
        session.startRunning()

        captureSession = session
    }
}
// Appearance View
struct AppearanceView: View {
    @AppStorage("darkMode") private var darkMode = true

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Appearance")
                .font(.largeTitle)
                .foregroundColor(.white)
                .bold()

            HStack {
                Text("Enable Dark Mode")
                    .foregroundColor(.white)
                Spacer()
                Toggle("", isOn: $darkMode)
                    .toggleStyle(SwitchToggleStyle(tint: Color.purple))
            }

            Spacer()
        }
        .padding()
        .background(Color(hex: "#2A2E43").edgesIgnoringSafeArea(.all))
    }
}

// Terms of Service View
struct TermsOfServiceView: View {
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        VStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    Text("Terms of Service")
                        .font(.title)
                        .bold()
                        .foregroundColor(.white)
                        .padding(.bottom, 10)

                    Text(loremIpsum)
                        .font(.body)
                        .foregroundColor(.white)
                }
                .padding()
            }

            Button(action: {
                presentationMode.wrappedValue.dismiss()
            }) {
                Text("Accept and Continue")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.pink)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .padding(.horizontal)
                    .padding(.bottom, 10)
            }
        }
        .background(Color(hex: "#2A2E43").ignoresSafeArea())
        
    }

    private let loremIpsum = """
    Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium.

    Nemo enim ipsam voluptatem quia voluptas sit aspernatur aut odit aut fugit, sed quia consequuntur magni dolores eos qui ratione voluptatem sequi nesciunt.

    Neque porro quisquam est, qui dolorem ipsum quia dolor sit amet, consectetur, adipisci velit. Sed quia non numquam eius modi tempora incidunt ut labore et dolore magnam aliquam quaerat voluptatem.

    Ut enim ad minima veniam, quis nostrum exercitationem ullam corporis suscipit laboriosam, nisi ut aliquid ex ea commodi consequatur?

    Quis autem vel eum iure reprehenderit qui in ea voluptate velit esse quam nihil molestiae consequatur, vel illum qui dolorem eum fugiat quo voluptas nulla pariatur?
    """
}

// FAQ View
struct FAQView: View {
    @State private var expandedIndices: Set<Int> = []

    let faqs = [
        ("What is Movementor?", "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum"),
        
        ("How does it all work?", "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum"),
        
        ("Do I need special equipment?", "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum")
    ]

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text("Frequently Asked Questions")
                    .font(.largeTitle)
                    .foregroundColor(.white)
                    .bold()
                    .padding(.top)

                ForEach(faqs.indices, id: \.self) { index in
                    DisclosureGroup(
                        isExpanded: Binding(
                            get: { expandedIndices.contains(index) },
                            set: { isExpanded in
                                if isExpanded {
                                    expandedIndices.insert(index)
                                } else {
                                    expandedIndices.remove(index)
                                }
                            }
                        ),
                        content: {
                            Text(faqs[index].1)
                                .foregroundColor(.white)
                                .padding(.top, 5)
                        },
                        label: {
                            Text(faqs[index].0)
                                .foregroundColor(.white)
                                .fontWeight(.semibold)
                        }
                    )
                    .padding()
                    .background(Color.black.opacity(0.3))
                    .cornerRadius(12)
                }

                Spacer()
            }
            .padding()
        }
        .background(Color(hex: "#2A2E43").edgesIgnoringSafeArea(.all))
    }
}

// Bug Reporting View
struct BugReportView: View {
    @State private var bugDescription = ""
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack {
            Text("Report a Bug")
                .font(.largeTitle)
                .foregroundColor(.white)
                .bold()
            
            TextEditor(text: $bugDescription)
                .frame(height: 200)
                .background(Color.black.opacity(0.3))
                .cornerRadius(10)
                .foregroundColor(.black)
                .padding()
            
            Button("Submit") {
                submitBugReport()
                presentationMode.wrappedValue.dismiss()
            }
            .foregroundColor(.white)
            .padding()
            .background(Color.pink)
            .cornerRadius(10)
            
            Spacer()
        }
        .padding()
        .background(Color(hex: "#2A2E43").edgesIgnoringSafeArea(.all))
    }
    
    func submitBugReport() {
        guard let token = UserDefaults.standard.string(forKey: "jwtToken"),
              let url = URL(string: "https://your-backend.com/api/bug-reports/") else {
            return
        }
        
        let payload = ["message": bugDescription]
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONSerialization.data(withJSONObject: payload)
        
        URLSession.shared.dataTask(with: request).resume()
    }
    
    // Delete Account View
    struct DeleteAccountView: View {
        @State private var showConfirmation = false
        
        var body: some View {
            VStack(spacing: 20) {
                Text("Delete Account")
                    .font(.largeTitle)
                    .foregroundColor(.white)
                    .bold()
                
                Text("This action is irreversible. Are you sure you want to delete your account?")
                    .foregroundColor(.gray)
                
                Button("Delete My Account") {
                    showConfirmation = true
                }
                .alert(isPresented: $showConfirmation) {
                    Alert(
                        title: Text("Are you sure?"),
                        message: Text("Your account will be permanently deleted."),
                        primaryButton: .destructive(Text("Delete")) {
                            // Handle delete
                        },
                        secondaryButton: .cancel()
                    )
                }
                .foregroundColor(.white)
                .padding()
                .background(Color.red)
                .cornerRadius(10)
                
                Spacer()
            }
            .padding()
            .background(Color(hex: "#2A2E43").edgesIgnoringSafeArea(.all))
        }
    }
    
    
    // Preview
    struct SettingsView_Previews: PreviewProvider {
        static var previews: some View {
            SettingsView()
        }
    }
}
