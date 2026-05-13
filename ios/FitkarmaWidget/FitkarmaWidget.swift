import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), steps: 7432, stepGoal: 10000, karmaXp: 2450, isPro: true)
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> Void) {
        let entry = SimpleEntry(date: Date(), steps: 7432, stepGoal: 10000, karmaXp: 2450, isPro: true)
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> Void) {
        // Retrieve live parameters from shared AppGroup storage populated by Flutter home_widget plugin
        let userDefaults = UserDefaults(suiteName: "group.in.fitkarma.app") ?? UserDefaults.standard
        
        let steps = userDefaults.integer(forKey: "steps")
        let stepGoal = userDefaults.integer(forKey: "step_goal")
        let karmaXp = userDefaults.integer(forKey: "karma_xp")
        let isPro = userDefaults.bool(forKey: "is_pro")
        
        // Define fallback baseline numbers if uninitialized
        let finalSteps = steps > 0 ? steps : 7432
        let finalGoal = stepGoal > 0 ? stepGoal : 10000
        let finalKarma = karmaXp > 0 ? karmaXp : 2450

        let entry = SimpleEntry(date: Date(), steps: finalSteps, stepGoal: finalGoal, karmaXp: finalKarma, isPro: isPro)

        // Request widget timeline refresh cycle every 15 minutes to guarantee data fidelity
        let nextUpdate = Calendar.current.date(byAdding: .minute, value: 15, to: Date())!
        let timeline = Timeline(entries: [entry], policy: .after(nextUpdate))
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let steps: Int
    let stepGoal: Int
    let karmaXp: Int
    let isPro: Bool
}

struct FitkarmaWidgetEntryView : View {
    var entry: Provider.Entry

    var progress: Double {
        min(Double(entry.steps) / Double(entry.stepGoal), 1.0)
    }

    var body: some View {
        ZStack {
            // Premium background layer gradient matching AppColorsDark aesthetic
            LinearGradient(
                gradient: Gradient(colors: [Color(red: 0.05, green: 0.06, blue: 0.08), Color(red: 0.08, green: 0.09, blue: 0.12)]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            
            VStack(alignment: .leading, spacing: 8) {
                // Top Header Row
                HStack {
                    Image(systemName: "flame.fill")
                        .foregroundColor(Color(red: 1.0, green: 0.45, blue: 0.15))
                    Text(entry.isPro ? "FitKarma Pro ⚡" : "FitKarma")
                        .font(.caption)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    Spacer()
                    Text("\(entry.karmaXp) XP")
                        .font(.caption2)
                        .fontWeight(.heavy)
                        .foregroundColor(Color(red: 0.76, green: 0.88, blue: 0.16))
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(Color(red: 0.76, green: 0.88, blue: 0.16).opacity(0.15))
                        .cornerRadius(4)
                }
                
                Spacer()

                // Circular visual indicator + main text metrics
                HStack(spacing: 12) {
                    // Custom Activity Ring
                    ZStack {
                        Circle()
                            .stroke(Color.white.opacity(0.1), lineWidth: 6)
                        Circle()
                            .trim(from: 0.0, to: CGFloat(progress))
                            .stroke(
                                LinearGradient(
                                    gradient: Gradient(colors: [Color(red: 0.13, green: 0.87, blue: 0.72), Color(red: 0.76, green: 0.88, blue: 0.16)]),
                                    startPoint: .top,
                                    endPoint: .bottom
                                ),
                                style: StrokeStyle(lineWidth: 6, lineCap: .round)
                            )
                            .rotationEffect(.degrees(-90))
                        
                        Image(systemName: "figure.walk")
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(.white)
                    }
                    .frame(width: 44, height: 44)
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text("\(entry.steps)")
                            .font(.system(size: 20, weight: .black, design: .rounded))
                            .foregroundColor(.white)
                        Text("Goal: \(entry.stepGoal)")
                            .font(.system(size: 10, weight: .semibold))
                            .foregroundColor(.gray)
                    }
                }
            }
            .padding(12)
        }
    }
}

@main
struct FitkarmaWidget: Widget {
    let kind: String = "FitkarmaWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            FitkarmaWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("FitKarma Live Metrics")
        .description("Track daily step goals and Karma XP accumulation at a glance.")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}
