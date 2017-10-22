import EventKit
import Foundation

class Summarizer {
    let eventStore = EKEventStore()
    var calendars: [EKCalendar] = []
    var events: [EKEvent] = []
    var config: Config
    var tasks = Set<Task>()
    var endDate: Date
    
    init(config: Config) {
        self.config = config
        self.endDate = DateUtil.getEndDate()
    }
    
    func summarize() {
        self.eventStore.requestAccess(
            to: EKEntityType.event,
            completion:self.summarizeHandler
        )
    }
    
    private func summarizeHandler(accessGranted: Bool, error: Error?) {
        if (accessGranted == true) {
            self.calendars = self.eventStore.calendars(for: EKEntityType.event)
            let startDate = DateUtil.formattedDate(date: DateUtil.getPreviousWeek(date: self.endDate))
            let endDate = DateUtil.formattedDate(date: self.endDate)
            self.loadEvents(startDate: startDate, endDate: endDate)
            self.genTasks()
            Formatter.writeContentToFile(config: self.config, tasks: self.tasks, date: self.endDate)
            EmailUtil.send(config: self.config)
        } else {
            print("Calendar Access Denied.");
        }
    }
    
    private func genTasks() {
        var eventTitles = Set<String>()
        var task: Task
        let baseTasks = Set(self.config.getBaseTasks())
        for e in self.events {
            let title = e.title.lowercased()
            let timeSpent = DateUtil.elapsedHours(startDate: e.startDate, endDate: e.endDate)
            if (eventTitles.contains(title)) {
                task = self.tasks.remove(Task(title: title, timeSpent: 0.0))!
                task.addTimeSpent(timeSpent: timeSpent)
            } else {
                eventTitles.insert(title)
                task = Task(title: title,timeSpent: timeSpent)
                
            }
            if baseTasks.contains(title) { task.setAsBaseTask() }
            task.updateFrequency(date: e.endDate)
            self.tasks.insert(task)
        }
    }
    
    private func loadEvents(startDate: String, endDate: String) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = DateUtil.getDateFormat()
        
        let start = dateFormatter.date(from: startDate)
        let end = dateFormatter.date(from: endDate)
        
        if let start = start, let end = end {
            let eventsPredicate = eventStore.predicateForEvents(withStart: start, end: end, calendars: calendars)
            self.events = eventStore.events(matching: eventsPredicate)
        }
    }
}
