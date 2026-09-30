import Foundation

class SessionManager {
    var completedSessions = 0
    let workDuration: Int
    let shortBreakDuration: Int
    let longBreakDuration: Int

    init(work: Int = 25 * 60, short: Int = 5 * 60, long: Int = 15 * 60) {
        self.workDuration = work
        self.shortBreakDuration = short
        self.longBreakDuration = long
    }

    func incrementSessions() {
        completedSessions += 1
    }

    func getCurrentSessionType() -> String {
        if completedSessions % 2 == 0 {
            return "Work"
        }
        
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