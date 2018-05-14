import UIKit

protocol SwitchTableViewCellProtocol: class {
    func `switch`(active: Bool, didChangeSelectionAt indexPath: IndexPath)
}

final class SwitchTableViewCell: UITableViewCell {

    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet private weak var activityIndicatorTrailingConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var activeSwitch: UISwitch!
    
    var loadingActivity: Bool = false {
        willSet {
            DispatchQueue.main.async {
                self.activeSwitch.isEnabled = !self.loadingActivity
                self.activityIndicator(animate: newValue)
            }
        }
    }
    
    var indexPath: IndexPath?
    weak var delegate: SwitchTableViewCellProtocol?
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        activityIndicator(animate: false)
        selectionStyle = .none
        activityIndicatorTrailingConstraint.constant = 0
        activityIndicator.layoutIfNeeded()
    }

    private func activityIndicator(animate: Bool = false) {
        let targetX = animate ? activeSwitch.frame.size.width + activityIndicator.frame.size.width : 16
        let alpha: CGFloat = animate ? 1 : 0
        
        let animation = {
            if animate {
                self.activityIndicator.startAnimating()
            }
            
            self.activityIndicator.alpha = alpha
            self.activityIndicatorTrailingConstraint.constant = targetX
            self.layoutIfNeeded()
        }
        
        let completion: ((Bool) -> Swift.Void) = { complete in
            if complete && !animate {
                self.activityIndicator.stopAnimating()
            }
        }

        UIView.animate(withDuration: 0.25,
                       animations: animation,
                       completion: completion)
    }
    
    @IBAction private func changeSelection(_ sender: UISwitch) {
        guard let indexPath = indexPath else {
            return
        }
        
        delegate?.switch(active: activeSwitch.isOn, didChangeSelectionAt: indexPath)
    }
}
