import UIKit

public enum FilterLevels {
    case without
    case filtered
    case status
    case version
}

class FilterHeaderView: UIView {

    @IBOutlet weak var statusFilterView: FilterListGenericView!
    @IBOutlet weak var languageVersionFilterView: FilterListGenericView!
    @IBOutlet weak var filteredByButton: UIButton!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var filterButton: UIButton!
    
    @IBOutlet fileprivate weak var statusFilterViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet fileprivate weak var languageVersionFilterViewHeightConstraint: NSLayoutConstraint!
    
    var filterLevel: FilterLevels = .without
    
    var statusSource: [StatusState] = [] {
        didSet {
            self.statusFilterView.type = .status
            self.statusFilterView.dataSource = self.statusSource
        }
    }
    
    var languageVersionSource: [String] = [] {
        didSet {
            self.languageVersionFilterView.type = .version
            self.languageVersionFilterView.dataSource = self.languageVersionSource
        }
    }
    
    var heightForView: CGFloat {
        var maxy: CGFloat = 0.0
        
        switch self.filterLevel {

        case .without:
            maxy = searchBar.frame.maxY
            break
            
        case .filtered:
            maxy = self.filteredByButton.frame.maxY
            break
            
        case .status:
            maxy = self.statusFilterView.frame.maxY
            break
        case .version:
            maxy = self.languageVersionFilterView.frame.maxY
            break
        }
        
        return maxy + 10
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let text = concatText(texts: formatterColor(color: UIColor.darkGray, text: "Filtered by: "),formatterColor(color: UIColor(hex: "#0088CC", alpha: 1.0)!, text: "All Statuses"))
        
        self.filteredByButton.adjustsImageWhenHighlighted = false
        self.filteredByButton.setAttributedTitle(text, for: .normal)
        self.filteredByButton.setAttributedTitle(text, for: .highlighted)
        
        self.statusFilterView.layoutDelegate = self
        self.languageVersionFilterView.layoutDelegate = self
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        self.set(to: .bottom, with: UIColor.Filter.darkGray)
    }
    
    func updateFilterButton(status: [StatusState]) {
        var label = "\(status.count) filters"
        
        if status.count == 0 {
            label = "All Statuses"
            
        } else if status.count > 0 && status.count < 3 {
            label = status.flatMap({ $0.description }).joined(separator: ", ")
        }
        
        let text = concatText(texts: formatterColor(color: UIColor.darkGray, text: "Filtered by: "), formatterColor(color: UIColor(hex: "#0088CC", alpha: 1.0)!, text: label))
        filteredByButton.setAttributedTitle(text, for: .normal)
        
    }
    
}

// MARK: - FilterGenericViewLayout Delegate
extension FilterHeaderView: FilterGenericViewLayoutDelegate {
    func didFinishedCalculateHeightToView(type: FilterListGenericType, height: CGFloat) {
        switch type {
        case .status:
            self.statusFilterViewHeightConstraint.constant = height
            self.statusFilterView.setNeedsUpdateConstraints()
            
            break
            
        case .version:
            self.languageVersionFilterViewHeightConstraint.constant = height
            self.languageVersionFilterView.setNeedsUpdateConstraints()
            break
            
        case .none:
            self.statusFilterViewHeightConstraint.constant = height
            self.statusFilterView.setNeedsUpdateConstraints()
            self.languageVersionFilterViewHeightConstraint.constant = height
            self.languageVersionFilterView.setNeedsUpdateConstraints()
            break

        }
    }
}

// MARK: - Text and Colors

extension FilterHeaderView {
    func formatterColor(color: UIColor,text : String) -> NSMutableAttributedString {
        let color = [NSForegroundColorAttributeName: color, NSFontAttributeName: UIFont.systemFont(ofSize: 14)]
        return NSMutableAttributedString(string: text, attributes: color)
    }
    
    func concatText(texts: NSAttributedString...) ->  NSAttributedString {
        let combination = NSMutableAttributedString()
        let _ = texts.map(combination.append)
        return combination
    }
}
