//
//  QAViewController.swift
//  TheInterviewer
//
//  Created by Athos Lagemann on 19/08/19.
//  Copyright © 2019 Athos Lagemann. All rights reserved.
//

import UIKit

protocol QAViewControllerDelegate: class {
    func didFinishAnswer(_ viewController: QAViewController, index: Index, answer: String?)
}

final class QAViewController: UIViewController {
    
    @IBOutlet private weak var progressView: UIProgressView!
    @IBOutlet private weak var progressLabel: UILabel!
    @IBOutlet private weak var questionLabel: UILabel!
    @IBOutlet private weak var textView: UITextView!
    
    private let questionIndex: Index
    private let pair: QuestionPair
    private let progress: Float?
    
    weak var delegate: QAViewControllerDelegate?
    
    init(pair: QuestionPair, index: Index, progress: Float? = nil) {
        self.pair = pair
        self.questionIndex = index
        self.progress = progress
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        
        textView.delegate = self
        
        if let prog = progress {
            progressView.progress = prog
            progressLabel.text = "\(prog * 100)%"
        } else {
            progressView.isHidden = true
            progressLabel.isHidden = true
        }
        
        questionLabel.text = pair.question
        textView.text = pair.answer
    }
    
    private func configureUI() {
        hideKeyboardWhenTappedAround()
        
        // Progress
        progressView.progressTintColor = AppConfiguration.mainColor
        progressLabel.textColor = AppConfiguration.mainColor
        progressLabel.font = UIFont(SFPro: .display, variant: .medium, size: 22)
        
        // Question
        questionLabel.font = UIFont(SFPro: .text, variant: .medium, size: 26)
        
        // Answer
        textView.font = UIFont(SFPro: .text, variant: .regular, size: 20)
        textView.textAlignment = .justified
        textView.layer.borderWidth = 1.0
        textView.layer.borderColor = UIColor.lightGray.cgColor
        textView.layer.cornerRadius = 6.0
    }
    
    @objc
    private func showKeyboard(_ notification: NSNotification) {
        // code
    }
    
    @objc
    private func hideKeyboard(_ notification: NSNotification) {
        // code
    }
    
    @objc
    private func nextTapped() {
        delegate?.didFinishAnswer(self, index: questionIndex, answer: textView.text)
    }
    
    @IBAction private func didTapNext(_ sender: UIButton) {
        delegate?.didFinishAnswer(self, index: questionIndex, answer: textView.text)
    }
}

extension QAViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        // updateConstraints
        
        let bar = UIToolbar()
        let reset = UIBarButtonItem(title: "Próximo", style: .plain, target: self, action: #selector(nextTapped))
        
        bar.items = [reset]
        bar.sizeToFit()
        
        textView.inputAccessoryView = bar
    }
}
