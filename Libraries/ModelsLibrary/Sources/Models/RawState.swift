import Foundation
import UIKit.UIColor

struct RawState {
  let name: String
  let shortName: String
  let identifier: String

  init(_ identifier: String) {
    name = ""
    shortName = ""
    self.identifier = identifier
  }

  init(
    name: String? = nil,
    shortName: String? = nil,
    identifier: String
  ) {
    self.name = name ?? ""
    self.shortName = shortName ?? ""
    self.identifier = identifier
  }
}

// MARK: - Hashable && Equatable

extension RawState: Hashable, Equatable {
  func hash(into hasher: inout Hasher) {
    hasher.combine(identifier)
    hasher.combine(shortName)
    hasher.combine(name)
  }

  static func == (lhs: RawState, rhs: RawState) -> Bool {
    lhs.identifier == rhs.identifier
      && lhs.shortName == rhs.shortName
      && lhs.name == rhs.name
  }
}

// MARK: - Status State

public enum StatusState {
  case awaitingReview
  case scheduledForReview
  case activeReview
  case returnedForRevision
  case withdrawn
  case accepted
  case acceptedWithRevisions
  case rejected
  case implemented
  case previewing
  case error
}

extension StatusState {
  typealias RawValue = RawState

  init?(_ state: StatusState) {
    self = state
  }

  init?(rawValue: RawValue) {
    switch rawValue.identifier {
    case "awaitingReview":
      self = .awaitingReview
    case "scheduledForReview":
      self = .scheduledForReview
    case "activeReview":
      self = .activeReview
    case "returnedForRevision":
      self = .returnedForRevision
    case "withdrawn":
      self = .withdrawn
    case "accepted":
      self = .accepted
    case "acceptedWithRevisions":
      self = .acceptedWithRevisions
    case "rejected":
      self = .rejected
    case "implemented":
      self = .implemented
    case "previewing":
      self = .previewing
    case "error":
      self = .error
    default:
      return nil
    }
  }

  public var name: String {
    rawValue.name
  }

  public var shortName: String {
    rawValue.shortName
  }

  public var identifier: String {
    rawValue.identifier
  }

  private var rawValue: RawState {
    switch self {
    case .awaitingReview:
      RawState(
        name: "Awaiting Review",
        shortName: "Awaiting Review",
        identifier: "awaitingReview"
      )

    case .scheduledForReview:
      RawState(
        name: "Scheduled for Review",
        shortName: "Scheduled",
        identifier: "scheduledForReview"
      )

    case .activeReview:
      RawState(
        name: "Active Review",
        shortName: "Active Review",
        identifier: "activeReview"
      )

    case .returnedForRevision:
      RawState(
        name: "Returned for Revision",
        shortName: "Returned",
        identifier: "returnedForRevision"
      )

    case .withdrawn:
      RawState(
        name: "Withdrawn",
        shortName: "Withdrawn",
        identifier: "withdrawn"
      )

    case .accepted:
      RawState(
        name: "Accepted",
        shortName: "Accepted",
        identifier: "accepted"
      )

    case .acceptedWithRevisions:
      RawState(
        name: "Accepted with revisions",
        shortName: "Accepted",
        identifier: "acceptedWithRevisions"
      )

    case .rejected:
      RawState(
        name: "Rejected",
        shortName: "Rejected",
        identifier: "rejected"
      )

    case .implemented:
      RawState(
        name: "Implemented",
        shortName: "Implemented",
        identifier: "implemented"
      )

    case .previewing:
      RawState(
        name: "Previewing",
        shortName: "Previewing",
        identifier: "previewing"
      )

    case .error:
      RawState(
        name: "Error",
        shortName: "Error",
        identifier: "error"
      )
    }
  }
}

// MARK: - Custom String Convertible

extension StatusState: CustomStringConvertible {
  public var description: String {
    rawValue.shortName
  }
}

// MARK: - Hashable && Equatable

extension StatusState: Hashable, Equatable {
  public static func == (lhs: StatusState, rhs: StatusState) -> Bool {
    switch (lhs, rhs) {
    case (.awaitingReview, .awaitingReview),
         (.scheduledForReview, .scheduledForReview),
         (.activeReview, .activeReview),
         (.returnedForRevision, .returnedForRevision),
         (.withdrawn, .withdrawn),
         (.accepted, .accepted),
         (.acceptedWithRevisions, .acceptedWithRevisions),
         (.rejected, .rejected),
         (.implemented, .implemented),
         (.previewing, .previewing),
         (.error, .error):
      return true
    default:
      return false
    }
  }

  public func hash(into hasher: inout Hasher) {
    switch self {
    case .awaitingReview:
      hasher.combine(0)
    case .scheduledForReview:
      hasher.combine(1)
    case .activeReview:
      hasher.combine(2)
    case .returnedForRevision:
      hasher.combine(3)
    case .withdrawn:
      hasher.combine(4)
    case .accepted:
      hasher.combine(5)
    case .acceptedWithRevisions:
      hasher.combine(6)
    case .rejected:
      hasher.combine(7)
    case .implemented:
      hasher.combine(8)
    case .previewing:
      hasher.combine(9)
    case .error:
      hasher.combine(10)
    }
  }
}
