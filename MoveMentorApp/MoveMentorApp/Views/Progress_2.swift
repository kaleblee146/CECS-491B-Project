import SwiftUI

struct Progress_2_View: View {
    @EnvironmentObject var session: UserSession

    @State private var goToAnalytics = false
    @State private var goToStats = false
    
    @State private var isImagePickerPresented = false


    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                ScrollView {
                    VStack(spacing: 16) {
                        // Profile photo
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
                        
                        Text("\(session.firstName) \(session.lastName)")
                            .foregroundColor(.white)

                        Text("Member since \(session.joinedYear)")      .foregroundColor(.white)

                        // Height, Age, Weight box
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

                        // Analytics, Calendar, Stats Buttons
                        HStack(spacing: 12) {
                            Button("Analytics") {
                                goToAnalytics = true
                            }
                            .frame(width: 106, height: 45)
                            .background(Color.textBoxNavy)
                            .cornerRadius(15)

                            Button("Calendar") {
                                // Already on calendar
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

                        // Calendar
                        CalendarView()
                            .padding(.vertical)

                        // Planned and Completed Buttons
                        VStack(spacing: 20) {
                            plannedCompletedButton(title: "Planned", imageName: "Planned")
                            plannedCompletedButton(title: "Completed", imageName: "Completed")
                        }
                        .padding(.top, 10)
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
            .navigationDestination(isPresented: $goToAnalytics) {
                Progress_1_View()
                    .environmentObject(session)
            }
            .navigationDestination(isPresented: $goToStats) {
                Progress_3_View()
                    .environmentObject(session)
            }
            .sheet(isPresented: $isImagePickerPresented) {
                ProfileImagePicker(isPresented: $isImagePickerPresented, image: $session.profileImage)
            }
        }
    }

    // Helper for Planned and Completed small cards
    func plannedCompletedButton(title: String, imageName: String) -> some View {
        HStack(alignment: .center) {
            Spacer()
            Button(title) {
                // Action when clicked
            }
            .frame(width: 75, height: 35)
            .background(Color.textBoxNavy)
            .cornerRadius(10)

            Image(imageName)
                .resizable()
                .frame(width: 40, height: 40)
        }
        .padding(.horizontal)
    }
}

struct Progress_2_View_Preview: PreviewProvider {
    static var previews: some View {
        Progress_2_View()
    }
}
