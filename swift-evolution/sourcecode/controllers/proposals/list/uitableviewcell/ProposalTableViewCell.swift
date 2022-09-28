import UIKit
import SwiftRichString

class ProposalTableViewCell: UITableViewCell {
    
    // MARK: - IBOutlets
    @IBOutlet private weak var statusIndicatorView: UIView!
    @IBOutlet private weak var statusLabel: StatusLabel!
    @IBOutlet private weak var detailsLabel: UITextView!
    
    @IBOutlet private weak var statusLabelWidthConstraint: NSLayoutConstraint!
    
    // MARK: - Initialization
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.detailsLabel.delegate = self
        // Configure links into textView
        self.detailsLabel.linkTextAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor.Proposal.darkGray
        ]
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
        let statusWidth = state.shortName.estimatedWidth(height: self.statusLabel.bounds.size.height,
                                                    font: self.statusLabel.font)
        self.statusLabelWidthConstraint.constant = statusWidth + 20
        
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
            if let reviewer = proposal.reviewManager, var name = reviewer.name, name != "" {
                if name != "TBD", name != "N/A" {
                    name = name.tag(.anchor)
                }
                
                details += String.newLine + "Review Manager:".tag(.label) + String.doubleSpace + name
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
            
            // Render Implementations
            if let implementations = renderImplementations() {
                details += String.newLine + implementations
            }
        }
        else {
            self.detailsLabel.isUserInteractionEnabled = false
        }
        
        let defaultStyle = Style {
            $0.lineSpacing = 5.5
            $0.hyphenationFactor = 1.0
        }
        
        // Convert all styles into text
        let styleGroup = StyleGroup(base: defaultStyle, styles())
        var attributedText = details.set(style: styleGroup)
        let details2 = attributedText.string

        // Title
        attributedText = attributedText.link(title: proposal, text: details2)

        // Authors
        if let authors = proposal.authors {
            attributedText = attributedText.link(authors, text: details2)
            detailsLabel.attributedText = attributedText
        }

        // Review Manager
        if let reviewer = proposal.reviewManager {
            attributedText = attributedText.link(reviewer, text: details2)
            detailsLabel.attributedText = attributedText
        }

        // Implementations
        if let implementations = proposal.implementations {
            attributedText = attributedText.link(implementations, text: details2)
        }

        self.detailsLabel.attributedText = attributedText
    }
}

// MARK: - Renders && Style
extension ProposalTableViewCell {
    
    fileprivate func styles() -> [String: StyleProtocol] {
        let id = Style {
            $0.font = SystemFonts.HelveticaNeue.font(size: 20)
            $0.color = UIColor.Proposal.lightGray
            $0.lineSpacing = 0
        }
        
        let title = Style {
            $0.font = SystemFonts.HelveticaNeue.font(size: 20)
            $0.color = UIColor.Proposal.darkGray
            $0.lineSpacing = 0
        }
        
        let label = Style {
            $0.color = UIColor.Proposal.lightGray
            $0.font = SystemFonts.HelveticaNeue.font(size: 14)
        }
        
        let value = Style {
            $0.color = UIColor.Proposal.darkGray
            $0.font = SystemFonts.HelveticaNeue.font(size: 14)
        }
        
        let anchor = Style {
            $0.color = UIColor.Proposal.darkGray
            $0.font = SystemFonts.HelveticaNeue.font(size: 14)
            $0.underline = (NSUnderlineStyle.single, UIColor.Proposal.darkGray)
        }

        return [
            "id": id,
            "title": title,
            "label": label,
            "value": value,
            "anchor": anchor
        ]
    }
    
    fileprivate func renderAuthors() -> String? {
        guard let proposal = self.proposal,
            let authors = proposal.authors,
            authors.count > 0 else {
                return nil
        }
        
        let names: [String] = authors.compactMap({ $0.name != "" && $0.link != "" ? $0.name : nil })
        
        var detail = names.count > 1 ? "Authors" : "Author"
        detail = "\(detail):".tag(.label) + String.doubleSpace + names.map({ $0.tag(.anchor) }).joined(separator: ", ")
        
        return detail
    }
    
