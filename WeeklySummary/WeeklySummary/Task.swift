import Foundation

private class BaseTasks {
    var tasks: Set<String> = Set<String>()
    
    init() {
        self.parseBaseTasks()
    }
    
    func parseBaseTasks() {
        // TODO (#1) read from a file called tasks.js
    }
    
    func getTasks() -> Set<String> {
        return Set<String>(tasks)
    }
    
}

class Task: Equatable, Hashable {
    var title: String = String()
    private var timeSpent: Double = Double()
    private var frequency: String = String()
    fileprivate static var baseTasks: BaseTasks? = nil
    
    init(title: String, timeSpent: Double) {
        self.title = title
        self.timeSpent = timeSpent
        self.frequency = "-------"
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
        let hour = Int(timeSpent)
        let min = Int((timeSpent - Double(hour))*60.0)
        if hour == 0 {return String(format: "%d mins",min)}
        if min == 0 { return String(format:"%d:00 hours",hour)}
        return String(format: "%d:%d hours",hour,min)
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
        return ""
    }
    
    static func getBaseTasks() -> Set<String> {
        return (self.baseTasks?.getTasks())!
    }
    
    static func genBaseTasks() {
        if baseTasks == nil {
            baseTasks = BaseTasks()
        }
    }
}

func ==(lhs: Task, rhs: Task) -> Bool {
    return lhs.title.lowercased() == rhs.title.lowercased()
}
