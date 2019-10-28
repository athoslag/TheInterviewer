//
//  CheckboxViewController.swift
//  TheInterviewer
//
//  Created by Athos Lagemann on 14/10/19.
//  Copyright © 2019 Athos Lagemann. All rights reserved.
//

import UIKit

protocol CheckboxDelegate: class {
    func didTapExit(_ viewController: CheckboxViewController)
    func didTapOverview(_ viewController: CheckboxViewController)
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
    @IBOutlet private weak var optionText: UIButton!
    @IBOutlet private weak var optionText2: UIButton!
    @IBOutlet private weak var nextButton: UIButton!
    
    private let configuration: CheckboxViewControllerConfiguration
    private var checked: (first: Bool, second: Bool) {
        didSet {
            updateNextButtonStatus()
            updateCheckboxes()
        }
    }
    
    weak var delegate: CheckboxDelegate?
    
    init(checked: (Bool, Bool), configuration: CheckboxViewControllerConfiguration) {
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
        
        partProgressionLabel.text = ""
        sectionProgressionLabel.text = ""
        
    }
    
    private func configureUI() {
        // navigation
        navigationController?.navigationBar.setupNavigationBar()
        
        let backButton = UIButton(type: .custom)
        backButton.setTitle("Sair", for: .normal)
        backButton.setTitleColor(.black, for: .normal)
        backButton.addTarget(self, action: #selector(tapBack(sender:)), for: .touchUpInside)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
        
        let item = UIBarButtonItem(title: "Menu", style: .plain, target: self, action: #selector(tapOverview(sender:)))
        navigationItem.setRightBarButton(item, animated: false)
        navigationItem.hidesBackButton = true
        
        // fonts
        partProgressionLabel.font = UIFont(SFPro: .display, variant: .medium, size: 26)
        sectionProgressionLabel.font = UIFont(SFPro: .display, variant: .medium, size: 24)
        calloutLabel.font = UIFont(SFPro: .text, variant: .medium, size: 24)
        optionText.titleLabel?.font = UIFont(SFPro: .text, variant: .regular, size: 20)
        optionText2.titleLabel?.font = UIFont(SFPro: .text, variant: .regular, size: 20)

        optionText.setTitleColor(.black, for: .normal)
        optionText2.setTitleColor(.black, for: .normal)
        
        // texts
        calloutLabel.text = configuration.calloutText
        optionText.setTitle(configuration.answer1, for: .normal)
        optionText2.setTitle(configuration.answer2, for: .normal)
        
        // checks
        checkboxButton.layer.borderColor = UIColor.black.cgColor
        checkboxButton.layer.borderWidth = 0.5
        checkboxButton.layer.cornerRadius = checkboxButton.layer.bounds.height / 2
        checkboxButton.isEnabled = configuration.mode == .edition
        
        checkboxButton2.layer.borderColor = UIColor.black.cgColor
        checkboxButton2.layer.borderWidth = 0.5
        checkboxButton2.layer.cornerRadius = checkboxButton2.layer.bounds.height / 2
        checkboxButton2.isEnabled = configuration.mode == .edition
        
        // button
        nextButton.setTitleColor(.black, for: .normal)
        nextButton.setTitleColor(.gray, for: .disabled)
        nextButton.setTitle("Próximo", for: .normal)
    }
    
    // MARK: - Actions
    @objc
    private func tapBack(sender: Any) {
        delegate?.didTapExit(self)
    }
    
    @objc
    private func tapOverview(sender: Any) {
        delegate?.didTapOverview(self)
    }
    
    @IBAction private func didTapCheck(_ sender: UIButton) {
        tapCheck1()
    }
    
    @IBAction private func didTapCheckText(_ sender: UIButton) {
        tapCheck1()
    }
    
    @IBAction private func didTapCheck2(_ sender: UIButton) {
        tapCheck2()
    }
    
    @IBAction private func didTapCheckText2(_ sender: UIButton) {
        tapCheck2()
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
    
    private func tapCheck1() {
        checked.first.toggle()
        checked.second = false
    }
    
    private func tapCheck2() {
        checked.first = false
        checked.second.toggle()
    }
    
    // MARK: - Updates
    private func updateNextButtonStatus() {
        nextButton.isEnabled = xor(checked.first, checked.second)
    }
    
    private func updateCheckboxes() {
        checkboxButton.backgroundColor = checked.first ? AppConfiguration.mainColor : .white
        checkboxButton2.backgroundColor = checked.second ? AppConfiguration.mainColor : .white
    }
}
