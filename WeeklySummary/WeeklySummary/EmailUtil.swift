import Foundation
import AppKit

class EmailUtil {
    static func send() {
        let launchPath = "/bin/bash"
        let arguments = ["/Users/elie/programming/weekly-summary/WeeklySummary/WeeklySummary/email.sh"]
        
        let process = Process()
        process.launchPath = launchPath
        process.arguments = arguments
        
        
        let pipe = Pipe()
        process.standardOutput = pipe
        process.launch()
    }
}
