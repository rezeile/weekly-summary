import Foundation

class Task: Equatable, Hashable {
    var title: String = String()
    private var timeSpent: Double = Double()
    private var frequency: String = String()
    private var baseTask: Bool
    
    init(title: String, timeSpent: Double) {
        self.title = title
        self.timeSpent = timeSpent
        self.frequency = "-------"
        self.baseTask = false
    }
    
    var hashValue: Int {
        get {
            return title.hashValue
        }
    }
    
    func addTimeSpent(timeSpent: Double) {
        self.timeSpent += timeSpent
    }
    
    func getTimeSpent() -> String {
        return Formatter.getFormattedTime(time: self.timeSpent)
    }
    
    func getTimeSpentRaw() -> Double {
        return self.timeSpent
    }
    
    func updateFrequency(date: Date) {
        let day: (Int,String) = DateUtil.getDayOfWeek(date: date)
        let start = self.frequency.index(self.frequency.startIndex, offsetBy: (day.0-1))
        let end = self.frequency.index(self.frequency.startIndex, offsetBy: (day.0))
        self.frequency.replaceSubrange(start..<end, with: day.1)
    }
    
    func getFrequency() -> String {
        let _freq: String = String(self.frequency)
        return "[" + _freq + "]"
    }
    
    func getAverage() -> String {
        var count = 0
        for c in self.frequency.characters {
            if c != "-" { count += 1 }
        }
        let den = count == 0 ? 1.0 : Double(count)
        let average: Double =  self.getTimeSpentRaw() / den
        return Formatter.getFormattedTime(time: average) + "/day"
    }
    
    func setAsBaseTask() {
        self.baseTask = true
    }
    
    func isBaseTask() -> Bool {
        return self.baseTask
    }
}

func ==(lhs: Task, rhs: Task) -> Bool {
    return lhs.title.lowercased() == rhs.title.lowercased()
}
