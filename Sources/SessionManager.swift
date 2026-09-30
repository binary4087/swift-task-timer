import Foundation

class SessionManager {
    var completedSessions = 0
    let workDuration = 25 * 60
    let shortBreakDuration = 5 * 60
    let longBreakDuration = 15 * 60

    func incrementSessions() {
        completedSessions += 1
    }

    func getNextIntervalDuration() -> Int {
        if completedSessions > 0 && completedSessions % 4 == 0 {
            return longBreakDuration
        } else if completedSessions % 2 == 0 {
            return workDuration
        } else {
            return shortBreakDuration
        }
    }

    func getCurrentSessionType() -> String {
        if completedSessions == 0 || completedSessions % 2 == 0 {
            return "Work"
        } else if completedSessions % 4 == 0 {
            return "Long Break"
        } else {
            return "Short Break"
        }
    }
}