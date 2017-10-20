import Foundation

class DateUtil {
    static let months = ["January", "February", "March",
                     "April", "May", "June",
                     "July", "August", "September",
                     "October", "November", "December"]
    
    
    static func getPreviousWeek() -> Date {
        return (Calendar.current as NSCalendar).date(byAdding: .day, value: -7, to: Date(), options: [])!
        
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
    
}
