import UIKit

final class AboutDetailTableViewController: UITableViewController {

    var about: Section? {
        didSet {
            guard let about = about else {
                return
            }
            
            self.title = about.section.rawValue
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        clearsSelectionOnViewWillAppear = true
        tableView.registerClass(CustomSubtitleTableViewCell.self)
        
        tableView.rowHeight = 44
        
        var contentInset = tableView.contentInset
        contentInset.top += 10
        contentInset.bottom += 10
        
        tableView.contentInset = contentInset
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

// MARK: UITableView DataSource
extension AboutDetailTableViewController {

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let about = about else {
            return 0
        }
        
        return about.items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let about = about else {
            return UITableViewCell()
        }
        
        let cell = tableView.cell(forRowAt: indexPath) as CustomSubtitleTableViewCell
        cell.selectionStyle = .none
        
        if about.items is [Contributor], let item = about.items[indexPath.row] as? Contributor {
            cell.contributor = item
        }
        else if about.items is [License], let item = about.items[indexPath.row] as? License {
            cell.license = item
        }
        
        return cell
    }
}

// MARK: UITableView Delegate
extension AboutDetailTableViewController {
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    override func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        guard  let cell = tableView.cellForRow(at: indexPath) else {
            return
        }

        UIView.animate(withDuration: 0.1, delay: 0, options: .allowUserInteraction, animations: {
            cell.transform = CGAffineTransform(scaleX: 1.07, y: 1.07)
            cell.contentView.alpha = 1
        })

    }
    
    override func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {
        guard  let cell = tableView.cellForRow(at: indexPath) else {
            return
        }
        
        UIView.animate(withDuration: 0.1, delay: 0, options: .allowUserInteraction, animations: {
            cell.transform = .identity
            cell.contentView.alpha = 1
        })
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let about = about else {
            return
        }
        
        let item = about.items[indexPath.row]
        let alertController = UIAlertController.presentAlert(to: item)
        
        self.present(alertController, animated: true, completion: nil)
    }
}
