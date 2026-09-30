# Swift Task Timer

A simple Pomodoro-based CLI timer written in Swift.

## Features
- Work sessions (default 25m)
- Short breaks (default 5m)
- Long breaks (default 15m every 4 sessions)
- Real-time countdown in the terminal
- Customizable intervals via CLI arguments

## How to Run
1. Ensure you have Swift installed.
2. Navigate to the project directory.
3. Compile and run:
   ```bash
   swiftc Sources/*.swift -o tasktimer
   ./tasktimer [work_mins] [short_break_mins] [long_break_mins]
   ```

Example for a 50/10/20 split:
```bash
./tasktimer 50 10 20
```