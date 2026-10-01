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
        // Pomodoro logic:
        // If completedSessions is even, we are starting a Work session (0, 2, 4...)
        // If completedSessions is odd, we are starting a Break session (1, 3, 5...)
        if completedSessions % 2 == 0 {
            return "Work"
        }
        
        // Every 4th work session (which occurs after the 4th, 8th... work session completes)
        // A work session is completed when completedSessions becomes odd (1, 3, 5, 7).
        // Specifically, the 4th work session is completed when completedSessions becomes 7.
        // Wait, let's simplify: 
        // Work (0) -> Break (1) -> Work (2) -> Break (3) -> Work (4) -> Break (5) -> Work (6) -> Long Break (7)
        // The work sessions are at indices 0, 2, 4, 6. 
        // The 4th work session finishes at index 7.
        
        let workSessionsFinished = (completedSessions + 1) / 2
        if workSessionsFinished % 4 == 0 {
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