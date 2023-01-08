/*
See LICENSE folder for this sample’s licensing information.

Abstract:
The entry point into the app.
*/

import SwiftUI

@main
struct PushUps: App {
    @StateObject private var workoutManager = WorkoutManager()

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
