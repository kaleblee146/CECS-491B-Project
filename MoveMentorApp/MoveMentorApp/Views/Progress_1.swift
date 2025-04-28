import SwiftUI

struct Progress_1_View: View {
    @State private var goToStats = false
    @State private var goToCalendar = false
    @State private var selectedButton: Int? = nil

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                ScrollView {
                    VStack(spacing: 16) {
                        // Profile Circle
                        Circle()
                            .frame(width: 138, height: 138)
                            .padding(.top, 40)

                        // Name and Member Info
                        Text("Jhon Smith")
                            .foregroundColor(.white)

                        Text("Member since 2020")
                            .foregroundColor(.gray)

                        // Height / Age / Weight box
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color.magenta)
                            .frame(width: 350, height: 80)
                            .overlay(
                                HStack {
                                    VStack {
                                        Text("5'10")
                                        Text("Height")
                                    }
                                    .padding(20)

                                    VStack {
                                        Text("24")
                                        Text("Years old")
                                    }
                                    .padding(20)

                                    VStack {
                                        Text("200 lbs")
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
                Progress_2_View()
            }
            .navigationDestination(isPresented: $goToStats) {
                Progress_3_View()
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
