import Unbox
import UIKit

public struct State {
    let name: String
    let shortName: String
    let className: String
    let identifier: String
    let color: UIColor
    
    public init(_ identifier: String) {
        self.name = ""
        self.shortName = ""
        self.className = ""
        self.identifier = identifier
        self.color = UIColor.clear
    }
    
    public init(name: String? = nil, shortName: String? = nil, className: String? = nil, identifier: String, color: UIColor = UIColor.clear) {
        self.name = name ?? ""
        self.shortName = shortName ?? ""
        self.className = className ?? ""
        self.identifier = identifier
        self.color = color
    }
}

public enum StatusState {
    case awaitingReview
    case scheduledForReview
    case activeReview
    case returnedForRevision
    case withdrawn
    case deferred
    case accepted
    case acceptedWithRevisions
    case rejected
    case implemented
    case error
}

extension StatusState: RawRepresentable {
    public typealias RawValue = State
    
    public init?(_ state: StatusState) {
        self = state
    }
    
    public init?(rawValue: RawValue) {
        switch rawValue.identifier {
        case ".awaitingReview":
            self = .awaitingReview
        case ".scheduledForReview":
            self = .scheduledForReview
        case ".activeReview":
            self = .activeReview
        case ".returnedForRevision":
            self = .returnedForRevision
        case ".withdrawn":
            self = .withdrawn
        case ".deferred":
            self = .deferred
        case ".accepted":
            self = .accepted
        case ".acceptedWithRevisions":
            self = .acceptedWithRevisions
        case ".rejected":
            self = .rejected
        case ".implemented":
            self = .implemented
        case ".error":
            self = .error
            
        default:
            return nil
        }
    }
    
    public var rawValue: RawValue {
        switch self {
        case .awaitingReview:
            return State(name: "Awaiting Review", shortName: "Awaiting Review", className: "awaiting-review", identifier: ".awaitingReview", color: UIColor.Status.awaitingReview)
            
        case .scheduledForReview:
            return State(name: "Scheduled for Review", shortName: "Scheduled", className: "scheduled-for-review", identifier: ".scheduledForReview", color: UIColor.Status.scheduledForReview)
            
        case .activeReview:
            return State(name: "Active Review", shortName: "Active Review", className: "active-review", identifier: ".activeReview", color: UIColor.Status.activeReview)
            
        case .returnedForRevision:
            return State(name: "Returned for Revision", shortName: "Returned", className: "returned-for-revision", identifier: ".returnedForRevision", color: UIColor.Status.returnedForRevision)
            
        case .withdrawn:
            return State(name: "Withdrawn", shortName: "Withdrawn", className: "withdrawn", identifier: ".withdrawn", color: UIColor.Status.withdrawn)
            
        case .deferred:
            return State(name: "Deferred", shortName: "Deferred", className: "deferred", identifier: ".deferred", color: UIColor.Status.deferred)
            
        case .accepted:
            return State(name: "Accepted", shortName: "Accepted", className: "accepted", identifier: ".accepted", color: UIColor.Status.accepted)
            
        case .acceptedWithRevisions:
            return State(name: "Accepted with Revisions", shortName: "Accepted", className: "accepted-with-revisions", identifier: ".acceptedWithRevisions", color: UIColor.Status.acceptedWithRevisions)
            
        case .rejected:
            return State(name: "Rejected", shortName: "Rejected", className: "rejected", identifier: ".rejected", color: UIColor.Status.rejected)
            
        case .implemented:
            return State(name: "Implemented", shortName: "Implemented", className: "implemented", identifier: ".implemented", color: UIColor.Status.implemented)
            
        case .error:
            return State(name: "Error", shortName: "Error", className: "error", identifier: ".error", color: UIColor.clear)
        }
    }
}

extension StatusState: CustomStringConvertible {
    public var description: String {
        return self.rawValue.shortName
    }
}
