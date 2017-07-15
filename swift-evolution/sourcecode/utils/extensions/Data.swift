import Foundation

extension Data {
    /// Convert device token data into string
    var hexString: String {
        return self.map({ String(format: "%02.2hhx", $0) }).joined()
    }
}
