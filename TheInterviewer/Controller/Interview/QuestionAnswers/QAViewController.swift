//
//  QAViewController.swift
//  TheInterviewer
//
//  Created by Athos Lagemann on 19/08/19.
//  Copyright © 2019 Athos Lagemann. All rights reserved.
//

import UIKit

protocol QAViewControllerDelegate: class {
    func didFinishAnswer(_ viewController: QAViewController, viewModel: InterviewViewModel, index: Index)
}

final class QAViewController: UIViewController {
    @IBOutlet private weak var questionLabel: UILabel!
    @IBOutlet private weak var textField: UITextField!
    
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
        
        if let pair = viewModel.questionPair(for: questionIndex) {
            questionLabel.text = pair.question
            textField.text = pair.answer
        }
    }
    
    private func configureUI() {
        hideKeyboardWhenTappedAround()
        
        // Question
        questionLabel.font = UIFont(SFPro: .text, variant: .medium, size: 26)
        
        // Answer
        textField.font = UIFont(SFPro: .text, variant: .regular, size: 20)
        textField.keyboardType = answerType == .number ? .decimalPad : .default
        textField.textAlignment = .justified
        textField.layer.borderWidth = 1.0
        textField.layer.borderColor = UIColor.lightGray.cgColor
        textField.layer.cornerRadius = 6.0
    }
    
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
