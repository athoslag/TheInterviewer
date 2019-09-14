//
//  QAViewController.swift
//  TheInterviewer
//
//  Created by Athos Lagemann on 19/08/19.
//  Copyright © 2019 Athos Lagemann. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField

protocol QAViewControllerDelegate: class {
    func didTapBack(_ viewController: QAViewController, viewModel: InterviewViewModel)
    func didFinishAnswer(_ viewController: QAViewController, viewModel: InterviewViewModel, index: Index)
}

final class QAViewController: UIViewController {
    @IBOutlet private weak var partProgressionLabel: UILabel!
    @IBOutlet private weak var sectionProgressionLabel: UILabel!
    @IBOutlet private weak var questionLabel: UILabel!
    @IBOutlet private weak var textField: SkyFloatingLabelTextField!
    private var tabAccessoryView: UIToolbar?
    
    private let answerType: AnswerType
    private let questionIndex: Index
    private let viewModel: InterviewViewModel
    
    weak var delegate: QAViewControllerDelegate?
    
    init(viewModel: InterviewViewModel, index: Index, answerType: AnswerType) {
        self.viewModel = viewModel
        self.questionIndex = index
        self.answerType = answerType
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        
        textField.delegate = self
        
        if let pair = viewModel.questionPair(for: questionIndex) {
            questionLabel.text = pair.question
            textField.text = pair.answer
        }
        
        // Part & Section indicator
        let titles = viewModel.titles(for: questionIndex)
        partProgressionLabel.text = titles.part
        sectionProgressionLabel.text = titles.section
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        textField.becomeFirstResponder()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        delegate?.didTapBack(self, viewModel: viewModel)
    }
    
    private func configureUI() {
        hideKeyboardWhenTappedAround()
        // Progression
        partProgressionLabel.font = UIFont(SFPro: .display, variant: .medium, size: 26)
        sectionProgressionLabel.font = UIFont(SFPro: .display, variant: .medium, size: 24)
        
        // Question
        questionLabel.font = UIFont(SFPro: .text, variant: .medium, size: 24)
        
        // Answer
        textField.font = UIFont(SFPro: .text, variant: .regular, size: 20)
        textField.keyboardType = answerType == .number ? .decimalPad : .default
        textField.autocapitalizationType = answerType == .name ? .words : .sentences
        textField.textAlignment = .justified
        textField.borderStyle = .none
        textField.selectedLineColor = AppConfiguration.mainColor
    }
    
}

// MARK: - Actions
extension QAViewController {
    @objc
    private func finishAnswer() {
        viewModel.updateAnswer(textField.text, for: questionIndex)
        delegate?.didFinishAnswer(self, viewModel: viewModel, index: questionIndex)
    }
        
    @IBAction private func didTapNext(_ sender: UIButton) {
        finishAnswer()
    }
    
    @IBAction func textFieldDidEnd(_ sender: UITextField) {
        textField.resignFirstResponder()
        finishAnswer()
    }
}

// MARK: - TextField Delegate
extension QAViewController: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if tabAccessoryView == nil {
            tabAccessoryView = UIToolbar(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 44))
            
            let barSpacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
            let barNext = UIBarButtonItem(title: "Próximo", style: .plain, target: self, action: #selector(finishAnswer))
            barNext.tintColor = .black
            
            tabAccessoryView?.items = [barSpacer, barNext]
            textField.inputAccessoryView = tabAccessoryView
        }
        return true
    }
}
