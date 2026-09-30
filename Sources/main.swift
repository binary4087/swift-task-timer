import Foundation

let arguments = CommandLine.arguments

func parseArgument(at index: Int, defaultValue: Int) -> Int {
    guard index < arguments.count, let value = Int(arguments[index]) else { return defaultValue }
    return value * 60
}

let workMin = parseArgument(at: 1, defaultValue: 25)
let shortMin = parseArgument(at: 2, defaultValue: 5)
let longMin = parseArgument(at: 3, defaultValue: 15)

let manager = SessionManager(work: workMin * 60, short: shortMin * 60, long: longMin * 60)

print("Welcome to Swift Task Timer!")
print("Settings: Work: \(workMin)m, Short: \(shortMin)m, Long: \(longMin)m")
print("Press Ctrl+C to stop. Each session will be tracked.")

while true {
    let duration = manager.getNextIntervalDuration()
    let type = manager.getCurrentSessionType()
    
    print("\n--- Starting \(type) session: \(TimerLogic.formatTime(seconds: duration)) ---")
    
    TimerLogic.countdown(seconds: duration, onTick: { remaining in
        let timeStr = TimerLogic.formatTime(seconds: remaining)
        print("\rTime remaining: \(timeStr)", terminator: "")
        fflush(stdout)
    }, onComplete: {
        print("\n\(type) session complete!")
        manager.incrementSessions()
    })
    
    print("Total sessions completed: \(manager.completedSessions)")
    print("Preparing next session...")
    Thread.sleep(forTimeInterval: 2.0)
}