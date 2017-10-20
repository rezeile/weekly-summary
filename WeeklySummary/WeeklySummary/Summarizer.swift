import EventKit

class Summarizer {
    
    let eventStore = EKEventStore()
    var calendars: [EKCalendar] = []
    var events: [EKEvent] = []
    
    func loadEvents(startDate: String, endDate: String) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        let start = dateFormatter.date(from: startDate)
        let end = dateFormatter.date(from: endDate)
        
        if let start = start, let end = end {
            let eventsPredicate = eventStore.predicateForEvents(withStart: start, end: end, calendars: calendars)
            
            self.events = eventStore.events(matching: eventsPredicate)
            
            for e in self.events {
                print(e.title)
                print(e.startDate)
                print(e.endDate)
            }
        }
    }
    
    func loadCalendars() {
        self.calendars = eventStore.calendars(for: EKEntityType.event)
        
        /* get start and end date */
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
}
