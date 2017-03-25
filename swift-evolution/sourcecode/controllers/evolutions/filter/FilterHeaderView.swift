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
    @IBOutlet weak var filterButton: ButtonBadge!
    
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
        
        self.statusFilterView.layoutDelegate = self
        self.languageVersionFilterView.layoutDelegate = self
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        self.set(to: .bottom, with: UIColor.Filter.darkGray)
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
            
        default:
            break
        }
    }
}
