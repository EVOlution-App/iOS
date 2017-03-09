import UIKit

class StatusLabel: BorderedLabel {

    @IBInspectable
    var selectedColor: UIColor? = nil
    
    @IBInspectable
    var normalColor: UIColor? = nil
    
    @IBInspectable
    var selected: Bool = false {
        didSet {
            if let normalColor = self.normalColor,
                let selectedColor = self.selectedColor {
                self.textColor = selected ? selectedColor : normalColor
                self.backgroundColor = selected ? normalColor : UIColor.clear
            }
        }
    }
    
    override func drawText(in rect: CGRect) {
        let edgeInsets = UIEdgeInsetsInsetRect(rect, UIEdgeInsets(top: 0, left: 8, bottom: 3, right: 8))
        
        super.drawText(in: edgeInsets)
    }
    
    
}
