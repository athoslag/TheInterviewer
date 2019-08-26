//
//  QAViewController.swift
//  TheInterviewer
//
//  Created by Athos Lagemann on 19/08/19.
//  Copyright © 2019 Athos Lagemann. All rights reserved.
//

import UIKit

protocol QAViewControllerDelegate: class {
    func didFinishAnswer(_ viewController: QAViewController, index: Int, answer: String?)
}

final class QAViewController: UIViewController {
    
    @IBOutlet private weak var progressView: UIProgressView!
    @IBOutlet private weak var progressLabel: UILabel!
    @IBOutlet private weak var questionLabel: UILabel!
    @IBOutlet private weak var textView: UITextView!
    
    private let questionIndex: Int
    private let pair: QuestionPair
    private let progress: Float?
    
    weak var delegate: QAViewControllerDelegate?
    
    init(pair: QuestionPair, index: Int, progress: Float? = nil) {
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
        
        NotificationCenter.default.addObserver(self, selector: #selector(showKeyboard(_:)), name: UIWindow.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(hideKeyboard(_:)), name: UIWindow.keyboardDidHideNotification, object: nil)
        
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
    func showKeyboard(_ notification: NSNotification) {
        // code
    }
    
    @objc
    func hideKeyboard(_ notification: NSNotification) {
        // code
    }
}

extension QAViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        delegate?.didFinishAnswer(self, index: questionIndex, answer: textField.text)
    }
}
