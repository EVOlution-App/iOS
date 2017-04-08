import UIKit
import SwiftRichString

class ProposalTableViewCell: UITableViewCell {
    
    // MARK: - IBOutlets
    @IBOutlet fileprivate weak var statusIndicatorView: UIView!
    @IBOutlet fileprivate weak var statusLabel: StatusLabel!
    @IBOutlet fileprivate weak var detailsLabel: UITextView!
    
    @IBOutlet private weak var statusLabelWidthConstraint: NSLayoutConstraint!
    
    // MARK: - Initialization
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    
    // MARK: - Public properties
    weak open var delegate: ProposalDelegate?
    public var proposal: Proposal? {
        didSet {
            self.configureElements()
        }
    }

    // MARK: - Layout
    private func configureElements() {
        guard let proposal = self.proposal else {
            return
        }
        
        let state = proposal.status.state.rawValue
        self.statusLabel.borderColor = state.color
        self.statusLabel.textColor = state.color
        self.statusLabel.text = state.shortName
        self.statusIndicatorView.backgroundColor = state.color
        
        // Fit size to status text
        let statusWidth = state.shortName.contraint(height: self.statusLabel.bounds.size.height,
                                                    font: self.statusLabel.font)
        self.statusLabelWidthConstraint.constant = statusWidth + 20
        self.statusLabel.setNeedsUpdateConstraints()
        self.statusLabel.layoutIfNeeded()
        
        var details = ""
        
        details += proposal.description.tag(.id)
        details += String.newLine
        
        let title = proposal.title.trimmingCharacters(in: .whitespacesAndNewlines).convertHTMLEntities.tag(.title)

        details += title
        
        if self.delegate != nil {
            
            // Render Authors
            if let authors = self.renderAuthors() {
                details += String.newLine + String.newLine
                details += authors
            }
            
            // Render Review Manager
            if let reviewer = proposal.reviewManager, let name = reviewer.name, name != "" {
                details += String.newLine + "Review Manager:".tag(.label) + String.doubleSpace + name.tag(.person)
            }
            
            // Render Bugs
            if let bugs = self.renderBugs() {
                details += String.newLine + bugs
            }
            
            // Render Implemented Proposal
            if proposal.status.state == .implemented, let version = proposal.status.version {
                details += String.newLine + "Implemented in:".tag(.label) + String.doubleSpace + "Swift \(version)".tag(.value)
            }
            
            // Render Status
            if proposal.status.state == .acceptedWithRevisions ||
                proposal.status.state == .activeReview ||
                proposal.status.state == .scheduledForReview ||
                proposal.status.state == .returnedForRevision {
                
                details += String.newLine + "Status:".tag(.label) + String.doubleSpace + state.name.tag(.value)
                
                if (proposal.status.state == .activeReview ||
                    proposal.status.state == .scheduledForReview), let period = self.renderReviewPeriod() {
                    
                    details += String.newLine + period
                }
            }
        }
        else {
            self.detailsLabel.isUserInteractionEnabled = false
        }
        
        let defaultStyle = Style("defaultStyle", {
            $0.lineSpacing = 5.5
            $0.hyphenationFactor = 1.0
        })
        
        // Convert all styles into text
        if let tagged = try? MarkupString(source: details) {
            var attributedText = tagged.render(withStyles: self.styles()).add(style: defaultStyle)
            self.detailsLabel.attributedText = attributedText
            
            guard let details = self.detailsLabel.text else { return }
            
            // Configure links into textView
            self.detailsLabel.linkTextAttributes = [
                NSForegroundColorAttributeName: UIColor.Proposal.darkGray
            ]
            
            // Authors
            guard let authors = proposal.authors else { return }
            attributedText = attributedText.link(authors, text: details)
            self.detailsLabel.attributedText = attributedText
            
            // Review Manager
            guard let reviewer = proposal.reviewManager else { return }
            attributedText = attributedText.link(reviewer, text: details)
            self.detailsLabel.attributedText = attributedText
            
            // Title
            attributedText = attributedText.link(title: proposal, text: details)
            self.detailsLabel.attributedText = attributedText
        }
    }
}

// MARK: - Renders && Style
extension ProposalTableViewCell {
    
    fileprivate func styles() -> [Style] {
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
        
        let label = Style("label", {
            $0.color = UIColor.Proposal.lightGray
            $0.font = FontAttribute(.HelveticaNeue, size: 14)
        })
        
        let value = Style("value", {
            $0.color = UIColor.Proposal.darkGray
            $0.font = FontAttribute(.HelveticaNeue, size: 14)
        })
        
        let person = Style("person", {
            $0.color = UIColor.Proposal.darkGray
            $0.font = FontAttribute(.HelveticaNeue, size: 14)
            $0.underline = UnderlineAttribute(color: UIColor.Proposal.darkGray, style: NSUnderlineStyle.styleSingle)
        })
        
        return [id, title, label, value, person]
    }
    
