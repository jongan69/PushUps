/*

Abstract:

 ComplicationController for Complication UI
*/

import Foundation
import SwiftUI
import ClockKit
import HealthKit

class ComplicationController: NSObject, CLKComplicationDataSource {
    
    
    struct Complication {
        let idetifier: String
        let displayName: String
        
        static let timer = Complication(idetifier: "Timer", displayName: "Workout Timer")
    }
    
    // MARK: - Complication Configuration
    lazy var data = WorkoutManager.shared


    func getComplicationDescriptors(handler: @escaping ([CLKComplicationDescriptor]) -> Void) {
        let timer = [
            CLKComplicationDescriptor(identifier: "complication", displayName: "PushUps", supportedFamilies: CLKComplicationFamily.allCases)
            // Multiple complication support can be added here with more descriptors
        ]
        print("getComplicationDescriptors")
        // Call the handler with the currently supported complication descriptors
        handler(timer)
    }
    
    
    func handleSharedComplicationDescriptors(_ complicationDescriptors: [CLKComplicationDescriptor]) {
        // Do any necessary work to support these newly shared complication descriptors
        print("handleSharedComplicationDescriptors")
    }

    // MARK: - Timeline Configuration
    
    func getTimelineEndDate(for complication: CLKComplication, withHandler handler: @escaping (Date?) -> Void) {
        // Call the handler with the last entry date you can currently provide or nil if you can't support future timelines
        print("getTimelineEndDate")
        handler(Date().addingTimeInterval(24.0 * 60.0 * 60.0))
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
        handler(createTimelineEntry(forComplication: complication, date: Date()))
    }
    
    // Return a timeline entry for the specified complication and date.
    private func createTimelineEntry(forComplication complication: CLKComplication, date: Date) -> CLKComplicationTimelineEntry {
        
        // Get the correct template based on the complication.
        let template = createTemplate(forComplication: complication, date: date)
    
        // Use the template and date to create a timeline entry.
        return CLKComplicationTimelineEntry(date: date, complicationTemplate: template)
    }
    
    // Select the correct template based on the complication's family.
    private func createTemplate(forComplication complication: CLKComplication, date: Date) -> CLKComplicationTemplate {
        
        switch (complication.family, complication.identifier) {
        
//        case (_, _):
//            return createTimerCornerTemplate(forDate: date)
        case (_, Complication.timer.idetifier):
            return createTimerCornerTemplate(forDate: date)
        case (_, _):
            return createTimerCornerTemplate(forDate: date)
        @unknown default:
            fatalError("*** Unknown Family and identifier pair: (\(complication.family), \(complication.identifier)) ***")
        }
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
        let future = Date().addingTimeInterval(25.0 * 60.0 * 60.0)
        let template = createTemplate(forComplication: complication, date: future)
        handler(template)
    }
    
    private func createTimerCornerTemplate(forDate date: Date) -> CLKComplicationTemplate {
            // Create the data providers.
            let leadingValueProvider = CLKSimpleTextProvider(text: "0")
//            leadingValueProvider.tintColor = data.color(forTotalLiquids: 0.0)
            
            let trailingValueProvider = CLKSimpleTextProvider(text: "80")
//            trailingValueProvider.tintColor = data.color(forTotalLiquids: 80.0)
            
        let numberOfOuncesProvider = CLKSimpleTextProvider(text: "\(data.builder!.elapsedTime)")
            let ouncesUnitProvider = CLKSimpleTextProvider(text: "Ounces", shortText: "oz")
            let combinedOuncesProvider = CLKTextProvider(format: "%@ %@", numberOfOuncesProvider, ouncesUnitProvider)
            
            let percentage = Float(min(1 / 300.0, 1.0))
            let gaugeProvider = CLKSimpleGaugeProvider(style: .fill,
                                                       gaugeColors: [.red, .yellow, .green],
                                                       gaugeColorLocations: [0.0, 20.0 / 2.0, 50.0 / 80.0] as [NSNumber],
                                                       fillFraction: percentage)
            
            // Create the template using the providers.
            return CLKComplicationTemplateGraphicCornerGaugeText(gaugeProvider: gaugeProvider,
                                                                 leadingTextProvider: leadingValueProvider,
                                                                 trailingTextProvider: trailingValueProvider,
                                                                 outerTextProvider: combinedOuncesProvider)
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
}