    fileprivate func renderBugs() -> String? {
        guard let proposal = self.proposal,
            let bugs = proposal.bugs,
            bugs.count > 0 else {
                return nil
        }
        
        let names: [String] = bugs.compactMap({
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
    
    fileprivate func renderImplementations() -> String? {
        guard let proposal = self.proposal,
            let implementations = proposal.implementations,
            implementations.count > 0 else {
                return nil
        }
        
        var detail = implementations.count > 1 ? "Implementations" : "Implementation"
        detail = "\(detail):".tag(.label) + String.doubleSpace + implementations.map({ $0.description.tag(.anchor) }).joined(separator: ", ")
        
        return detail
    }
}

// MARK: - UITextView Delegate
extension ProposalTableViewCell: UITextViewDelegate {
    
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        return self.textView(textView, shouldInteractWith: URL, in: characterRange)
    }
    
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange) -> Bool {
        
        guard let proposal = self.proposal,
            let urlhost = URL.host,
            let host = Host(urlhost) else {
            return false
        }
        
        if host == .profile {
            let username = URL.lastPathComponent
            var person: Person?
            
            if let authors = proposal.authors, let author = authors.get(username: username) {
                person = author
            }
            
            if let manager = proposal.reviewManager, let reviewer = manager.username, reviewer == username {
                person = manager
            }
            
            if let person = person, let delegate = self.delegate {
                delegate.didSelect(person: person)
            }
        }
        else if host == .proposal, let proposal = self.proposal {
            delegate?.didSelect(proposal: proposal)
        }
        else if host == .implementation, let proposal = self.proposal, let implementations = proposal.implementations {
            guard let path = URL["path"], let value = implementations.get(by: path)  else {
                return false
            }
            
            delegate?.didSelect(implementation: value)
        }
        
        return false
    }
}

// MARK: - NSMutableAttributedString Extension
fileprivate extension NSMutableAttributedString {
    
    func add(style: Style, range: NSRange) -> NSMutableAttributedString {
        self.addAttributes(style.attributes, range: range)
        return self
    }
    
    func link(_ person: Person, text: String) -> NSMutableAttributedString {
        return self.link([person], text: text)
    }
    
    func link(_ people: [Person], text: String) -> NSMutableAttributedString {
        var attributed = self
        
        people.forEach { person in
            guard let username = person.username, let name = person.name else {
                return
            }

            let nameRange = (text as NSString).range(of: name)
            if nameRange.location != NSNotFound {
                let style = Style {
                    $0.linkURL = URL(string: "evo://profile/\(username)")
                }

                attributed = attributed.add(style: style, range: nameRange)
            }
        }
        
        return attributed
    }
    
    func link(title proposal: Proposal, text: String) -> NSMutableAttributedString {
        var attributed = self
        
        let title = proposal.title.trimmingCharacters(in: .whitespacesAndNewlines)
        let titleRange = (text as NSString).range(of: title)
        if titleRange.location != NSNotFound {
            let style = Style {
                $0.linkURL = URL(string: "evo://proposal/\(proposal.description)")
            }
            
            attributed = attributed.add(style: style, range: titleRange)
        }
        
        return attributed
    }
    
    func link(_ implementations: [Implementation], text: String) -> NSMutableAttributedString {
        var attributed = self
        
        implementations.forEach { implementation in
            let textRange = (text as NSString).range(of: implementation.description)
            if textRange.location != NSNotFound {
                let style = Style {
                    $0.linkURL = URL(string: "evo://implementation?path=\(implementation.path)")
                }
                
                attributed = attributed.add(style: style, range: textRange)
            }
        }
        
        return attributed
    }
 }
