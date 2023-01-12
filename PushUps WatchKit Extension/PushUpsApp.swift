/*
Abstract:
The entry point into the app.
*/

import SwiftUI

@main
struct PushUps: App {
    @StateObject public var workoutManager = WorkoutManager()
    
    let data = WorkoutManager.shared

    @SceneBuilder var body: some Scene {
        WindowGroup {
            NavigationView {
                StartView()
            }
            .sheet(isPresented: $workoutManager.showingSummaryView) {
                SummaryView()
            }
            .environmentObject(workoutManager)
        }
    }
}
