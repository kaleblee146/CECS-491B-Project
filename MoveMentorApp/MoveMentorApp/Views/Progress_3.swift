import SwiftUI

struct Progress_3_View: View {
    @EnvironmentObject var session: UserSession

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

                        Text("\(session.firstName) \(session.lastName)")
                            .foregroundColor(.white)

                        Text("Member since \(session.joinedYear)")      .foregroundColor(.white)


                        // Height / Weight / Age
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
                    .frame(maxWidth: .infinity)
                }
                .background(Color.navy)

                
                ProfileNavBarView()
                    .padding(.bottom, 5)
            }
            .background(Color.navy)
            .ignoresSafeArea(.keyboard, edges: .bottom)
            .navigationDestination(isPresented: $goToAnalytics) {
                Progress_1_View()
                    .environmentObject(session)
            }
            .navigationDestination(isPresented: $goToCalendar) {
                Progress_2_View()
                    .environmentObject(session)
            }
        }
    }
}

struct Progress_3_View_Preview: PreviewProvider {
    static var previews: some View {
        Progress_3_View()
    }
}
