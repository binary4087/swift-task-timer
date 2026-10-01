import Foundation

struct TimerLogic {
    static func countdown(seconds: Int, onTick: (Int, Double) -> Void, onComplete: () -> Void) {
        var remaining = seconds
        let total = seconds
        while remaining > 0 {
            let progress = Double(total - remaining) / Double(total)
            onTick(remaining, progress)
            Thread.sleep(forTimeInterval: 1.0)
            remaining -= 1
        }
        onComplete()
    }

    static func formatTime(seconds: Int) -> String {
        let mins = seconds / 60
        let secs = seconds % 60
        return String(format: "%02d:%02d", mins, secs)
    }

    static func generateProgressBar(progress: Double, width: Int = 20) -> String {
        let filledLength = Int(round(progress * Double(width)))
        let emptyLength = width - filledLength
        let filledBar = String(repeating: "█", count: filledLength)
        let emptyBar = String(repeating: "░", count: emptyLength)
        return "[\(filledBar)\(emptyBar)]"
    }
}