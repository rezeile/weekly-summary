import Foundation
import AppKit

class EmailUtil {
    static func send(config: Config) {
        let launchPath = config.getLaunchPath()
        let arguments = config.getLaunchArguments()
        let process = Process()
        process.launchPath = launchPath
        process.arguments = arguments
        
        
        let pipe = Pipe()
        process.standardOutput = pipe
        process.launch()
    }
}
