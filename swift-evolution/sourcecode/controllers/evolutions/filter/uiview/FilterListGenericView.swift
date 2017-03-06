import UIKit

public enum FilterType {
    case status
    case version
    case none
}



class FilterListGenericView: UIView {

    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var collectionView: UICollectionView!
    
    var type: FilterType = .none
    var dataSource: [Any] = [] {
        didSet {
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
    
    // MARK: - Initialization
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        self.collectionView.registerNib(withClass: FilterCollectionViewCell.self)
        self.collectionView.collectionViewLayout = DGCollectionViewLeftAlignFlowLayout()
    }
    
    // MARK: - Util

    fileprivate func textFor(indexPath: IndexPath) -> String? {
        var text: String?
        let item = self.dataSource[indexPath.item]
        
        if item is StatusState, let item = item as? StatusState {
            text = item.rawValue.shortName
        }
        else if item is String, let item = item as? String {
            text = item
        }
        
        return text
    }
    
    public var height: CGFloat {
        return self.descriptionLabel.bounds.maxY + self.collectionView.contentSize.height
    }
}

// MARK: - UICollectionView DataSource

extension FilterListGenericView: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.cell(forItemAt: indexPath) as FilterCollectionViewCell
        
        cell.text = self.textFor(indexPath: indexPath) ?? ""
        
        return cell
    }
}

// MARK: - UICollectionView Delegate

extension FilterListGenericView: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        print("collectionView:didSelectItemAt:")
    }

}

// MARK: - UICollectionView DelegateFlowLayout

extension FilterListGenericView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if let text = self.textFor(indexPath: indexPath), let font = UIFont(name: "HelveticaNeue", size: 16) {
            let width = text.contraint(height: 28, font: font) + 34
            
            let size = CGSize(width: width, height: 28)
            return size
        }
        
        return CGSize.zero
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 3
    }
}
