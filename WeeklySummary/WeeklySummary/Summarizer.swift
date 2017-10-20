import EventKit

class Summarizer {
    
    let eventStore = EKEventStore()
    var calendars: [EKCalendar] = []
    var events: [EKEvent] = []
    
    func formattedDate(date: Date) -> String {
        let year = Calendar.current.component(.year, from: date)
        let month = Calendar.current.component(.month, from: date)
        let day = Calendar.current.component(.day, from: date)
        return year.description + "-" +  month.description + "-" + day.description
    }
    
    func loadCalendars() {
        self.calendars = eventStore.calendars(for: EKEntityType.event)
        
        // Create a date formatter instance to use for converting a string to date
        
        // Create start and end date instances
        print(self.formattedDate(date: Date()))
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
