import Foundation

extension DateFormatter {
    static var internals: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy"
        
        return formatter
    }
    
    static var externals: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MMMM/YYYY"
        formatter.locale = Locale(identifier: "pt_BR")
        
        return formatter
    }
}
