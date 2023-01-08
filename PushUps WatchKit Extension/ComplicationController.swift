/*

Abstract:

 ComplicationController for Complication UI
*/

import Foundation
import SwiftUI
import ClockKit
import HealthKit

class ComplicationController: NSObject, CLKComplicationDataSource {
    // MARK: - Complication Configuration

    func getComplicationDescriptors(handler: @escaping ([CLKComplicationDescriptor]) -> Void) {
        let descriptors = [
            CLKComplicationDescriptor(identifier: "complication", displayName: "PushUps", supportedFamilies: CLKComplicationFamily.allCases)
            // Multiple complication support can be added here with more descriptors
        ]
        
        print("getComplicationDescriptors")
        
        // Call the handler with the currently supported complication descriptors
        handler(descriptors)
    }
    
    func handleSharedComplicationDescriptors(_ complicationDescriptors: [CLKComplicationDescriptor]) {
        // Do any necessary work to support these newly shared complication descriptors
        print("handleSharedComplicationDescriptors")
    }

    // MARK: - Timeline Configuration
    
    func getTimelineEndDate(for complication: CLKComplication, withHandler handler: @escaping (Date?) -> Void) {
        // Call the handler with the last entry date you can currently provide or nil if you can't support future timelines
        print("getTimelineEndDate")
        handler(nil)
    }
    
    func getPrivacyBehavior(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationPrivacyBehavior) -> Void) {
        // Call the handler with your desired behavior when the device is locked
        print("getPrivacyBehavior")

        handler(.showOnLockScreen)
    }

    // MARK: - Timeline Population
    
    func getCurrentTimelineEntry(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationTimelineEntry?) -> Void) {
        // Call the handler with the current timeline entry
        print("getCurrentTimelineEntry")
        handler(nil)
    }
    
    func getTimelineEntries(for complication: CLKComplication, after date: Date, limit: Int,
                            withHandler handler: @escaping ([CLKComplicationTimelineEntry]?) -> Void) {
        // Call the handler with the timeline entries after the given date
        print("getTimelineEntries")
        handler(nil)
    }

    // MARK: - Sample Templates
    
    func getLocalizableSampleTemplate(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationTemplate?) -> Void) {
        // This method will be called once per supported complication, and the results will be cached
        print("getLocalizableSampleTemplate")
        handler(nil)
    }
    
}



// Should be in own view file
struct ComplicationView: View {
    @Environment(\.complicationRenderingMode) var renderingMode
    @EnvironmentObject var workoutManager: WorkoutManager
    
    func bpmDisaply (session: HKWorkoutSession?) -> String {
        if #available(watchOS 9.0, *) {
            if ((session?.state) != nil) {
                return "Stop"
                //            return workoutManager.heartRate.formatted(.number.precision(.fractionLength(0))) + " bpm"
            } else {
                return "Start"
            }
        } else {
            // Fallback on earlier versions
            return "Error"
        }
    }
    
    var body: some View {
        ZStack {
            
            if renderingMode == .fullColor {
                Circle()
                    .fill(Color.purple)
            } else {
                Circle()
                    .fill(LinearGradient(
                        gradient: Gradient(
                            colors: [Color.white.opacity(0.3),
                                     Color.white.opacity(1.0)]),
                        startPoint: .top,
                        endPoint: .bottom))
            }
            
            
            Gauge(value: 76.0, in: 60.0...85.0) {
                Text("")
            } currentValueLabel: {
                Text("2")
            } minimumValueLabel: {
                Text("60")
            } maximumValueLabel: {
                Text("85")
            }
            .gaugeStyle(
                CircularGaugeStyle(
                    tint:   Gradient(colors: [.green, .yellow, .orange, .red])
                )
            )
            
        }
    }
    
    struct CompilcationController_Preview: PreviewProvider {
        static var previews: some View {
            Group {
                CLKComplicationTemplateGraphicCornerCircularView(ComplicationView()).previewContext()
        }
    }
}
