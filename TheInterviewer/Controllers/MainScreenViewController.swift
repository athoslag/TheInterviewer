//
//  MainScreenViewController.swift
//  TheInterviewer
//
//  Created by Athos Lagemann on 19/06/19.
//  Copyright © 2019 Athos Lagemann. All rights reserved.
//

import UIKit

protocol MainScreenDelegate: class {
    func didTapNew(_ mainScreen: MainScreenViewController)
}

final class MainScreenViewController: UIViewController {
    
    @IBOutlet private weak var calloutLabel: UILabel!
    @IBOutlet private weak var newInterviewButton: UIButton!
    
    weak var delegate: MainScreenDelegate?
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    private func configureUI() {
        // Callout
        calloutLabel.font = UIFont(SFPro: .display, variant: .medium, size: 30)
        
        // Buttons
        newInterviewButton.titleLabel?.font = UIFont(SFPro: .text, variant: .medium, size: 18)
        newInterviewButton.setTitleColor(AppConfiguration.mainColor.color, for: .normal)
        newInterviewButton.layer.cornerRadius = newInterviewButton.bounds.height / 2
        newInterviewButton.layer.borderWidth = 1.5
        newInterviewButton.layer.borderColor = AppConfiguration.mainColor.cgColor
    }
}

// MARK: Actions
extension MainScreenViewController {
    @IBAction private func didTapNew(_ sender: UIButton) {
        delegate?.didTapNew(self)
    }
}