    fileprivate func renderAuthors() -> String? {
        guard let proposal = self.proposal,
            let authors = proposal.authors,
            authors.count > 0 else {
                return nil
        }
        
        let names: [String] = authors.flatMap({ $0.name })
        
        var detail = names.count > 1 ? "Authors" : "Author"
        detail = "\(detail):".tag(.label) + String.doubleSpace + names.map({ $0.tag(.person) }).joined(separator: ", ")
        
        return detail
    }
    
    fileprivate func renderBugs() -> String? {
        guard let proposal = self.proposal,
            let bugs = proposal.bugs,
            bugs.count > 0 else {
                return nil
        }
        
        let names: [String] = bugs.flatMap({
            if let assignee = $0.assignee, let status = $0.status {
                var issue = $0.description
                issue += " ("
                issue += assignee == "" ? "Unassigned" : assignee
                
                if status != "" {
                    issue += ", "
                    issue += status
                }
                
                issue += ")"
                
                return issue
            }
            return nil
        })
        
        var detail = names.count > 1 ? "Bugs" : "Bug"
        detail = "\(detail):".tag(.label) + String.doubleSpace + names.joined(separator: ", ").tag(.value)
        
        return detail
    }
    
    fileprivate func renderReviewPeriod() -> String? {
        guard let proposal = self.proposal,
            let startDate = proposal.status.start,
            let endDate = proposal.status.end else {
                return nil
        }
        
        let components: Set<Calendar.Component> = [.month, .day]
        let startDC = Calendar.current.dateComponents(components, from: startDate)
        let endDC = Calendar.current.dateComponents(components, from: endDate)
        
        var details = ""
        if let start = startDC.month, let end = endDC.month {
            
            details += Config.Date.Formatter.monthDay.string(from: startDate)
            details += " - "
            
            if let day = endDC.day, start == end {
                details += String(format: "%02i", day)
            }
            else {
                details += Config.Date.Formatter.monthDay.string(from: endDate)
            }
        }
        
        details = "Scheduled:".tag(.label) + String.doubleSpace + details.tag(.value)
        
        return details
    }
}

// MARK: - UITextView Delegate
extension ProposalTableViewCell: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange) -> Bool {
        
        guard let proposal = self.proposal, let host = URL.host else {
            return false
        }
        
        if host == "user" {
            let username = URL.lastPathComponent
            var person: Person?
            
            if let authors = proposal.authors, let author = authors.get(username: username) {
                person = author
            }
            
            if let manager = proposal.reviewManager, let reviewer = manager.username, reviewer == username {
                person = manager
            }
            
            if let person = person, let delegate = self.delegate {
                delegate.didSelected(person: person)
            }
        }
        else if host == "proposal", let proposal = self.proposal {
            delegate?.didSelected(proposal: proposal)
        }
        
        return false
    }
}

// MARK: - NSMutableAttributedString Extension
fileprivate extension NSMutableAttributedString {
    
    fileprivate func add(style: Style, range: NSRange) -> NSMutableAttributedString {
        self.addAttributes(style.attributes, range: range)
        return self
    }
    
    fileprivate func link(_ person: Person, text: String) -> NSMutableAttributedString {
        return self.link([person], text: text)
    }
    
    fileprivate func link(_ people: [Person], text: String) -> NSMutableAttributedString {
        var attributed = self
        people.forEach { person in
            guard let username = person.username, let name = person.name else {
                return
            }
            
            if let nameRange = text.range(of: name) {
                let range = text.toNSRange(from: nameRange)
                let style = Style("url") {
                    $0.linkURL = URL(string: "evo://user/\(username)")
                }
                
                attributed = attributed.add(style: style, range: range)
            }
        }
        
        return attributed
    }
    
    fileprivate func link(title proposal: Proposal, text: String) -> NSMutableAttributedString {
        var attributed = self
        
        let title = proposal.title.trimmingCharacters(in: .whitespacesAndNewlines)
        if let titleRange = text.range(of: title) {
            let range = text.toNSRange(from: titleRange)
            let style = Style("url") {
                $0.linkURL = URL(string: "evo://proposal/\(proposal.description)")
            }
            
            attributed = attributed.add(style: style, range: range)
        }
        
        return attributed
    }
 }
