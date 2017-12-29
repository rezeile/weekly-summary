import Foundation

class DateUtil {
    static let months = ["January", "February", "March",
                         "April", "May", "June",
                         "July", "August", "September",
                         "October", "November", "December"]
    
    static let daysOfWeek = [1: "S", 2: "M", 3: "T", 4: "W", 5: "T", 6: "F", 7: "S"]
    static let NEXT_SATURDAY_THRESHHOLD = 302400 // seconds
    static let STANDARD_END_DATE = 604799 // seconds
    private var startDate: Date
    private var endDate: Date
    
    init() {
        self.endDate = DateUtil.nearestSaturday(currentDate: Date())
        let interval = -DateUtil.STANDARD_END_DATE
        self.startDate = self.endDate.addingTimeInterval(TimeInterval(interval))
    }
    
    func getStartDate() -> Date {
        return self.startDate
    }
    
    func getEndDate() -> Date {
        return self.endDate
    }
    
    static func getPreviousWeek(date: Date) -> Date {
        print("This Week Date: " + date.description)
        let prevWeekDate: Date = (Calendar.current as NSCalendar).date(byAdding: .day, value: -7, to: date, options: [])!
        print("Previous Week Date: " + prevWeekDate.description)
        return prevWeekDate;
    }
    
    static func formattedDate(date: Date) -> String {
        let year = Calendar.current.component(.year, from: date)
        let month = Calendar.current.component(.month, from: date)
        let day = Calendar.current.component(.day, from: date)
        return year.description + "-" +  month.description + "-" + day.description
    }
    
    static func getStringMonthAndDay(date: Date) -> String {
        let month = Calendar.current.component(.month, from: date)
        let day = Calendar.current.component(.day, from: date)
        return months[month-1] + " " + day.description
    }
    
    static func elapsedHours(startDate: Date, endDate: Date) -> Double {
        let seconds = endDate.timeIntervalSince(startDate)
        return seconds / 3600
    }
    
    static func getEndDate() -> Date {
        return Date()
    }
    
    static func getDayOfWeek(date: Date) -> (Int,String) {
        let day = Calendar.current.component(.weekday, from: date)
        return (day, daysOfWeek[day]!)
    }
    
    static func getWeekOfYear(date: Date) -> String {
        let weekOfYear = Calendar.current.component(.weekOfYear, from: date)
        return String(weekOfYear)
    }
    
    static func getDateFormat() -> String {
        return "yyyy-MM-dd"
    }
    
    private static func nearestSaturday(currentDate: Date) -> Date {
        let wkseconds = getWeekdaySeconds(date: currentDate)
        let interval: Int
        if (wkseconds >= NEXT_SATURDAY_THRESHHOLD) {
            interval = STANDARD_END_DATE - wkseconds
        } else {
            interval = -(wkseconds + 1)
        }
        return currentDate.addingTimeInterval(TimeInterval(interval))
    }
    
    private static func getWeekdaySeconds(date: Date) -> Int {
        let calendar = Calendar(identifier: Calendar.Identifier.gregorian)
        let weekdayOrd = calendar.component(.weekdayOrdinal, from: date)
        let hour = calendar.component(.hour, from: date)
        let min = calendar.component(.minute, from: date)
        let second = calendar.component(.second, from: date)
        return (weekdayOrd * 24 * 3600) + (hour * 3600) + (min * 60) + second
    }
    
    private static func oneWeekBefore(endDate: Date) -> Date {
        return Date()
    }
}
