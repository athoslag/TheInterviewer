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
    
    @IBOutlet private weak var partProgressionLabel: UILabel!
    @IBOutlet private weak var sectionProgressionLabel: UILabel!
    @IBOutlet private weak var questionLabel: UILabel!
    @IBOutlet private weak var textView: UITextView!
    private var tabAccessoryView: UIToolbar?
    
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
        
        // Part & Section indicator
        let titles = viewModel.titles(for: questionIndex)
        partProgressionLabel.text = titles.part
        sectionProgressionLabel.text = titles.section
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        textView.becomeFirstResponder()
    }
    
    private func configureUI() {
        hideKeyboardWhenTappedAround()
        // Progression
        partProgressionLabel.font = UIFont(SFPro: .display, variant: .medium, size: 26)
        sectionProgressionLabel.font = UIFont(SFPro: .display, variant: .medium, size: 24)
        
        // Question
        questionLabel.font = UIFont(SFPro: .text, variant: .medium, size: 24)
        
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
        nextTapped()
    }
}

extension QALongViewController: UITextViewDelegate {
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        if tabAccessoryView == nil {
            tabAccessoryView = UIToolbar(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 44))
            
            let barSpacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
            let barNext = UIBarButtonItem(title: "Próximo", style: .plain, target: self, action: #selector(nextTapped))
            barNext.tintColor = .black
            
            tabAccessoryView?.items = [barSpacer, barNext]
            textView.inputAccessoryView = tabAccessoryView
        }
        return true
    }
}