import Foundation

class SessionManager {
    var completedSessions = 0
    let workDuration: Int
    let shortBreakDuration: Int
    let longBreakDuration: Int
    private let historyFile = "session_history.txt"

    init(work: Int = 25 * 60, short: Int = 5 * 60, long: Int = 15 * 60) {
        self.workDuration = work
        self.shortBreakDuration = short
        self.longBreakDuration = long
        loadHistory()
    }

    func incrementSessions() {
        completedSessions += 1
        saveHistory()
    }

    func resetSessions() {
        completedSessions = 0
        saveHistory()
    }

    func getCurrentSessionType() -> String {
        // Sessions follow a pattern: Work, Break, Work, Break... 
        // Every 4th work session is followed by a Long Break.
        if completedSessions % 2 == 0 {
            return "Work"
        }
        
        // Check if the work session just completed was a multiple of 4
        if (completedSessions + 1) % 8 == 0 {
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

    private func saveHistory() {
        let data = "\(completedSessions)"
        do {
            try data.write(toFile: historyFile, atomically: true, encoding: .utf8)
        } catch {
            print("\nError saving session history: \(error)")
        }
    }

    private func loadHistory() {
        do {
            let savedData = try String(contentsOfFile: historyFile, encoding: .utf8)
            if let count = Int(savedData.trimmingCharacters(in: .whitespacesAndNewlines)) {
                self.completedSessions = count
            }
        } catch {
            // File might not exist yet, which is fine
            self.completedSessions = 0
        }
    }
}