//
//  QAViewController.swift
//  TheInterviewer
//
//  Created by Athos Lagemann on 19/08/19.
//  Copyright © 2019 Athos Lagemann. All rights reserved.
//

import UIKit

protocol QAViewControllerDelegate: class {
    func didFinishAnswer(_ viewController: QAViewController, answer: String?)
}

final class QAViewController: UIViewController {
    
    @IBOutlet private weak var progressView: UIProgressView!
    @IBOutlet private weak var progressLabel: UILabel!
    @IBOutlet private weak var questionLabel: UILabel!
    @IBOutlet private weak var answerTextField: UITextField!
    @IBOutlet private weak var textFieldBottomConstraint: NSLayoutConstraint!
    
    private let pair: QuestionPair
    private let progress: Float?
    
    weak var delegate: QAViewControllerDelegate?
    
    init(pair: QuestionPair, progress: Float? = nil) {
        self.pair = pair
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
        answerTextField.text = pair.answer
    }
    
    private func configureUI() {
        // setup progress
        
        // setup question
        
        // setup answer
        
    }
    
    @objc
    func showKeyboard(_ notification: NSNotification) {
        
    }
    
    @objc
    func hideKeyboard(_ notification: NSNotification) {
        
    }
}

extension QAViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        delegate?.didFinishAnswer(self, answer: textField.text)
    }
}
