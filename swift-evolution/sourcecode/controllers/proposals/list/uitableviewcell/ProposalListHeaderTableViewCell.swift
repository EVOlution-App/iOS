//
//  ProposalListHeaderTableViewCell.swift
//  swift-evolution
//
//  Created by Diego Ventura on 25/03/2017.
//  Copyright © 2017 Holanda Mobile. All rights reserved.
//

import Foundation
import UIKit

final class ProposalListHeaderTableViewCell: UITableViewCell {
    
    // MARK: - Outlets
    
    @IBOutlet private weak var proposalsCountLabel: UILabel!
    
    // MARK: - Internal Attributes
    
    var proposalCount: Int = 0 {
        didSet {
            proposalsCountLabel.text = "\(proposalCount) proposals"
        }
    }
    
    var header: String? = "" {
        didSet {
            proposalsCountLabel.text = header
        }
    }
    
}
