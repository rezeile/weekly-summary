import Foundation

class DateUtil {
    static let months = ["January", "February", "March",
                         "April", "May", "June",
                         "July", "August", "September",
                         "October", "November", "December"]
    
    static let daysOfWeek = [1: "S", 2: "M", 3: "T", 4: "W", 5: "T", 6: "F", 7: "S"]
    
    
    static func getPreviousWeek() -> Date {
        let date: Date = (Calendar.current as NSCalendar).date(byAdding: .day, value: -7, to: Date(), options: [])!
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
    
    static func getDayOfWeek(date: Date) -> (Int,String) {
        let day = Calendar.current.component(.weekday, from: date)
        return (day, daysOfWeek[day]!)
    }
    
    static func getDateFormat() -> String {
        return "yyyy-MM-dd"
    }
    
}
