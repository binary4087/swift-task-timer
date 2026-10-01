import Foundation

let arguments = CommandLine.arguments

func parseArgument(at index: Int, defaultValue: Int) -> Int {
    guard index < arguments.count, let value = Int(arguments[index]) else { return defaultValue }
    return value * 60
}

let workMin = parseArgument(at: 1, defaultValue: 25)
let shortMin = parseArgument(at: 2, defaultValue: 5)
let longMin = parseArgument(at: 3, defaultValue: 15)

let manager = SessionManager(work: workMin, short: shortMin, long: longMin)

print("Welcome to Swift Task Timer!")
print("Settings: Work: \(workMin/60)m, Short: \(shortMin/60)m, Long: \(longMin/60)m")
print("Press Ctrl+C to stop. Each session will be tracked.")

while true {
    let duration = manager.getNextIntervalDuration()
    let type = manager.getCurrentSessionType()
    
    print("\n--- Starting \(type) session: \(TimerLogic.formatTime(seconds: duration)) ---")
    
    TimerLogic.countdown(seconds: duration, onTick: { remaining, progress in
        let timeStr = TimerLogic.formatTime(seconds: remaining)
        let bar = TimerLogic.generateProgressBar(progress: progress)
        print("\r\(bar) Time remaining: \(timeStr)", terminator: "")
        fflush(stdout)
    }, onComplete: {
        print("\n\(type) session complete!")
        // Print ASCII Bell character to trigger system alert sound
        print("\u{0007}", terminator: "")
        fflush(stdout)
        manager.incrementSessions()
    })
    
    print("Total sessions completed: \(manager.completedSessions)")
    print("Preparing next session...")
    Thread.sleep(forTimeInterval: 2.0)
}