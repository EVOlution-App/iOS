import UIKit

class FilterCollectionViewCell: UICollectionViewCell {
    @IBOutlet private var statusLabel: StatusLabel!

    var text: String? = nil {
        didSet {
            statusLabel.text = text
        }
    }

    override var isSelected: Bool {
        didSet {
            statusLabel.selected = isSelected
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        isSelected = false
        statusLabel.selected = false
    }
}
