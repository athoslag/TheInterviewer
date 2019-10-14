//
//  CheckboxViewController.swift
//  TheInterviewer
//
//  Created by Athos Lagemann on 14/10/19.
//  Copyright © 2019 Athos Lagemann. All rights reserved.
//

import UIKit

protocol CheckboxDelegate: class {
    func didComplete(_ viewController: CheckboxViewController, answer: Bool)
}

struct CheckboxViewControllerConfiguration {
    let index: Index
    let calloutText: String
    let optionText: String
}

final class CheckboxViewController: UIViewController {
    @IBOutlet private weak var partProgressionLabel: UILabel!
    @IBOutlet private weak var sectionProgressionLabel: UILabel!
    @IBOutlet private weak var calloutLabel: UILabel!
    @IBOutlet private weak var optionText: UILabel!
    @IBOutlet private weak var nextButton: UIButton!
    
    private let configuration: CheckboxViewControllerConfiguration
    private var checkbox: Checkbox
    
    weak var delegate: CheckboxDelegate?
    
    init(configuration: CheckboxViewControllerConfiguration) {
        self.checkbox = Checkbox(style: .rounded, checked: false)
        self.configuration = configuration
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    private func configureUI() {
        // TODO: find correct fonts
        partProgressionLabel.font = UIFont(SFPro: .display, variant: .medium, size: 22)
        sectionProgressionLabel.font = UIFont(SFPro: .display, variant: .medium, size: 22)
        calloutLabel.font = UIFont(SFPro: .text, variant: .regular, size: 22)
        optionText.font = UIFont(SFPro: .text, variant: .regular, size: 22)
        
        // texts
        calloutLabel.text = configuration.calloutText
        optionText.text = configuration.optionText
        
        // button
        nextButton.titleLabel?.font = UIFont(SFPro: .text, variant: .medium, size: 22)
        nextButton.setTitleColor(.black, for: .normal)
        nextButton.setTitle("Próximo", for: .normal)
    }
    
    @IBAction private func didTapNext(_ sender: UIButton) {
        delegate?.didComplete(self, answer: checkbox.isChecked)
    }
}
