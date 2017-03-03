import UIKit

extension String {
    static var newLine: String {
        return "\n"
    }
}

class EvolutionTableViewCell: UITableViewCell, CellProtocol {

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
        
    func renderAuthors() -> String? {
        guard let proposal = self.proposal,
            let authors = proposal.authors,
            authors.count > 0 else {
            return nil
        }
        
        let names: [String] = authors.flatMap({ $0.name })
        
        var detail = names.count > 1 ? "Authors" : "Author"
        detail = "\(detail): \(names.joined(separator: ", "))"
        
        return detail
    }
}
