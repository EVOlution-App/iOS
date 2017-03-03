import UIKit

class StatusLabel: BorderedLabel {

    override func drawText(in rect: CGRect) {
        let edgeInsets = UIEdgeInsetsInsetRect(rect, UIEdgeInsets(top: 3, left: 8, bottom: 3, right: 8))
        
        super.drawText(in: edgeInsets)
    }
}
