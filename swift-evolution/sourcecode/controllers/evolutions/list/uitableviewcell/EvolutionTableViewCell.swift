import UIKit

extension String {
    static var newLine: String {
        return "\n"
    }
}

class EvolutionTableViewCell: UITableViewCell, CellProtocol {

    @IBOutlet private weak var statusLabel: StatusLabel!
    @IBOutlet private weak var idLabel: UILabel!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var detailsLabel: UILabel!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    
    public var evolution: Evolution? = nil {
        didSet {
        
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        var details = ""
        
        // Render Authors
        if let authors = self.renderAuthors() {
            details += authors + String.newLine
        }
        
        // Render Review Manager
        if let reviewer = proposal.reviewManager, let name = reviewer.name, name != "" {
            details += "Review Manager: " + name + String.newLine
        }
        
        // Render Bugs
        if let bugs = self.renderBugs() {
            details += bugs + String.newLine
        }
        
        // Render Implemented Proposal
        if proposal.status.state == .implemented, let version = proposal.status.version {
            details += "Implemented In: Swift \(version)"
        }
        
        self.detailsLabel.text = details
    }
    
    
    
    func renderAuthors() -> String? {
        guard let proposal = self.proposal,
            let authors = proposal.authors,
            authors.count > 0 else {
            return nil
        }
        
        let names: [String] = authors.flatMap({ $0.name })
        
        var detail = names.count > 1 ? "Authors" : "Author"
        detail = "\(detail): \(names.joined(separator: ", "))"
        
        return detail
    }
    
    func renderBugs() -> String? {
        guard let proposal = self.proposal,
            let bugs = proposal.bugs,
            bugs.count > 0 else {
                return nil
        }
        
        let names: [String] = bugs.flatMap({
            if let id = $0.id, let assignee = $0.assignee, let status = $0.status {
                var issue = id
                issue += " ("
                issue += assignee == "" ? "Unassigned" : assignee
                issue += ", "
                issue += status
                issue += ")"
                
                return issue
            }
            return nil
        })
        
        var detail = names.count > 1 ? "Bugs" : "Bug"
        detail = "\(detail): \(names.joined(separator: ", "))"
        
        return detail
    }
    
}
