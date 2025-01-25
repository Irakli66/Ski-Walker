import Foundation

struct DateFormatterHelper {
    static func formatDate(_ isoDate: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS"
        
        guard let date = formatter.date(from: isoDate) else {
            return isoDate // Return the original string if parsing fails
        }
        
        formatter.dateFormat = "dd MMM yyyy"
        return formatter.string(from: date)
    }
}