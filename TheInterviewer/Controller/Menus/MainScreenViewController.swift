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
    func didTapReview(_ mainScreen: MainScreenViewController)
}

final class MainScreenViewController: UIViewController {
    
    @IBOutlet private weak var calloutLabel: UILabel!
    @IBOutlet private weak var newInterviewButton: UIButton!
    @IBOutlet private weak var reviewInterviewButton: UIButton!
    
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
        calloutLabel.text = "The Interviewer"
        
        if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
            calloutLabel.text?.append(" v\(version)")
        }
        
        // Buttons
        newInterviewButton.titleLabel?.font = UIFont(SFPro: .text, variant: .semibold, size: 18)
        newInterviewButton.setTitleColor(.white, for: .normal)
        newInterviewButton.layer.cornerRadius = newInterviewButton.bounds.height / 2
        
        reviewInterviewButton.titleLabel?.font = UIFont(SFPro: .text, variant: .semibold, size: 18)
        reviewInterviewButton.setTitleColor(.white, for: .normal)
        reviewInterviewButton.layer.cornerRadius = reviewInterviewButton.bounds.height / 2
    }
}

// MARK: Actions
extension MainScreenViewController {
    @IBAction private func didTapNew(_ sender: UIButton) {
        delegate?.didTapNew(self)
    }
    
    @IBAction private func didTapReview(_ sender: UIButton) {
        delegate?.didTapReview(self)
    }
}
