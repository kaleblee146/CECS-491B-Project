import SwiftUI

//Workout Model
struct Workout: Identifiable {
    let id = UUID()
    let name: String
    let tags: [String]
    let posted: String
    let imageName: String
    let originalLikes: Int
    let originalDislikes: Int
}

//Workout ViewModel
class WorkoutViewModel: ObservableObject, Identifiable {
    let id = UUID()
    let workout: Workout
    @Published var likes: Int
    @Published var dislikes: Int
    @Published var liked = false
    @Published var disliked = false

    init(workout: Workout) {
        self.workout = workout
        self.likes = workout.originalLikes
        self.dislikes = workout.originalDislikes
    }

    func toggleLike() {
        if liked {
            likes = workout.originalLikes
            liked = false
        } else {
            likes = workout.originalLikes + 1
            liked = true
            if disliked {
                disliked = false
                dislikes = workout.originalDislikes
            }
        }
    }

    func toggleDislike() {
        if disliked {
            dislikes = workout.originalDislikes
            disliked = false
        } else {
            dislikes = workout.originalDislikes + 1
            disliked = true
            if liked {
                liked = false
                likes = workout.originalLikes
            }
        }
    }
}

//Explore View
struct ExploreView: View {
    @EnvironmentObject var session: UserSession

    @State private var searchText = ""
    @State private var page = 1
    @State private var selectedSort = "None"
    @State private var selectedWorkout = "Any"
    @State private var selectedEquipment = "Any"
    @State private var selectedTags: Set<String> = []
    
    @State private var workoutVMs: [WorkoutViewModel] = [
        WorkoutViewModel(workout: Workout(name: "Barbell Curls", tags: ["Biceps", "Forearm", "Barbell", "Workout", "Equipment"], posted: "Sep 14, 2024", imageName: "barbell_curls", originalLikes: 400, originalDislikes: 50)),
        WorkoutViewModel(workout: Workout(name: "Cable Crossover", tags: ["Chest", "Deltoids", "Triceps", "Workout", "Machine"], posted: "Sep 15, 2024", imageName: "cable_crossover", originalLikes: 500, originalDislikes: 40)),
        WorkoutViewModel(workout: Workout(name: "Dumbbell Lunges", tags: ["Glutes", "Hamstring", "Quads", "Dumbbell", "Workout", "Equipment"], posted: "Sep 16, 2024", imageName: "dumbbell_lunges", originalLikes: 200, originalDislikes: 20)),
        WorkoutViewModel(workout: Workout(name: "Plank", tags: ["Biceps", "Triceps", "Quads", "Calves", "Deltoids", "Abs", "Hamstring", "Exercise", "Non Equipment"], posted: "Sep 14, 2024", imageName: "plank", originalLikes: 400, originalDislikes: 50)),
        WorkoutViewModel(workout: Workout(name: "Squats", tags: ["Non Equipment", "Exercise", "Calves", "Glutes", "Hamstring", "Quads"], posted: "Sep 14, 2024", imageName: "squats", originalLikes: 400, originalDislikes: 50)),
        WorkoutViewModel(workout: Workout(name: "Push Ups", tags: ["Chest", "Triceps", "Shoulders", "Non Equipment", "Exercise"], posted: "Sep 17, 2024", imageName: "push_ups", originalLikes: 300, originalDislikes: 25)),
        WorkoutViewModel(workout: Workout(name: "Deadlifts", tags: ["Back", "Hamstring", "Glutes", "Barbell", "Equipment"], posted: "Sep 18, 2024", imageName: "deadlifts", originalLikes: 600, originalDislikes: 30)),
        WorkoutViewModel(workout: Workout(name: "Pull Ups", tags: ["Back", "Biceps", "Non Equipment", "Exercise"], posted: "Sep 19, 2024", imageName: "pull_ups", originalLikes: 350, originalDislikes: 40)),
        WorkoutViewModel(workout: Workout(name: "Lunges", tags: ["Glutes", "Quads", "Non Equipment", "Exercise"], posted: "Sep 20, 2024", imageName: "lunges", originalLikes: 450, originalDislikes: 35)),
        WorkoutViewModel(workout: Workout(name: "Bench Press", tags: ["Chest", "Triceps", "Shoulders", "Barbell", "Equipment"], posted: "Sep 21, 2024", imageName: "bench_press", originalLikes: 550, originalDislikes: 25))
    ]
    
    var workoutsPerPage = 5
    
