import Foundation

let manager = SessionManager()
print("Welcome to Swift Task Timer!")
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