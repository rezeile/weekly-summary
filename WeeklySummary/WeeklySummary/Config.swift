import Foundation

class Config {
    var emailpath: String = String()
    var shellpath: String = String()
    var from: String = String()
    var to: String = String()
    
    init() {
        self.parse()
        self.genSendMailScript()
    }
    
    func getWritePath() -> String {
        return ""
    }
    
    func getLaunchPath() -> String {
        //"/bin/bash"
        return ""
    }
    
    func getLaunchArguments() -> [String] {
        //["/Users/elie/programming/weekly-summary/WeeklySummary/WeeklySummary/email.sh"]
        return [""]
    }
    
    private func genSendMailScript() {
        let script = "#!/bin/bash\n" + "sendmail -f " + self.from + " " + self.to + " < " + self.emailpath

        do {
            try script.write(toFile: self.shellpath, atomically: false, encoding: String.Encoding.utf8)
        }
        catch let error as NSError {
            print("Ooops! Something went wrong: \(error)")
        }
    }
    
    private func parse() {
        self.parseLaunchPath
        self.parseLaunchArguments
        self.parseEmailPath()
        self.parseShellPath()
        self.parseFromAddress()
        self.parseToAddress()
    }
    
    private func parseLaunchPath() {
        
    }
    
    private func parseLaunchArguments() {
        
    }
    
    private func parseEmailPath() {
        
    }
    
    private func parseShellPath() {
        
    }
    
    private func parseFromAddress() {
        
    }
    
    private func parseToAddress() {
        
    }
}
