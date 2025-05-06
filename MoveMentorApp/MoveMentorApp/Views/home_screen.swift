//  ContentView.swift
//  home_screen

import SwiftUI
import UIKit

struct HomeScreen: View {
    @EnvironmentObject var session: UserSession

    let currentMonth: Int
    let currentYear: Int
    let numberOfDays: Int

    @State private var goToWorkout = false
    @State private var goToProfile = false
    @State private var goToExplore = false
    @State private var goToSettings = false

    
    @State private var selectedDay: Int? // Track the selected day
    @State private var randomQuote: String // Track the random quote
    @State private var isImagePickerPresented = false

    // Track the selected tab (page)
    @State private var selectedTab: BottomTab = .home
    
    // List of motivational quotes
    let quotes = [
        "“Each day of training\nmakes you a little stronger”",
        "“The only bad workout is the one that didn’t happen.”",
        "“Success is the sum of small efforts, repeated day in and day out.”",
        "“Your body can stand almost anything. It’s your mind that you have to convince.”",
        "“Push yourself because no one else is going to do it for you.”"
    ]
    
    init() {
        let calendar = Calendar.current
        let currentDate = Date()
        self.currentMonth = calendar.component(.month, from: currentDate)
        self.currentYear = calendar.component(.year, from: currentDate)
        self.numberOfDays = calendar.range(of: .day, in: .month, for: currentDate)?.count ?? 30
        // Set the selectedDay to the current day
        self._selectedDay = State(initialValue: calendar.component(.day, from: currentDate)) // Default to today
        
        // Set the random quote on initialization
        self._randomQuote = State(initialValue: quotes.randomElement() ?? quotes[0]) // Pick a random quote
    }
    
    var body: some View {
        NavigationView {
            VStack {
                // Top Section
                HStack {
                    Text(randomQuote)
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.white)
                        .padding(.leading, 16)
                    
                    Spacer()
                    
                    // Profile Picture (Customizable)
                    Button(action: {
                        isImagePickerPresented.toggle()
                    }) {
                        Group {
                            if let image = session.profileImage {
                                image
                                    .resizable()
                                    .scaledToFill()
                            } else if let url = URL(string: session.profileImageURL), !session.profileImageURL.isEmpty {
                                AsyncImage(url: url) { phase in
                                    switch phase {
                                    case .success(let image):
                                        image
                                            .resizable()
                                            .scaledToFill()
                                    case .failure(_):
                                        Image("default_profile")
                                            .resizable()
                                            .scaledToFill()
                                    case .empty:
                                        ProgressView()
                                    @unknown default:
                                        EmptyView()
                                    }
                                }
                            } else {
                                Image("default_profile")
                                    .resizable()
                                    .scaledToFill()
                            }
                        }
                        .frame(width: 50, height: 50)
                        .clipShape(Circle())
                        .overlay(Circle().stroke(Color.white, lineWidth: 2))
                        .padding(.trailing, 16)
                    }

                }
                .padding(.top, 16)
                .background(Color(hex: "#353A50")) // Background color for top section of screen
                
                // Progress Section
                Text("Let's look at your Progress!")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(.white)
                    .padding(.top, 16)
                
                // Dynamically Generated Days of the Month
                ScrollViewReader { proxy in
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 12) {
                            ForEach(1...numberOfDays, id: \.self) { day in
                                Text("\(day)")
                                    .font(.system(size: 16, weight: .bold))
                                    .frame(width: 40, height: 40)
                                    .background(self.selectedDay == day ? Color.pink : Color.gray) // Change color based on selection
                                    .foregroundColor(.white)
                                    .clipShape(Circle())
                                    .id(day) // Add an ID to each day
                                    .onTapGesture {
                                        // Change selected day when tapped
                                        withAnimation {
                                            // Set selected day, if the tapped day is already selected, reset to nil
                                            if self.selectedDay == day {
                                                self.selectedDay = nil // Deselect if tapped on the same day
                                            } else {
                                                self.selectedDay = day // Select the new day
                                            }
                                        }
                                    }
                            }
                        }
                        .padding(.horizontal, 16)
                    }
                    .padding(.top, 8)
                    .onAppear {
                        // Scroll to the current day when the view appears
                        if let selectedDay = self.selectedDay {
                            proxy.scrollTo(selectedDay, anchor: .center) // Scroll to the current day
                        }
                    }
                }
                
                // Scrollable Workout Cards
                ScrollView {
                    VStack(spacing: 24) {
                        NavigationLink(destination: WorkoutDetailPage(workoutTitle: "Chest Workout", exercises: ["Push Ups", "Bench Press", "Chest Fly"])) {
                            WorkoutCard(imageName: "chest_workout", title: "Today's workout", subtitle: "Chest")
                        }
                        NavigationLink(destination: WorkoutDetailPage(workoutTitle: "Quads & Deltoids", exercises: ["Squats", "Leg Press", "Shoulder Press"])) {
                            WorkoutCard(imageName: "quad_workout", title: "Quads", subtitle: "7 Exercises", difficulty: "Easy")
                        }
                        NavigationLink(destination: WorkoutDetailPage(workoutTitle: "Push up Routine", exercises: ["Standard Push-ups", "Diamond Push-ups", "Incline Push-ups"])) {
                            WorkoutCard(imageName: "push_up", title: "Push up Routine", subtitle: "12 Exercises", difficulty: "Medium")
                        }
                    }
                    .padding(.horizontal, 16)
                }
                .padding(.top, 16)
                // Navigation destinations trigger
                //MARK: Navigation Links
                HomeNavBarView()
                .padding()
                .background(Color(hex: "2A2E43").opacity(0.8))// Background color of bottom nav
                .clipShape(Capsule())
                .padding(.bottom, 1)
            }
            .background(Color(hex: "#2A2E43").edgesIgnoringSafeArea(.all)) // Color of entire background
            .sheet(isPresented: $isImagePickerPresented) {
                ProfileImagePicker(isPresented: $isImagePickerPresented, image: $session.profileImage)
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


//Preview
struct HomeScreen_Previews: PreviewProvider {
    static var previews: some View {
        HomeScreen()
    }
}

