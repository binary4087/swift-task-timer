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
        // Pomodoro pattern: Work, Break, Work, Break, Work, Break, Work, Long Break
        // completedSessions represents how many intervals have finished.
        // Sequence: 0:Work, 1:Short, 2:Work, 3:Short, 4:Work, 5:Short, 6:Work, 7:Long
        
        if completedSessions % 2 == 0 {
            return "Work"
        }
        
        // It's a break. Check if it's the 4th work session's break.
        // The 4th work session ends at index 7 (0,1,2,3,4,5,6,7)
        // The breaks happen at indices 1, 3, 5, 7
        let breakIndex = completedSessions
        if (breakIndex + 1) % 8 == 0 {
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