    // Filtered workouts based on search and applied filters
    var filteredWorkouts: [WorkoutViewModel] {
        var filtered = workoutVMs.filter { vm in
            let workout = vm.workout
            let isMatchingTags = selectedTags.isEmpty || !selectedTags.isDisjoint(with: Set(workout.tags))
            
            return (searchText.isEmpty || workout.name.localizedCaseInsensitiveContains(searchText)) &&
            (selectedWorkout == "Any" || workout.tags.contains(selectedWorkout)) &&
            (selectedEquipment == "Any" || workout.tags.contains(selectedEquipment)) &&
            isMatchingTags
        }
        
        // Sort according to the selected sort option
        switch selectedSort {
        case "Latest Upload":
            filtered.sort { $0.workout.posted > $1.workout.posted }
        case "Oldest Upload":
            filtered.sort { $0.workout.posted < $1.workout.posted }
        case "Highest Rating":
            filtered.sort { $0.likes > $1.likes }
        case "Lowest Rating":
            filtered.sort { $0.dislikes > $1.dislikes }
        default:
            break
        }
        
        return filtered
    }
    
    // Calculate max pages
    var maxPages: Int {
        let total = filteredWorkouts.count
        return (total + workoutsPerPage - 1) / workoutsPerPage
    }
    
    // Get the workouts to be displayed for the current page
    var currentPageWorkouts: [WorkoutViewModel] {
        let startIndex = (page - 1) * workoutsPerPage
        let endIndex = min(startIndex + workoutsPerPage, filteredWorkouts.count)
        return Array(filteredWorkouts[startIndex..<endIndex])
    }
    
    var body: some View {
  

            NavigationView {
                VStack(spacing: 0) {
                    VStack(spacing: 4) {
                        HStack {
                            TextField("Search", text: $searchText)
                                .padding(10)
                                .foregroundColor(.white.opacity(0.5))
                            
                            Image(systemName: "magnifyingglass")
                                .foregroundColor(.white.opacity(0.5))
                                .padding(.trailing, 10)
                        }
                        .background(Color(hex:"353A50"))
                        .cornerRadius(10)
                        .padding(.horizontal)

                        HStack {
                            Spacer()
                            NavigationLink(destination: AdvancedSearchPage(
                                selectedSort: $selectedSort,
                                selectedWorkout: $selectedWorkout,
                                selectedEquipment: $selectedEquipment,
                                selectedTags: $selectedTags)) {
                                Text("Advanced Search")
                                    .font(.footnote)
                                    .foregroundColor(.blue)
                                    .padding(.horizontal)
                                    .padding(.bottom)
                            }
                        }
                    }

                    List {
                        ForEach(currentPageWorkouts) { vm in
                            NavigationLink(destination: Text("Workout Detail View for \(vm.workout.name)")) {
                                WorkoutCardView(viewModel: vm)
                            }
                            .listRowBackground(Color(hex:"#353A50"))
                        }
                    }
                    .scrollContentBackground(.hidden) // Hides default list background
                    .background(Color(hex: "353A50"))

                    HStack {
                        Button(action: {
                            if page > 1 { page -= 1 }
                        }) {
                            HStack {
                                Image(systemName: "chevron.left")
                                Text("Back")
                            }
                            .padding()
                            .background(Color.pink)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                        }
                        .disabled(page == 1)

                        Spacer()

                        Text("\(page) / \(maxPages)")
                            .padding(.horizontal)
                            .foregroundColor(.white)

                        Spacer()

                        Button(action: {
                            if page < maxPages { page += 1 }
                        }) {
                            HStack {
                                Text("Next")
                                Image(systemName: "chevron.right")
                            }
                            .padding()
                            .background(Color.pink)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                        }
                        .disabled(page == maxPages)
                    
                    }
                    .padding()
                    ExploreNavBarView()
                }
                .navigationBarHidden(true)
                .background(Color(hex:"2A2E43"))
            }
        }
    }


//Workout Card View
struct WorkoutCardView: View {
    @ObservedObject var viewModel: WorkoutViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Image(viewModel.workout.imageName)
                .resizable()
                .scaledToFit()
                .cornerRadius(10)

            Text(viewModel.workout.name)
                .font(.headline)

            Text("Posted: \(viewModel.workout.posted)")
                .font(.caption)
                .foregroundColor(.gray)

            WrapHStack(tags: viewModel.workout.tags)

            HStack(spacing: 16) {
                Button(action: {
                    viewModel.toggleLike()
                }) {
                    HStack(spacing: 4) {
                        Image(systemName: "hand.thumbsup.fill")
                        Text("\(viewModel.likes)") // Display the updated like count
                    }
                    .padding(6)
                    .background(viewModel.liked ? Color.blue.opacity(0.2) : Color.gray.opacity(0.1))
                    .foregroundColor(viewModel.liked ? .blue : .gray)
                    .cornerRadius(8)
                }
                .buttonStyle(PlainButtonStyle())

                Button(action: {
                    viewModel.toggleDislike()
                }) {
                    HStack(spacing: 4) {
                        Image(systemName: "hand.thumbsdown.fill")
                        Text("\(viewModel.dislikes)") // Display the updated dislike count
                    }
                    .padding(6)
                    .background(viewModel.disliked ? Color.red.opacity(0.2) : Color.gray.opacity(0.1))
                    .foregroundColor(viewModel.disliked ? .red : .gray)
                    .cornerRadius(8)
                }
                .buttonStyle(PlainButtonStyle())
            }
            .font(.caption)
        }
        .padding()
        .background(Color(.secondarySystemBackground))
        .cornerRadius(10)
        
    }
}
//Advanced Search Page
struct AdvancedSearchPage: View {
    @Binding var selectedSort: String
    @Binding var selectedWorkout: String
    @Binding var selectedEquipment: String
    @Binding var selectedTags: Set<String>
    @Environment(\.presentationMode) var presentationMode

