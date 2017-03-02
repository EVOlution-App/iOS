import UIKit

class EvolutionTableViewCell: UITableViewCell {

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
