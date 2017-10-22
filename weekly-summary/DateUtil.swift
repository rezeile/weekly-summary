import Foundation

class DateUtil {
    static let months = ["January", "February", "March",
                         "April", "May", "June",
                         "July", "August", "September",
                         "October", "November", "December"]
    
    static let daysOfWeek = [1: "S", 2: "M", 3: "T", 4: "W", 5: "T", 6: "F", 7: "S"]
    
    
    static func getPreviousWeek(date: Date) -> Date {
        let date: Date = (Calendar.current as NSCalendar).date(byAdding: .day, value: -7, to: date, options: [])!
        return date.addingTimeInterval(70.0)
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
        let seconds = endDate.timeIntervalSince(startDate);
        return seconds / 3600
    }
    
    static func getEndDate() -> Date {
        var date: Date = Date()
        let cal = (Calendar.current as NSCalendar)
        let wdValue = getWeekDay(date: date) == 7 ? 0 : (getWeekDay(date: date) * -1)
        date = cal.date(byAdding: .weekday, value: wdValue, to: date, options: [])!
        date = cal.date(byAdding: .hour, value: (23 - getHour(date: date)), to: date, options: [])!
        date = cal.date(byAdding: .minute, value: (59 - getMinute(date: date)), to: date, options: [])!
        return date
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
    
    private static func getWeekDay(date: Date) -> Int {
        return Calendar.current.component(.weekday, from: date)
    }
    
    private static func getHour(date: Date) -> Int {
        return Calendar.current.component(.hour, from: date)
    }
    
    private static func getMinute(date: Date) -> Int {
        return Calendar.current.component(.minute, from: date)
    }
    
}
