import UIKit

public enum FilterLevels {
    case without
    case filtered
    case status
    case version
}

extension CGFloat {
    var paddingBottom: CGFloat {
        return self + 10
    }
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
        switch self.filterLevel {

        case .without:
            return searchBar.frame.maxY
            
        case .filtered:
            return self.filteredByButton.frame.maxY
            
        case .status:
            return self.statusFilterView.frame.maxY
            
        case .version:
            return self.languageVersionFilterView.frame.maxY
        }
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        self.statusFilterView.layoutDelegate = self
        self.languageVersionFilterView.layoutDelegate = self
        
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
