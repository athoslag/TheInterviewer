//
//  FinalScreenViewController.swift
//  TheInterviewer
//
//  Created by Athos Lagemann on 11/09/19.
//  Copyright © 2019 Athos Lagemann. All rights reserved.
//

import UIKit

protocol FinalScreenDelegate: class {
    func didTapShare(_ viewController: FinalScreenViewController)
    func didTapSave(_ viewController: FinalScreenViewController)
    func didTapDiscard(_ viewController: FinalScreenViewController)
}

final class FinalScreenViewController: UIViewController {
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var shareButton: UIButton!
    @IBOutlet private weak var saveButton: UIButton!
    @IBOutlet private weak var discardButton: UIButton!
    
    private let viewModel: InterviewViewModel
    weak var delegate: FinalScreenDelegate?
    
    init(viewModel: InterviewViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLabel.text = viewModel.title
        tableView.dataSource = self
        
        setupUI()
    }
    
    private func setupUI() {
        // Navigation
        navigationController?.setNavigationBarHidden(true, animated: false)
        
        // Title
        titleLabel.font = UIFont(SFPro: .display, variant: .medium, size: 24)
        
        // TableView
        tableView.allowsSelection = false
        tableView.tableFooterView = UIView()
        
        // Share
        shareButton.setTitleColor(.white, for: .normal)
        shareButton.backgroundColor = AppConfiguration.mainColor
        shareButton.layer.cornerRadius = shareButton.layer.bounds.height / 2
        shareButton.titleLabel?.font = UIFont(SFPro: .text, variant: .regular, size: 18)
        
        // Save
        saveButton.setTitleColor(.blue, for: .normal)
        saveButton.layer.cornerRadius = saveButton.layer.bounds.height / 2
        saveButton.titleLabel?.font = UIFont(SFPro: .text, variant: .regular, size: 18)
        saveButton.layer.borderColor = UIColor.darkGray.cgColor
        saveButton.layer.borderWidth = 0.5
        
        // Exit
        discardButton.setTitleColor(.red, for: .normal)
        discardButton.layer.cornerRadius = discardButton.layer.bounds.height / 2
        discardButton.titleLabel?.font = UIFont(SFPro: .text, variant: .regular, size: 18)
        discardButton.layer.borderColor = UIColor.darkGray.cgColor
        discardButton.layer.borderWidth = 0.5
    }
}

// MARK - Actions
extension FinalScreenViewController {
    @IBAction private func didTapShare(_ sender: UIButton) {
        delegate?.didTapShare(self)
    }
    
    @IBAction private func didTapSave(_ sender: UIButton) {
        delegate?.didTapSave(self)
    }
    
    @IBAction private func didTapDiscard(_ sender: UIButton) {
        delegate?.didTapDiscard(self)
    }
}

// MARK - TableView
extension FinalScreenViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.numberOfParts
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfSections(part: section)
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return viewModel.partTitle(part: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let sectionTitle = viewModel.sectionTitle(part: indexPath.section, section: indexPath.row)
        let total = Double(viewModel.sections[indexPath.row].questionPairs.count)
        let answered = Double(viewModel.sections[indexPath.row].questionPairs.filter{ !($0.answer?.isEmpty ?? true) }.count)
        let percentage = Double((answered / total) * 100).format(f: ".0")
        let sectionDetail = "\(percentage)% respondida"
        
        let cell: UITableViewCell
        
        if let dequeued = tableView.dequeueReusableCell(withIdentifier: "FinalScreen") {
            cell = dequeued
        } else {
            cell = UITableViewCell(style: .subtitle, reuseIdentifier: "FinalScreen")
        }
        
        cell.textLabel?.text = sectionTitle
        cell.detailTextLabel?.text = sectionDetail
        
        return cell
    }
}
