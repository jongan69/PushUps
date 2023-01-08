import SwiftUI
import HealthKit

struct StartView: View {
    @EnvironmentObject var workoutManager: WorkoutManager
    var workoutTypes: [HKWorkoutActivityType] = [.functionalStrengthTraining]

    var body: some View {
        List(workoutTypes) { workoutType in
            NavigationLink(workoutType.name, destination: SessionPagingView(),
                           tag: workoutType, selection: $workoutManager.selectedWorkout)
                .foregroundColor(SwiftUI.Color.green)
                .padding(EdgeInsets(top: 20, leading: 5, bottom: 20, trailing: 5))
        }
        .listStyle(.carousel)
        .navigationBarTitle("Workouts")
        .onAppear {
            workoutManager.requestAuthorization()
        }
    }
}

struct StartView_Previews: PreviewProvider {
    static var previews: some View {
        StartView().environmentObject(WorkoutManager())
    }
}

extension HKWorkoutActivityType: Identifiable {
    public var id: UInt {
        rawValue
    }

    var name: String {
        switch self {
        case .functionalStrengthTraining:
            return "Start PushUps"
        default:
            return ""
        }
    }
}
