import UIKit

class FilterHeaderView: UIView {

    @IBOutlet private weak var statusFilterView: FilterListGenericView!
    @IBOutlet private weak var languageVersionFilterView: FilterListGenericView!
    
    @IBOutlet private weak var statusFilterViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet private weak var languageVersionFilterViewHeightConstraint: NSLayoutConstraint!
    
    var statusSource: [StatusState] = [] {
        didSet {
            self.statusFilterView.type = .version
            self.statusFilterView.dataSource = self.statusSource
        }
    }
    
    var languageVersionSource: [String] = [] {
        didSet {
            self.languageVersionFilterView.type = .status
            self.languageVersionFilterView.dataSource = self.languageVersionSource
        }
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        

    }
    
    override func layoutSubviews() {
        self.languageVersionFilterViewHeightConstraint.constant = self.languageVersionFilterView.height
        self.languageVersionFilterView.setNeedsUpdateConstraints()
        
        self.statusFilterViewHeightConstraint.constant = self.statusFilterView.height
        self.statusFilterView.setNeedsUpdateConstraints()
        
        
    }
    
}
