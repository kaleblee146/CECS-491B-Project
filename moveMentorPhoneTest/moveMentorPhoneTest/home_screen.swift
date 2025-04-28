//  ContentView.swift
//  home_screen

import SwiftUI
import UIKit

struct HomeScreen: View {
    @State private var selectedDay: Int?
    @State private var randomQuote: String
    @State private var profileImage: Image?
    @State private var isImagePickerPresented = false
    
    @Binding var selectedTab: BottomTab
    
    @State private var goToWorkout = false
    @State private var goToProfile = false
    @State private var goToExplore = false
    @State private var goToSettings = false

    let currentMonth: Int
    let currentYear: Int
    let numberOfDays: Int

    let quotes = [
        "\"Each day of training\nmakes you a little stronger\"",
        "\"The only bad workout is the one that didn’t happen.\"",
        "\"Success is the sum of small efforts, repeated day in and day out.\"",
        "\"Your body can stand almost anything. It’s your mind that you have to convince.\"",
        "\"Push yourself because no one else is going to do it for you.\""
    ]

    init(selectedTab: Binding<BottomTab>) {
        let calendar = Calendar.current
        let currentDate = Date()
        self._selectedTab = selectedTab
        self.currentMonth = calendar.component(.month, from: currentDate)
        self.currentYear = calendar.component(.year, from: currentDate)
        self.numberOfDays = calendar.range(of: .day, in: .month, for: currentDate)?.count ?? 30
        self._selectedDay = State(initialValue: calendar.component(.day, from: currentDate))
        self._randomQuote = State(initialValue: quotes.randomElement() ?? quotes[0])
    }

    var body: some View {
        NavigationStack {
            VStack {
                // Top Section
                HStack {
                    Text(randomQuote)
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.white)
                        .padding(.leading, 16)

                    Spacer()

                    Button(action: {
                        isImagePickerPresented.toggle()
                    }) {
                        profileImage?.resizable()
                            .scaledToFill()
                            .frame(width: 50, height: 50)
                            .clipShape(Circle())
                            .overlay(Circle().stroke(Color.white, lineWidth: 2))
                            .padding(.trailing, 16)
                            ?? Image("default_profile")
                                .resizable()
                                .scaledToFill()
                                .frame(width: 50, height: 50)
                                .clipShape(Circle())
                                .overlay(Circle().stroke(Color.white, lineWidth: 2))
                                .padding(.trailing, 16)
                    }
                }
                .padding(.top, 16)
                .background(Color(hex: "#353A50"))

                Text("Let's look at your Progress!")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(.white)
                    .padding(.top, 16)

                ScrollViewReader { proxy in
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 12) {
                            ForEach(1...numberOfDays, id: \.self) { day in
                                Text("\(day)")
                                    .font(.system(size: 16, weight: .bold))
                                    .frame(width: 40, height: 40)
                                    .background(self.selectedDay == day ? Color.pink : Color.gray)
                                    .foregroundColor(.white)
                                    .clipShape(Circle())
                                    .id(day)
                                    .onTapGesture {
                                        withAnimation {
                                            self.selectedDay = self.selectedDay == day ? nil : day
                                        }
                                    }
                            }
                        }
                        .padding(.horizontal, 16)
                    }
                    .padding(.top, 8)
                    .onAppear {
                        if let selectedDay = self.selectedDay {
                            proxy.scrollTo(selectedDay, anchor: .center)
                        }
                    }
                }

                ScrollView {
                    VStack(spacing: 24) {
                        NavigationLink(destination: WorkoutDetailPage(workoutTitle: "Chest Workout", exercises: ["Push Ups", "Bench Press", "Chest Fly"])) {
                            WorkoutCard(imageName: "chest_workout", title: "Today's workout", subtitle: "Chest")
                        }
                    }
                    .padding(.horizontal, 16)
                }
                .padding(.top, 16)

                // Navigation destinations trigger
                NavigationLink(destination: CameraView(), isActive: $goToWorkout) { EmptyView() }.hidden()
                NavigationLink(destination: Progress_1_View(selectedTab: $selectedTab), isActive: $goToProfile) { EmptyView() }.hidden()
                NavigationLink(destination: ExploreView(), isActive: $goToExplore) { EmptyView() }.hidden()
                NavigationLink(destination: SettingsView(), isActive: $goToSettings) { EmptyView() }.hidden()

