import Foundation

class Formatter {
    private static let dashes = String(repeating: "-",count: 71) + "\n"
    
    static func genContentHeading() -> String {
        let task = "  Task".padding(toLength: 27, withPad: " ", startingAt: 0) + "|"
        let timeSpent = " Time Spent ".padding(toLength: 13, withPad: " ", startingAt: 0) + "|"
        let frequency = " Frequency ".padding(toLength: 11, withPad: " ", startingAt: 0) + "|"
        let heading = task + timeSpent + frequency + " Average\n"
        return "<b>" + dashes + heading + dashes + "</b>"
    }
    
    
    static func writeContentToFile(config: Config, tasks: Set<Task>, date: Date) {
        var messageBody = genContentHeading()
        let tasksArr = tasks.sorted(by: {
            (t1: Task, t2: Task) -> Bool in
            return t1.getTimeSpentRaw() > t2.getTimeSpentRaw()
        })
        
        for t in tasksArr {
            messageBody += formatTask(task: t)
        }
        
        let message = genEmailHeader(date: date) + messageBody + genEmailFooter()
        do {
            try message.write(toFile: config.getEmailPath(), atomically: false, encoding: String.Encoding.utf8)
        }
        catch let error as NSError {
            print("Ooops! Something went wrong: \(error)")
        }
    }
    
    static func getFormattedTime(time: Double) -> String {
        let hour = Int(time)
        let min = Int((time - Double(hour))*60.0)
        var m: String
        var h: String
        if hour == 0 {
            m = min == 1 ? "min" : "mins"
            return String(format: "%d   ",min) + m
        }
        h = hour == 1 ? "hour" : "hours"
        if min == 0 {
            return String(format:"%d:00 ",hour) + h
        }
        if min < 10 {
            return String(format: "%d:0%d ",hour,min)
        }
        return String(format: "%d:%d ",hour,min) + h
    }
    
    private static func genSubjectHeading(date: Date) -> String {
        let weekNo = "Timelog " + DateUtil.getWeekOfYear(date: date) + ": "
        let content = "Week ending on Saturday "
        let endDate = DateUtil.getStringMonthAndDay(date: date)
        return "Subject: " + weekNo + content + endDate + "\n"
    }
    
    private static func formatTask(task: Task) -> String {
        var output = "  "
        output += task.title.padding(toLength: 27, withPad: " ", startingAt: 0)
        output += task.getTimeSpent().padding(toLength: 14, withPad: " ", startingAt: 0)
        output += task.getFrequency().padding(toLength: 12, withPad: " ", startingAt: 0)
        output += task.getAverage().padding(toLength: 20, withPad: " ", startingAt: 0)
        if task.isBaseTask() { return "<b>" + output + "</b>\n" + dashes}
        return output + "\n" + dashes
    }
    
    private static func genEmailHeader(date: Date) -> String {
        return "MIME-Version: 1.0\n" +
               "Content-Type: text/html\n" +
               "Content-Disposition: inline\n" +
                genSubjectHeading(date: date) +
               "<html>\n" +
               "<body style=\"background-color: #4fe0cc\">\n" +
               "<pre style=\"font: monospace; font-size: 12pt\">\n"
    }
    
    private static func genEmailFooter() -> String {
        return "</pre>\n" +
               "</body>\n" +
               "</html>\n"
    }
}
