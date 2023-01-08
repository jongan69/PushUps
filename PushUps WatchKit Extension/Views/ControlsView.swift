import SwiftUI

struct ControlsView: View {
    @EnvironmentObject var workoutManager: WorkoutManager

    var body: some View {
        
        VStack {
            Text(Measurement(value: workoutManager.activeEnergy, unit: UnitEnergy.kilocalories)
                .formatted(.measurement(width: .abbreviated, usage: .workout, numberFormatStyle: .number.precision(.fractionLength(0)))))
            HStack {
                
                VStack {
                    Button {
                        workoutManager.endWorkout()
                    } label: {
                        Image(systemName: "xmark")
                    }
                    .tint(.red)
                    .font(.title2)
                    Text("End")
                }
                VStack {
                    Button {
                        workoutManager.togglePause()
                    } label: {
                        Image(systemName: workoutManager.running ? "pause" : "play")
                    }
                    .tint(.yellow)
                    .font(.title2)
                    Text(workoutManager.running ? "Pause" : "Resume")
                }
            }
        }
        
    }
}

struct ControlsView_Previews: PreviewProvider {
    static var previews: some View {
        ControlsView().environmentObject(WorkoutManager())
    }
}
