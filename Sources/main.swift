import Foundation

let arguments = CommandLine.arguments

func parseArgument(at index: Int, defaultValue: Int) -> Int {
    guard index < arguments.count, let value = Int(arguments[index]) else { return defaultValue }
    return value * 60
}

if arguments.contains("--reset") {
    let manager = SessionManager()
    manager.resetSessions()
    print("Session history has been reset.")
    exit(0)
}

let workMin = parseArgument(at: 1, defaultValue: 25)
let shortMin = parseArgument(at: 2, defaultValue: 5)
let longMin = parseArgument(at: 3, defaultValue: 15)

let manager = SessionManager(work: workMin, short: shortMin, long: longMin)

print("Welcome to Swift Task Timer!")
print("Settings: Work: \(workMin/60)m, Short: \(shortMin/60)m, Long: \(longMin/60)m")
print("Use --reset to clear history, --work to force work, or --break to force break. Press Ctrl+C to stop.")

while true {
    var duration: Int
    var type: String

    if arguments.contains("--work") {
        type = "Work"
        duration = manager.getDuration(for: type)
    } else if arguments.contains("--break") {
        type = manager.getCurrentSessionType() == "Work" ? "Short Break" : manager.getCurrentSessionType()
        // If current is work, force a short break. If already break, keep that type.
        if type == "Work" { type = "Short Break" }
        duration = manager.getDuration(for: type)
    } else {
        type = manager.getCurrentSessionType()
        duration = manager.getNextIntervalDuration()
    }
    
    print("\n--- Starting \(type) session: \(TimerLogic.formatTime(seconds: duration)) ---")
    
    TimerLogic.countdown(seconds: duration, onTick: { remaining, progress in
        let timeStr = TimerLogic.formatTime(seconds: remaining)
        let bar = TimerLogic.generateProgressBar(progress: progress)
        print("\r\(bar) Time remaining: \(timeStr)", terminator: "")
        fflush(stdout)
    }, onComplete: {
        print("\n\(type) session complete!")
        print("\u{0007}", terminator: "")
        fflush(stdout)
        manager.incrementSessions()
    })
    
    print("Total sessions completed: \(manager.completedSessions)")
    print("Preparing next session...")
    Thread.sleep(forTimeInterval: 2.0)
}