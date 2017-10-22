import Foundation

class Config {
    private var baseTasks: [String] = []
    private var launchPath: String = String()
    private var launchArguments: [String] = []
    private var shellPath: String = String()
    private var emailPath: String = String()
    private var sourceEmailAddress: String = String()
    private var destEmailAddress: String = String()
    
    init() {
        self.parse()
        self.genSendMailScript()
    }
    
    func getLaunchPath() -> String {
        return self.launchPath
    }
    
    func getLaunchArguments() -> [String] {
        return self.launchArguments
    }
    
    func getShellPath() -> String {
        return self.shellPath
    }
    
    func getBaseTasks() -> [String] {
        return self.baseTasks
    }
    
    func getEmailPath() -> String {
        return self.emailPath
    }
    
    func getSourceEmailAddress() -> String {
        return self.sourceEmailAddress
    }
    
    func getDestEmail() -> String {
        return self.destEmailAddress
    }
    
    private func parse() {
        if let file = Bundle.main.url(forResource: "config", withExtension: "json") {
            do {
                let data = try Data(contentsOf: file)
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                if let object = json as? [String: Any] {
                    self.baseTasks = object["baseTasks"]! as! [String]
                    self.launchPath = String(describing: object["launchPath"]!)
                    self.launchArguments = object["launchArguments"]! as! [String]
                    self.shellPath = String(describing: object["shellPath"]!)
                    self.emailPath = String(describing: object["emailPath"]!)
                    self.sourceEmailAddress = String(describing: object["sourceEmailAddress"]!)
                    self.destEmailAddress = String(describing: object["destEmailAddress"]!)
                } else if let object = json as? [Any] {
                    print(object)
                } else {
                    print("JSON is invalid")
                }
            }
            catch let error as NSError {
                print("Ooops! Something went wrong: \(error)")
            }
        } else {
            print("no file")
        }
    }
    
    private func genSendMailScript() {
        let script = "#!/bin/bash\n" + "sendmail -f " + self.sourceEmailAddress + " " + self.destEmailAddress + " < " + self.getEmailPath()
        
        do {
            try script.write(toFile: self.shellPath, atomically: false, encoding: String.Encoding.utf8)
        }
        catch let error as NSError {
            print("Ooops! Something went wrong: \(error)")
        }
    }
    
}
