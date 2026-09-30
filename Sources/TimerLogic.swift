import Foundation

struct TimerLogic {
    static func countdown(seconds: Int, onTick: (Int) -> Void, onComplete: () -> Void) {
        var remaining = seconds
        while remaining > 0 {
            onTick(remaining)
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
}