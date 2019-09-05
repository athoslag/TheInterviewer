//
//  QALongViewController.swift
//  TheInterviewer
//
//  Created by Athos Lagemann on 03/09/19.
//  Copyright © 2019 Athos Lagemann. All rights reserved.
//

import UIKit

protocol QALongViewControllerDelegate: class {
    func didFinishAnswer(_ viewController: QALongViewController, viewModel: InterviewViewModel, index: Index)
}

final class QALongViewController: UIViewController {
    
    @IBOutlet private weak var questionLabel: UILabel!
    @IBOutlet private weak var textView: UITextView!
    
    private let questionIndex: Index
    private let viewModel: InterviewViewModel
    
    weak var delegate: QALongViewControllerDelegate?
    
    init(viewModel: InterviewViewModel, index: Index) {
        self.viewModel = viewModel
        self.questionIndex = index
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        
        textView.delegate = self
        
        if let pair = viewModel.questionPair(for: questionIndex) {
            questionLabel.text = pair.question
            textView.text = pair.answer            
        }
    }
    
    private func configureUI() {
        hideKeyboardWhenTappedAround()
        
        // Question
        questionLabel.font = UIFont(SFPro: .text, variant: .medium, size: 26)
        
        // Answer
        textView.font = UIFont(SFPro: .text, variant: .regular, size: 20)
        textView.textAlignment = .justified
        textView.autocapitalizationType = .sentences
        textView.layer.borderWidth = 1.0
        textView.layer.borderColor = UIColor.lightGray.cgColor
        textView.layer.cornerRadius = 6.0
    }
    
    @objc
    private func nextTapped() {
        viewModel.updateAnswer(textView.text, for: questionIndex)
        delegate?.didFinishAnswer(self, viewModel: viewModel, index: questionIndex)
    }
    
    @IBAction private func didTapNext(_ sender: UIButton) {
        viewModel.updateAnswer(textView.text, for: questionIndex)
        delegate?.didFinishAnswer(self, viewModel: viewModel, index: questionIndex)
    }
}

extension QALongViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        // FIXME: Add keyboard toolbar properly (not working)
        
        let bar = UIToolbar()
        let reset = UIBarButtonItem(title: "Próximo", style: .plain, target: self, action: #selector(nextTapped))
        
        bar.items = [reset]
        bar.sizeToFit()
        
        textView.inputAccessoryView = bar
    }
}
