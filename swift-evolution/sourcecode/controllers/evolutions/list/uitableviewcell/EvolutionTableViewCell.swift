import UIKit
import SwiftRichString

enum Tag: String {
    case content = "content"
    case title = "title"
    case value = "value"
    case id = "id"
    
    func wrap(string: String) -> String {
        return "<\(self.rawValue)>\(string)</\(self.rawValue)>"
    }
}

extension String {
    static var newLine: String {
        return "\n"
    }
    
    static var doubleSpace: String {
        return "  "
    }
    
    func tag(_ tag: Tag) -> String {
        return tag.wrap(string: self)
    }
}

class EvolutionTableViewCell: UITableViewCell, CellProtocol {
    
    @IBOutlet private weak var statusLabel: StatusLabel!
    @IBOutlet private weak var detailsLabel: UILabel!
    
    static var cellIdentifier: String {
        return String(describing: self)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    
    public var proposal: Evolution? {
        didSet {
            self.configureElements()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    private func configureElements() {
        guard let proposal = self.proposal else {
            return
        }
        
        let state = proposal.status.state.rawValue
        self.statusLabel.borderColor = state.color
        self.statusLabel.textColor = state.color
        self.statusLabel.text = state.name
        
        var details = ""
        
        details += proposal.id.tag(.id)
        details += String.doubleSpace
        details += proposal.title.trimmingCharacters(in: .whitespacesAndNewlines).tag(.title)
        
        // Render Authors
        if let authors = self.renderAuthors() {
            details += String.newLine + String.newLine
            details += authors
        }
        
        // Render Review Manager
        if let reviewer = proposal.reviewManager, let name = reviewer.name, name != "" {
            details += String.newLine + "Review Manager:" + String.doubleSpace + name.tag(.value)
        }
        
        // Render Bugs
        if let bugs = self.renderBugs() {
            details += String.newLine + bugs
        }
        
        // Render Implemented Proposal
        if proposal.status.state == .implemented, let version = proposal.status.version {
            details += String.newLine + "Implemented In:" + String.doubleSpace + "Swift \(version)".tag(.value)
        }
        
        let defaultStyle = Style("defaultStyle", {
            $0.lineSpacing = 5.5
            $0.hyphenationFactor = 1.0
        })
        
        if let tagged = try? MarkupString(source: details) {
            self.detailsLabel.attributedText = tagged.render(withStyles: self.styles()).add(style: defaultStyle)
        }
    }
    
    private func styles() -> [Style] {
        let id = Style("id", {
            $0.font = FontAttribute(.HelveticaNeue, size: 20)
            $0.color = UIColor.Proposal.lightGray
            $0.lineSpacing = 0
        })
        
        let title = Style("title", {
            $0.font = FontAttribute(.HelveticaNeue, size: 20)
            $0.color = UIColor.Proposal.darkGray
            $0.lineSpacing = 0
        })

        let value = Style("value", {
            $0.color = UIColor.Proposal.darkGray
        })

        return [id, title, value]
    }
    
    private func renderAuthors() -> String? {
        guard let proposal = self.proposal,
            let authors = proposal.authors,
            authors.count > 0 else {
            return nil
        }
        
        let names: [String] = authors.flatMap({ $0.name })
        
        var detail = names.count > 1 ? "Authors" : "Author"
        detail = "\(detail):" + String.doubleSpace + names.joined(separator: ", ").tag(.value)
        
        return detail
    }
    
    private func renderBugs() -> String? {
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
        detail = "\(detail):" + String.doubleSpace + names.joined(separator: ", ").tag(.value)
        
        return detail
    }
    
}
