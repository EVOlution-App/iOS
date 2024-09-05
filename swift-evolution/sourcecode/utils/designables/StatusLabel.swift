import UIKit

class StatusLabel: BorderedLabel {
  @IBInspectable
  var selectedColor: UIColor?

  @IBInspectable
  var normalColor: UIColor?

  @IBInspectable
  var selected: Bool = false {
    didSet {
      if let normalColor,
         let selectedColor
      {
        textColor = selected ? selectedColor : normalColor
        backgroundColor = selected ? normalColor : UIColor.clear
      }
    }
  }

  override func drawText(in rect: CGRect) {
    let edgeInsets = rect.inset(by: UIEdgeInsets(top: 0, left: 8, bottom: 3, right: 8))

    super.drawText(in: edgeInsets)
  }
}

#Preview {
  let label = StatusLabel()
  label.selected = true
  label.text = "Selected"
  return label
}
