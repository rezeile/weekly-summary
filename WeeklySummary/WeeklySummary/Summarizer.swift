import EventKit
import Foundation

class Summarizer {
    let eventStore = EKEventStore()
    var calendars: [EKCalendar] = []
    var events: [EKEvent] = []
    var timeLog = [String: Double]()
    
    func loadEvents(startDate: String, endDate: String) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        let start = dateFormatter.date(from: startDate)
        let end = dateFormatter.date(from: endDate)
        
        if let start = start, let end = end {
            let eventsPredicate = eventStore.predicateForEvents(withStart: start, end: end, calendars: calendars)
            
            self.events = eventStore.events(matching: eventsPredicate)
            self.computeTimeSpent(events: self.events)
        }
    }
    
    func computeTimeSpent(events: [EKEvent]) {
        print(events)
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
    
    func loadCalendars() {
        self.calendars = eventStore.calendars(for: EKEntityType.event)
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
                print("Access Denied")
            }
        })
    }
    
    func getEventTimeLog() -> String {
        var s = ""
        for (title, time) in timeLog {
            s += title + ": time spent = " + String(time) + "\n"
        }
        return s
    }
    
    
}
