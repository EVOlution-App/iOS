import Foundation

public enum Host {
    case proposal
    case profile
    case implementation

    init?(_ value: String?) {
        guard let value else {
            return nil
        }

        switch value {
        case "proposal":
            self = .proposal

        case "profile":
            self = .profile

        case "implementation":
            self = .implementation

        default:
            return nil
        }
    }
}

final class Navigation {
    static let shared = Navigation()

    var host: Host?
    var value: String?

    var isClear: Bool {
        host == nil
    }

    func clear() {
        host = nil
        value = nil
    }
}

extension Navigation: CustomStringConvertible {
    var description: String {
        var value = ""

        if let host {
            value += "Host: \(host)"
        }

        if let content = self.value {
            value += value.count > 0 ? ", " : ""
            value += "Value: \(content)"
        }

        value = "Navigation<\(value)>"

        return value
    }
}
