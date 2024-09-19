import SafariServices
import UIKit

import ModelsLibrary

// MARK: - Proposal Delegate

extension ListProposalsViewController: ProposalTableViewCellDelegate {
  func proposalTableViewCell(_: ProposalTableViewCell, didSelectPerson person: Person) {
    guard person.name.isEmpty == false else {
      return
    }
    
    let profile = appDelegate?.people[person.name]
    Config.Segues.profile.performSegue(in: self, with: profile, formSheet: true)
  }
  
  func proposalTableViewCell(_: ProposalTableViewCell, didSelectProposal proposal: Proposal) {
    guard let proposal = dataSource.get(by: proposal.identifier) else {
      return
    }
    
    let sourceViewController = UIDevice.current.userInterfaceIdiom == .pad ? splitViewController : self
    Config.Segues.proposalDetail.performSegue(in: sourceViewController, with: proposal, split: true)
  }
  
  func proposalTableViewCell(_: ProposalTableViewCell, didSelectImplementation implementation: Implementation) {
    if let url = URL(string: "\(Config.Base.URL.GitHub.base)/\(implementation.path)") {
      let safariViewController = SFSafariViewController(url: url)
      present(safariViewController, animated: true)
    }
  }
}