    let sortOptions = ["None", "Latest Upload", "Oldest Upload", "Highest Rating", "Lowest Rating"]
    let workoutOptions = ["Any", "Workout", "Exercise"]
    let equipmentOptions = ["Any", "Barbell", "Dumbbell", "Machine", "Non Equipment"]
    let tagOptions = ["Biceps", "Triceps", "Quads", "Calves", "Deltoids", "Glutes", "Hamstring", "Abs"]

    @State private var showingTagTray = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Group {
                    Text("Sort by")
                    Button(action: {}) {
                        Picker("Sort by", selection: $selectedSort) {
                            ForEach(sortOptions, id: \.self) {
                                Text($0)
                            }
                        }
                        .pickerStyle(MenuPickerStyle())
                        .padding(.horizontal, 20)
                        .frame(height: 45)
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(8)
                    }

                    Text("Workout/Exercise")
                    Button(action: {}) {
                        Picker("Workout", selection: $selectedWorkout) {
                            ForEach(workoutOptions, id: \.self) {
                                Text($0)
                            }
                        }
                        .pickerStyle(MenuPickerStyle())
                        .padding(.horizontal, 20)
                        .frame(height: 45)
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(8)
                    }

                    Text("Equipment")
                    Button(action: {}) {
                        Picker("Equipment", selection: $selectedEquipment) {
                            ForEach(equipmentOptions, id: \.self) {
                                Text($0)
                            }
                        }
                        .pickerStyle(MenuPickerStyle())
                        .padding(.horizontal, 20)
                        .frame(height: 45)
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(8)
                    }

                    Text("Tags")
                    Button("Select Tags") {
                        showingTagTray.toggle()
                    }
                    .padding()
                    .background(Color.gray)
                    .foregroundColor(.white)
                    .cornerRadius(10)

                    if showingTagTray {
                        // LazyVGrid for wrapping tags into rows
                        LazyVGrid(columns: [GridItem(.adaptive(minimum: 100))], spacing: 10) {
                            ForEach(tagOptions, id: \.self) { tag in
                                Button(action: {
                                    if selectedTags.contains(tag) {
                                        selectedTags.remove(tag)
                                    } else {
                                        selectedTags.insert(tag)
                                    }
                                }) {
                                    Text(tag)
                                        .font(.footnote)
                                        .padding(10)
                                        .background(selectedTags.contains(tag) ? Color.pink : Color.gray.opacity(0.2))
                                        .cornerRadius(10)
                                }
                            }
                        }
                        .padding(.top, 10)
                    }
                }

                HStack {
                    Button("Reset") {
                        selectedSort = "None"
                        selectedWorkout = "Any"
                        selectedEquipment = "Any"
                        selectedTags = []
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.pink)
                    .cornerRadius(10)
                    .foregroundColor(.white)

                    Button("Confirm") {
                        // Apply filters and return to ExploreView
                        presentationMode.wrappedValue.dismiss()
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.pink)
                    .cornerRadius(10)
                    .foregroundColor(.white)
                }
            }
            .padding()
        }
        .foregroundColor(.white)
        .navigationBarTitleDisplayMode(.inline)
        .background(Color(hex: "#2A2E43"))
    }
}

//Wrap Tags Horizontally
struct WrapHStack: View {
    let tags: [String]
    var body: some View {
        VStack(alignment: .leading) {
            ForEach(tags.chunked(into: 4), id: \.self) { row in
                HStack {
                    ForEach(row, id: \.self) { tag in
                        Text(tag)
                            .font(.caption2)
                            .padding(4)
                            .background(Color.gray.opacity(0.2))
                            .cornerRadius(5)
                    }
                }
            }
        }
    }
}

//Array Chunking Helper
extension Array {
    func chunked(into size: Int) -> [[Element]] {
        stride(from: 0, to: count, by: size).map {
            Array(self[$0..<Swift.min($0 + size, count)])
        }
    }
}




//Preview
struct ExploreView_Previews: PreviewProvider {
    static var previews: some View {
        ExploreView()
    }
}
