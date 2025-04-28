import SwiftUI

struct Progress_3_View: View {
    @State private var goToAnalytics = false
    @State private var goToCalendar = false

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

                        // Height / Weight / Age
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

                        // Top Buttons
                        HStack(spacing: 12) {
                            Button("Analytics") {
                                goToAnalytics = true
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
                                // Already on stats
                            }
                            .frame(width: 106, height: 45)
                            .background(Color.textBoxNavy)
                            .cornerRadius(15)
                        }
                        .padding(.top, 10)

                        // Graph Content
                        VStack(spacing: 20) {
                            MonthView()
                                .padding(.top, 10)

                            BarGraphView()
                                .padding(.top, 10)
                        }
                    }
                    .frame(maxWidth: .infinity) // ✅ Stretch the ScrollView content full width
                }
                .background(Color.navy)

                // Sticky Bottom NavBar
                ProfileNavBarView()
                    .padding(.bottom, 5)
            }
            .background(Color.navy)
            .ignoresSafeArea(.keyboard, edges: .bottom)
            .navigationDestination(isPresented: $goToAnalytics) {
                Progress_1_View()
            }
            .navigationDestination(isPresented: $goToCalendar) {
                Progress_2_View()
            }
        }
    }
}

struct Progress_3_View_Preview: PreviewProvider {
    static var previews: some View {
        Progress_3_View()
    }
}
