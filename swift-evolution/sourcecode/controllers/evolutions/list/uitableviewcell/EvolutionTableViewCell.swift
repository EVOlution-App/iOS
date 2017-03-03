import UIKit

class EvolutionTableViewCell: UITableViewCell {

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
        
        
        
    }

}
