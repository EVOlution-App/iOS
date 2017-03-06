import UIKit
import SwiftRichString

class EvolutionTableViewCell: UITableViewCell {
    
    // MARK: - IBOutlets
    @IBOutlet private weak var statusIndicatorView: UIView!
    @IBOutlet private weak var statusLabel: StatusLabel!
    @IBOutlet private weak var detailsLabel: UILabel!
    
    @IBOutlet private weak var statusLabelWidthConstraint: NSLayoutConstraint!
    
    // MARK: - Initialization
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    
    // MARK: - Public properties
    public var proposal: Evolution? {
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
            details += String.newLine + "Implemented in:" + String.doubleSpace + "Swift \(version)".tag(.value)
        }
        
        // Render Status
        if proposal.status.state == .acceptedWithRevisions ||
            proposal.status.state == .activeReview ||
            proposal.status.state == .scheduledForReview ||
            proposal.status.state == .returnedForRevision {
            
            details += String.newLine + "Status:" + String.doubleSpace + state.name.tag(.value)
            
            if (proposal.status.state == .activeReview ||
                proposal.status.state == .scheduledForReview), let period = self.renderReviewPeriod() {
            
                details += String.newLine + period
            }
        }
        
        let defaultStyle = Style("defaultStyle", {
            $0.lineSpacing = 5.5
            $0.hyphenationFactor = 1.0
        })
        
        if let tagged = try? MarkupString(source: details) {
            self.detailsLabel.attributedText = tagged.render(withStyles: self.styles()).add(style: defaultStyle)
        }
    }
}

// MARK: - Renders && Style
extension EvolutionTableViewCell {
    
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
        
        let value = Style("value", {
            $0.color = UIColor.Proposal.darkGray
        })
        
        return [id, title, value]
    }

    fileprivate func renderAuthors() -> String? {
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
    
    fileprivate func renderBugs() -> String? {
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
                details += String(day)
            }
            else {
                details += Config.Date.Formatter.monthDay.string(from: endDate)
            }
        }
        
        details = "Scheduled:" + String.doubleSpace + details.tag(.value)
        
        return details
    }
}
