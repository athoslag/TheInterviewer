//
//  FinalScreenViewController.swift
//  TheInterviewer
//
//  Created by Athos Lagemann on 11/09/19.
//  Copyright © 2019 Athos Lagemann. All rights reserved.
//

import UIKit

final class FinalScreenViewController: UIViewController {

    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var shareButton: UIButton!
    @IBOutlet private weak var saveButton: UIButton!
    @IBOutlet private weak var exitButton: UIButton!
    
    let viewModel: InterviewViewModel
    
    init(viewModel: InterviewViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        
        setupUI()
    }
    
    private func setupUI() {
        
    }
}

// MARK - Actions
extension FinalScreenViewController {
    @IBAction private func didTapShare(_ sender: UIButton) {
    
    }
    
    @IBAction private func didTapSave(_ sender: UIButton) {
    
    }
    
    @IBAction private func didTapExit(_ sender: UIButton) {
    
    }
}

// MARK - TableView
extension FinalScreenViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
}
