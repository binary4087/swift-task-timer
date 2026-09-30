import Foundation

class SessionManager {
    var completedSessions = 0
    let workDuration = 25 * 60
    let shortBreakDuration = 5 * 60
    let longBreakDuration = 15 * 60

    func incrementSessions() {
        completedSessions += 1
    }

    func getCurrentSessionType() -> String {
        // Logic: 
        // 0 completed -> Work
        // 1 completed -> Short Break
        // 2 completed -> Work
        // 3 completed -> Short Break
        // 4 completed -> Work
        // 5 completed -> Short Break
        // 6 completed -> Work
        // 7 completed -> Short Break
        // 8 completed -> Long Break (After 4 work sessions)
        
        // Every session that starts when completedSessions is even is a Work session
        if completedSessions % 2 == 0 {
            return "Work"
        } 
        
        // If completedSessions is odd, it's a break. 
        // A long break occurs after every 4th work session.
        let breakNumber = (completedSessions + 1) / 2
        if breakNumber % 4 == 0 {
            return "Long Break"
        } else {
            return "Short Break"
        }
    }

    func getNextIntervalDuration() -> Int {
        let type = getCurrentSessionType()
        switch type {
        case "Work":
            return workDuration
        case "Long Break":
            return longBreakDuration
        default:
            return shortBreakDuration
        }
    }
}