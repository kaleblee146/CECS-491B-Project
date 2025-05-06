import SwiftUI

struct Progress_1_View: View {
    @EnvironmentObject var session: UserSession

    @State private var goToStats = false
    @State private var goToCalendar = false
    @State private var selectedButton: Int? = nil
    
    @State private var isImagePickerPresented = false

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                ScrollView {
                    VStack(spacing: 16) {
                        // Profile Circle
                        Button(action: {
                            isImagePickerPresented = true
                        }) {
                            if let image = session.profileImage {
                                image
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 138, height: 138)
                                    .clipShape(Circle())
                                    .overlay(Circle().stroke(Color.white, lineWidth: 2))
                            } else if let url = URL(string: session.profileImageURL) {
                                AsyncImage(url: url) { image in
                                    image
                                        .resizable()
                                        .scaledToFill()
                                } placeholder: {
                                    ProgressView()
                                }
                                .frame(width: 138, height: 138)
                                .clipShape(Circle())
                                .overlay(Circle().stroke(Color.white, lineWidth: 2))
                            } else {
                                Circle()
                                    .fill(Color.gray)
                                    .frame(width: 138, height: 138)
                                    .overlay(Circle().stroke(Color.white, lineWidth: 2))
                            }
                        }
                        .padding(.top, 40)


                        // Name and Member Info
                        Text("\(session.firstName) \(session.lastName)")
                            .foregroundColor(.white)

                    
                        Text("Member since \(session.joinedYear)")      .foregroundColor(.white)
                        

                        // Height / Age / Weight box
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color.magenta)
                            .frame(width: 350, height: 80)
                            .overlay(
                                HStack {
                                    VStack {
                                        Text("\(session.height, specifier: "%.1f")")
                                        Text("Height")
                                    }
                                    .padding(20)

                                    VStack {
                                        Text("\(session.age)")
                                        Text("Years old")
                                    }
                                    .padding(20)

                                    VStack {
                                        Text("\(session.weight, specifier: "%.1f")")
                                        Text("Weight")
                                    }
                                    .padding(20)
                                }
                            )
                            .padding(.top, 10)

                        // Analytics, Calendar, Stats buttons
                        HStack(spacing: 12) {
                            Button("Analytics") {
                                // Already here or in future
                            }
                            .frame(width: 106, height: 45)
                            .background(Color.textBoxNavy)
                            .cornerRadius(15)

                            Button("Calendar") {
                                goToCalendar = true
                            }
                            .frame(width: 106, height: 45)
                            .background(Color.textBoxNavy)
                            .cornerRadius(15)

                            Button("Stats") {
                                goToStats = true
                            }
                            .frame(width: 106, height: 45)
                            .background(Color.textBoxNavy)
                            .cornerRadius(15)
                        }
                        .padding(.top, 10)

                        // Progress Cards Section
                        VStack(spacing: 20) {
                            workoutCard(imageName: "progress_best_workout", title: "Best Workout", subtitle: "27 Workouts Completed", date: "10/08/2020 17:24")
                            
                            workoutCard(imageName: "progress_workout_week", title: "Workout of the week", subtitle: "727 Workouts Completed", date: "7/08/2020 12:11")
                            
                            workoutCard(imageName: "progress_exercise_complete", title: "188 Workouts Completed", subtitle: "", date: "1/06/2020 18:23")
                        }
                        .padding(.top, 20)
                    }
                    .frame(maxWidth: .infinity)
                }
                .background(Color.navy)

                // Sticky bottom nav bar
                ProfileNavBarView()
                    .padding(.bottom, 5)
            }
            .background(Color.navy)
            .ignoresSafeArea(.keyboard, edges: .bottom)
            .navigationDestination(isPresented: $goToCalendar) {
                Progress_2_View()                    .environmentObject(session)

            }
            .navigationDestination(isPresented: $goToStats) {
                Progress_3_View()
                    .environmentObject(session)

            }
            .sheet(isPresented: $isImagePickerPresented) {
                ProfileImagePicker(isPresented: $isImagePickerPresented, image: $session.profileImage)
            }

            .onChange(of: session.profileImage) { _ in
                if let uiImage = session.rawProfileUIImage {
                    Task {
                        do {
                            try await NetworkManager.shared.uploadProfileImage(
                                image: uiImage,
                                username: session.username
                            )
                            print("✅ Profile picture uploaded successfully.")
                        } catch {
                            print("❌ Upload failed: \(error)")
                        }
                    }
                }
            }

        }
    }

    // Workout Card component
    func workoutCard(imageName: String, title: String, subtitle: String, date: String) -> some View {
        RoundedRectangle(cornerRadius: 15)
            .fill(Color.textBoxNavy)
            .frame(width: 348, height: 128)
            .overlay(
                HStack {
                    Image(imageName)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 80, height: 80)
                        .padding()

                    VStack(alignment: .leading) {
                        Text(title)
                            .font(.headline)
                            .foregroundColor(.white)

                        if !subtitle.isEmpty {
                            Text(subtitle)
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }

                        Text(date)
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                }
                .padding(.leading, 5)
            )
    }
}

struct Progress_1_Previews: PreviewProvider {
    static var previews: some View {
        Progress_1_View()
    }
}
