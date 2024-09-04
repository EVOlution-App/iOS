import Foundation


struct GitHubUserFormatter {
    static func format(unboxedValue: String?) -> String? {
        guard let unboxedValue = unboxedValue else { return nil }
        let values = unboxedValue.components(separatedBy: "/").filter { $0 != "" }
        if values.count > 0, let value = values.last {
            return value
        }

        return nil
    }
}
