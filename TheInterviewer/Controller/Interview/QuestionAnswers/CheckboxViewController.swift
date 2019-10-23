//
//  CheckboxViewController.swift
//  TheInterviewer
//
//  Created by Athos Lagemann on 14/10/19.
//  Copyright © 2019 Athos Lagemann. All rights reserved.
//

import UIKit

protocol CheckboxDelegate: class {
    func didTapBack(_ viewController: CheckboxViewController, answer: String?)
    func didComplete(_ viewController: CheckboxViewController, answer: String)
}

struct CheckboxViewControllerConfiguration {
    let calloutText: String
    let mode: Mode
    let answer1: String
    let answer2: String
}

final class CheckboxViewController: UIViewController {
    @IBOutlet private weak var partProgressionLabel: UILabel!
    @IBOutlet private weak var sectionProgressionLabel: UILabel!
    @IBOutlet private weak var calloutLabel: UILabel!
    @IBOutlet private weak var checkboxButton: UIButton!
    @IBOutlet private weak var checkboxButton2: UIButton!
    @IBOutlet private weak var optionText: UILabel!
    @IBOutlet private weak var optionText2: UILabel!
    @IBOutlet private weak var nextButton: UIButton!
    
    private let configuration: CheckboxViewControllerConfiguration
    private var viewModel: InterviewViewModel
    private var index: Index
    private var checked: (first: Bool, second: Bool) {
        didSet {
            updateNextButtonStatus()
            updateCheckboxes()
        }
    }
    
    weak var delegate: CheckboxDelegate?
    
    init(viewModel: InterviewViewModel, index: Index, checked: (Bool, Bool), configuration: CheckboxViewControllerConfiguration) {
        self.viewModel = viewModel
        self.index = index
        self.checked = checked
        self.configuration = configuration
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        updateNextButtonStatus()
        updateCheckboxes()
        
        let titles = viewModel.titles(for: index)
        partProgressionLabel.text = titles.part
        sectionProgressionLabel.text = titles.section
    }
    
    private func configureUI() {
        // fonts
        partProgressionLabel.font = UIFont(SFPro: .display, variant: .medium, size: 26)
        sectionProgressionLabel.font = UIFont(SFPro: .display, variant: .medium, size: 24)
        calloutLabel.font = UIFont(SFPro: .text, variant: .medium, size: 24)
        optionText.font = UIFont(SFPro: .text, variant: .regular, size: 20)
        optionText2.font = UIFont(SFPro: .text, variant: .regular, size: 20)
        
        // texts
        calloutLabel.text = configuration.calloutText
        optionText.text = configuration.answer1
        optionText2.text = configuration.answer2
        
        // checks
        checkboxButton.layer.borderColor = UIColor.black.cgColor
        checkboxButton.layer.borderWidth = 0.5
        checkboxButton.layer.cornerRadius = checkboxButton.layer.bounds.height / 2
        
        checkboxButton2.layer.borderColor = UIColor.black.cgColor
        checkboxButton2.layer.borderWidth = 0.5
        checkboxButton2.layer.cornerRadius = checkboxButton2.layer.bounds.height / 2
        
        // button
        nextButton.setTitleColor(.black, for: .normal)
        nextButton.setTitleColor(.gray, for: .disabled)
        nextButton.setTitle("Próximo", for: .normal)
    }
    
    @IBAction func didTapCheck(_ sender: UIButton) {
        checked.first.toggle()
        checked.second = false
    }
    
    @IBAction func didTapCheck2(_ sender: UIButton) {
        checked.first = false
        checked.second.toggle()
    }
    
    @IBAction private func didTapNext(_ sender: UIButton) {
        let ans: String
            
        if checked.first {
            ans = configuration.answer1
        } else {
            ans = configuration.answer2
        }

        delegate?.didComplete(self, answer: ans)
    }
    
    private func updateNextButtonStatus() {
        nextButton.isEnabled = xor(checked.first, checked.second)
    }
    
    private func updateCheckboxes() {
        checkboxButton.backgroundColor = checked.first ? AppConfiguration.mainColor : .white
        checkboxButton2.backgroundColor = checked.second ? AppConfiguration.mainColor : .white
    }
}
