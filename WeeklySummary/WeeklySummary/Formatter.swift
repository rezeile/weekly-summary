import Foundation

class Formatter {
    static let dashCount = 165
    
    static func genContentHeading() -> String {
        let heading = "\t\t\tTask\t\t\t|\t\tTime Spent\t\t|\t\tFrequency\t\t|\t\tAverage\n"
        let dashes = String(repeating: "-",count: dashCount) + "\n"
        return dashes + heading + dashes
    }
    
    
    static func writeContentToFile(config: Config, tasks: Set<Task>) {
        var messageBody = String();
        for t in tasks {
            messageBody += formatTask(task: t)
        }
        let message = genSubjectHeading() + messageBody
        do {
            try message.write(toFile: config.getWritePath(), atomically: false, encoding: String.Encoding.utf8)
        }
        catch let error as NSError {
            print("Ooops! Something went wrong: \(error)")
        }
    }
    
    private static func genSubjectHeading() -> String {
        return "Subject: "
    }
    
    private static func formatTask(task: Task) -> String {
        /* format task */
        return "Formatted Task: "
    }
}
