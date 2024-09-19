import ModelsLibrary
import UIKit.UIColor

extension StatusState {
  var color: UIColor {
    switch self {
    case .awaitingReview:
      .Status.awaitingReview
    case .scheduledForReview:
      .Status.scheduledForReview
    case .activeReview:
      .Status.activeReview
    case .returnedForRevision:
      .Status.returnedForRevision
    case .withdrawn:
      .Status.withdrawn
    case .accepted:
      .Status.accepted
    case .acceptedWithRevisions:
      .Status.acceptedWithRevisions
    case .rejected:
      .Status.rejected
    case .implemented:
      .Status.implemented
    case .previewing:
      .Status.previewing
    case .error:
      .clear
    }
  }
}
