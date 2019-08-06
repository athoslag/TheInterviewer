//
//  MainInterviewViewController.swift
//  TheInterviewer
//
//  Created by Athos Lagemann on 06/08/19.
//  Copyright © 2019 Athos Lagemann. All rights reserved.
//

import UIKit

final class MainInterviewViewController: UIViewController {

    @IBOutlet private weak var progressBar: UIProgressView!
    @IBOutlet private weak var progressLabel: UILabel!
    @IBOutlet private weak var informationLabel: UILabel!
    
    private let progress: Float
    private let question: String
    private var answer: String?
    
    init(progress: Float, question: String, answer: String?) {
        self.progress = progress
        self.question = question
        self.answer = answer
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        
        progressBar.progress = progress
        progressLabel.text = "\(Int(progress * 100))%"
        
        informationLabel.text = question
    }
    
    private func configureUI() {
        // Progress
        progressBar.progressTintColor = AppConfiguration.mainColor.color
        progressLabel.textColor = AppConfiguration.mainColor.color
        progressLabel.font = UIFont(SFPro: .display, variant: .medium, size: 22)
        
        // Information
        informationLabel.font = UIFont(SFPro: .text, variant: .medium, size: 26)
    }
}

