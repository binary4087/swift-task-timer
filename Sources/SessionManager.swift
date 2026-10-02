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
        // Sequence: Work -> Break -> Work -> Break -> Work -> Break -> Work -> Long Break
        // Work sessions are indices 0, 2, 4, 6 (even)
        // Break sessions are indices 1, 3, 5, 7 (odd)
        if completedSessions % 2 == 0 {
            return "Work"
        }
        
        // A Long Break occurs after every 4th work session.
        // Work sessions are completed at indices 1, 3, 5, 7.
        // The 4th work session is completed when completedSessions reaches 7 (odd).
        // Wait, actually if completedSessions is odd, we are in a break.
        // If we just finished the 4th work session (index 6), completedSessions is now 7.
        // Every 8 total sessions (4 work + 4 break), we cycle. 
        // Index 7 is the 4th break. Let's make the 4th break the Long Break.
        if (completedSessions + 1) % 8 == 0 {
            return "Long Break"
        } else {
            return "Short Break"
        }
    }

    func getDuration(for type: String) -> Int {
        switch type {
        case "Work":
            return workDuration
        case "Long Break":
            return longBreakDuration
        default:
            return shortBreakDuration
        }
    }

    func getNextIntervalDuration() -> Int {
        return getDuration(for: getCurrentSessionType())
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
            self.completedSessions = 0
        }
    }
}