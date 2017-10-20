import Foundation

class DateUtil {
    class func getPreviousWeek() -> Date {
        return (Calendar.current as NSCalendar).date(byAdding: .day, value: -7, to: Date(), options: [])!
        
    }
    
    class func formattedDate(date: Date) -> String {
        let year = Calendar.current.component(.year, from: date)
        let month = Calendar.current.component(.month, from: date)
        let day = Calendar.current.component(.day, from: date)
        return year.description + "-" +  month.description + "-" + day.description
    }
}