                HStack {
                    Spacer()
                    BottomIcon(iconName: "house.fill", isSelected: selectedTab == .home) {
                        selectedTab = .home
                    }
                    Spacer()
                    BottomIcon(iconName: "dumbbell.fill", isSelected: selectedTab == .workout) {
                        goToWorkout = true
                    }
                    Spacer()
                    BottomIcon(iconName: "person.fill", isSelected: selectedTab == .profile) {
                        goToProfile = true
                    }
                    Spacer()
                    BottomIcon(iconName: "magnifyingglass", isSelected: selectedTab == .explore) {
                        goToExplore = true
                    }
                    Spacer()
                    BottomIcon(iconName: "gearshape.fill", isSelected: selectedTab == .settings) {
                        goToSettings = true
                    }
                    Spacer()
                }
                .padding()
                .background(Color(hex: "2A2E43").opacity(0.8))
                .clipShape(Capsule())
                .padding(.bottom, 1)
            }
            .background(Color(hex: "#2A2E43").edgesIgnoringSafeArea(.all))
            .sheet(isPresented: $isImagePickerPresented) {
                ImagePicker(isPresented: $isImagePickerPresented, image: $profileImage)
            }
        }
    }
}


// UIImagePickerController wrapper using UIViewControllerRepresentable
struct ImagePicker: UIViewControllerRepresentable {
    @Binding var isPresented: Bool
    @Binding var image: Image?
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(isPresented: $isPresented, image: $image)
    }
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {
        
    }
    
    // Coordinator to handle UIImagePickerControllerDelegate methods
    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        @Binding var isPresented: Bool
        @Binding var image: Image?
        
        init(isPresented: Binding<Bool>, image: Binding<Image?>) {
            _isPresented = isPresented
            _image = image
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let selectedImage = info[.originalImage] as? UIImage {
                self.image = Image(uiImage: selectedImage) // Update the profileImage state with the selected image
            }
            self.isPresented = false // Dismiss the image picker
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            self.isPresented = false // Dismiss the image picker if canceled
        }
    }
}

// Enum for Bottom Tab Navigation
enum BottomTab {
    case home, workout, profile, explore, settings
}

// Workout Card View
struct WorkoutCard: View {
    var imageName: String
    var title: String
    var subtitle: String
    var difficulty: String? = nil
    
    var body: some View {
        ZStack(alignment: .bottomLeading) {
            Image(imageName)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(height: 150)
                .clipShape(RoundedRectangle(cornerRadius: 12))
            
            VStack(alignment: .leading) {
                Text(title)
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(.white)
                
                Text(subtitle)
                    .font(.system(size: 14))
                    .foregroundColor(.white.opacity(0.8))
                
                if let difficulty = difficulty {
                    Text(difficulty)
                        .font(.system(size: 14, weight: .bold))
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(difficulty == "Easy" ? Color.pink : Color.pink)
                        .clipShape(Capsule())
                        .foregroundColor(.white)
                }
            }
            .padding()
        }
    }
}

// Bottom Icon View
struct BottomIcon: View {
    var iconName: String
    var isSelected: Bool
    var action: () -> Void
    
    var body: some View {
        Image(systemName: iconName)
            .resizable()
            .scaledToFit()
            .frame(width: 24, height: 24)
            .foregroundColor(isSelected ? .pink : .white)
            .padding()
            .onTapGesture {
                action()
            }
            .overlay(
                Circle()
                    .stroke(isSelected ? Color.pink : Color.clear, lineWidth: 2)
            )
    }
}

// Workout Detail Page View
struct WorkoutDetailPage: View {
    var workoutTitle: String
    var exercises: [String]
    
    var body: some View {
        VStack {
            Text(workoutTitle)
                .font(.largeTitle)
                .foregroundColor(.white)
                .padding(.top, 16)
            
            List(exercises, id: \.self) { exercise in
                Text(exercise)
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(.white)
            }
            .background(Color.black.edgesIgnoringSafeArea(.all))
        }
    }
}

//Color wheel
/*
extension Color {
    init(hex: String) {
        let hex = hex.replacingOccurrences(of: "#", with: "")
        var int = UInt64()
        Scanner(string: hex).scanHexInt64(&int)
        let red = Double((int >> 16) & 0xFF) / 255.0
        let green = Double((int >> 8) & 0xFF) / 255.0
        let blue = Double(int & 0xFF) / 255.0
        self.init(red: red, green: green, blue: blue)
    }
}
*/

struct WorkoutView: View {
    var body: some View {
        Text("Workout View")
            .foregroundColor(.white)
    }
}

struct ExploreView: View {
    var body: some View {
        Text("Explore View")
            .foregroundColor(.white)
    }
}

struct HomeContent: View {
    var body: some View {
        Text("Home View")
            .foregroundColor(.white)
    }
}


//Preview
struct HomeScreen_Previews: PreviewProvider {
    static var previews: some View {
        HomeScreen(selectedTab: .constant(.home))
    }
}



