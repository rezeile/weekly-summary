import Foundation

class Formatter {
    private static let dashes = String(repeating: "-",count: 70) + "\n"
    
    static func genContentHeading() -> String {
        let task = "Task".padding(toLength: 25, withPad: " ", startingAt: 0) + "|"
        let timeSpent = " Time Spent ".padding(toLength: 13, withPad: " ", startingAt: 0) + "|"
        let frequency = " Frequency ".padding(toLength: 19, withPad: " ", startingAt: 0) + "|"
        let heading = task + timeSpent + frequency + " Average\n"
        return "<b>" + dashes + heading + dashes + "</b>"
    }
    
    
    static func writeContentToFile(config: Config, tasks: Set<Task>, date: Date) {
        var messageBody = genContentHeading()
        for t in tasks {
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
    
    private static func genSubjectHeading(date: Date) -> String {
        return "Subject: Timelog for Week of " + DateUtil.getStringMonthAndDay(date: date) + "\n"
    }
    
    private static func formatTask(task: Task) -> String {
        var output = String()
        var str = String()
        /* add task title */
        output += task.title.padding(toLength: 26, withPad: " ", startingAt: 0)
        /* add time spent */
        output += task.getTimeSpent().padding(toLength: 14, withPad: " ", startingAt: 0)

        /* add frequency */
        output += task.getFrequency().padding(toLength: 20, withPad: " ", startingAt: 0)

        /* add average */
        str = "4:38"
        output += str.padding(toLength: 20, withPad: " ", startingAt: 0)

        return output + "\n"
    }
    
    private static func genEmailHeader(date: Date) -> String {
        return "MIME-Version: 1.0\n" +
               "Content-Type: text/html\n" +
               "Content-Disposition: inline\n" +
                genSubjectHeading(date: date) +
               "<html>\n" +
               "<body>\n" +
               "<pre style=\"font: monospace; font-size: 12pt\">\n"
    }
    
    private static func genEmailFooter() -> String {
        return "</pre>\n" +
               "</body>\n" +
               "</html>\n"
    }
}
