import Foundation

extension Data {
    /// Convert device token data into string
    var hexString: String {
        map { String(format: "%02.2hhx", $0) }.joined()
    }
}
