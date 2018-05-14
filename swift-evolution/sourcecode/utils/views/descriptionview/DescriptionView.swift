//
//  DescriptionView.swift
//  swift-evolution
//
//  Created by Thiago Holanda on 12.05.18.
//  Copyright © 2018 Holanda Mobile. All rights reserved.
//

import UIKit

protocol DescriptionViewProtocol: class {
    func closeAction()
}

final class DescriptionView: UIView {

    @IBOutlet private weak var versionLabel: UILabel!
    @IBOutlet private weak var appNameLabel: UILabel!
    @IBOutlet private weak var logoImageView: UIImageView!
    @IBOutlet private weak var closeButton: UIButton!
    
    weak var delegate: DescriptionViewProtocol?
    
    override func draw(_ rect: CGRect) {
        if let version = Environment.Release.version,
            let build = Environment.Release.build {
            
            self.versionLabel.text = "v\(version) (\(build))"
        }
        
        
        closeButton.isHidden = UIDevice.current.userInterfaceIdiom != .pad
    }
    
    @IBAction private func dismiss(_ sender: UIButton) {
        delegate?.closeAction()
    }
}
