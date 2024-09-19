import UIKit

import ModelsLibrary

final class AboutDetailTableViewController: UITableViewController {
  var about: Section? {
    didSet {
      guard let about else {
        return
      }

      title = about.section.rawValue
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
}

// MARK: UITableView DataSource

extension AboutDetailTableViewController {
  override func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
    guard let about else {
      return 0
    }

    return about.items.count
  }

  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let about else {
      return UITableViewCell()
    }

    let cell = tableView.cell(at: indexPath) as CustomSubtitleTableViewCell
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
  override func tableView(_: UITableView, heightForFooterInSection _: Int) -> CGFloat {
    0.01
  }

  override func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
    guard let cell = tableView.cellForRow(at: indexPath) else {
      return
    }

    UIView.animate(withDuration: 0.1, delay: 0, options: .allowUserInteraction, animations: {
      cell.transform = CGAffineTransform(scaleX: 1.07, y: 1.07)
      cell.contentView.alpha = 1
    }, completion: nil)
  }

  override func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {
    guard let cell = tableView.cellForRow(at: indexPath) else {
      return
    }

    UIView.animate(withDuration: 0.1, delay: 0, options: .allowUserInteraction, animations: {
      cell.transform = .identity
      cell.contentView.alpha = 1
    }, completion: nil)
  }

  override func tableView(_: UITableView, willDisplay cell: UITableViewCell, forRowAt _: IndexPath) {
    cell.setNeedsDisplay()
  }

  override func tableView(_: UITableView, didSelectRowAt indexPath: IndexPath) {
    guard let about else {
      return
    }

    let item = about.items[indexPath.row]
    let alertController = UIAlertController.presentAlert(to: item)

    present(alertController, animated: true, completion: nil)
  }
}
