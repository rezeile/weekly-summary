import EventKit
import Foundation

class Summarizer {
    let eventStore = EKEventStore()
    var addr = String()
    var calendars: [EKCalendar] = []
    var events: [EKEvent] = []
    var timeLog = [String: Double]()
    
    /* TODO -- this should come from the FileManager */
    var curPath = "/Users/elie/programming/weekly-summary/WeeklySummary/WeeklySummary/"
    
    /* TODO this should come from a config file */
//    var mainEvents: Set<String> = ["Problem Solving", "Guitar", "Meditation",
//                                   "Vocabulary", "Mental Math", "Stretching",
//                                   "Reading", "Programming Project"]
    
    func loadEvents(startDate: String, endDate: String) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        let start = dateFormatter.date(from: startDate)
        let end = dateFormatter.date(from: endDate)
        
        if let start = start, let end = end {
            let eventsPredicate = eventStore.predicateForEvents(withStart: start, end: end, calendars: calendars)
            self.events = eventStore.events(matching: eventsPredicate)
        }
        self.computeTimeSpent(events: self.events)
        let subject = "Subject: " + "Timelog: Week of " + DateUtil.getStringMonthAndDay(date: Date()) + "\n"
        self.writeContentToFile(subject: subject)
        self.updateEmailMetaData()
        EmailUtil.send()
    }
    
    func updateEmailMetaData () {
        /* TODO -- this should also come from a config file */
        let emailpath = self.curPath + "email.txt"
        let shellpath = self.curPath + "email.sh"
        let from = "mail@eliezerabate.com"
        let to = "eliezerabate@gmail.com"
        let script = "#!/bin/bash\n" + "sendmail -f " + from + " " + to + " < " + emailpath
        
        do {
            try script.write(toFile: shellpath, atomically: false, encoding: String.Encoding.utf8)
        }
        catch let error as NSError {
            print("Ooops! Something went wrong: \(error)")
        }
    }
    
    func computeTimeSpent(events: [EKEvent]) {
        for e in events {
            let title = e.title.lowercased()
            let timeSpent = DateUtil.elapsedHours(startDate: e.startDate, endDate: e.endDate)
            if (timeLog[title] != nil) {
                timeLog[title]! += timeSpent
            } else {
                timeLog[title] = timeSpent
            }
        }
    }
    
    func writeContentToFile(subject: String) {
        let message = subject + self.getEventTimeLog()
        let path = self.curPath + "email.txt"
        do {
            print(message)
            try message.write(toFile: path, atomically: false, encoding: String.Encoding.utf8)
        }
        catch let error as NSError {
            print("Ooops! Something went wrong: \(error)")
        }
    }
    
    func loadCalendars() {
        self.calendars = eventStore.calendars(for: EKEntityType.event)
        //self.addr = StringParser.getOwnerAddress(desc: self.calendars[0].source.description)
        let startDate = DateUtil.formattedDate(date: DateUtil.getPreviousWeek())
        let endDate = DateUtil.formattedDate(date: Date())
        self.loadEvents(startDate: startDate, endDate: endDate)
    }
    
    func requestCalendarAccess() {
        eventStore.requestAccess(to: EKEntityType.event, completion:{
            (accessGranted: Bool, error: Error?) in
            
            if accessGranted == true {
                self.loadCalendars()
            } else {
                print("Calendar Access Denied")
            }
        })
    }
    
    func getEventTimeLog() -> String {
        let timeLog = self.timeLog.sorted(by: {
            return $0.value > $1.value
        })
        var s = ""
        for (title, time) in timeLog {
            s += title + ": time spent = " + String(time) + "\n"
        }
        return s
    }
    
    
}
