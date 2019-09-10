//
//  OverviewViewController.swift
//  TheInterviewer
//
//  Created by Athos Lagemann on 06/08/19.
//  Copyright © 2019 Athos Lagemann. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField

protocol OverviewDelegate: class {
    func didSelect(_ viewController: OverviewViewController, index: Index)
    func shouldDismiss(_ viewController: OverviewViewController)
}

final class OverviewViewController: UIViewController {

    @IBOutlet private weak var titleTextField: SkyFloatingLabelTextField!
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var actionButton: UIButton!
    
    private let viewModel: InterviewViewModel
    weak var delegate: OverviewDelegate?
    
    init(interviewVM: InterviewViewModel) {
        self.viewModel = interviewVM
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        
        titleTextField.delegate = self
        titleTextField.text = viewModel.title
        
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewModel.describeInterview()
    }
    
    private func configureUI() {
        // Information
        titleTextField.font = UIFont(SFPro: .text, variant: .medium, size: 26)
        titleTextField.selectedLineColor = AppConfiguration.mainColor
        
        // Tableview
        tableView.tableFooterView = UIView()
        
        // Begin Button
        actionButton.layer.cornerRadius = actionButton.layer.bounds.height / 2
        actionButton.backgroundColor = AppConfiguration.mainColor
        actionButton.setTitleColor(.white, for: .normal)
        actionButton.titleLabel?.font = UIFont(SFPro: .display, variant: .medium, size: 22)
        // TODO: Apropriate action button title
        
        addBackButton()
    }
    
    private func addBackButton() {
        let backButton = UIButton(type: .custom)
        backButton.setTitle("Voltar", for: .normal)
        backButton.setTitleColor(.black, for: .normal)
        backButton.addTarget(self, action: #selector(backTapped), for: .touchUpInside)
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
    }
    
    @objc
    private func backTapped() {
        delegate?.shouldDismiss(self)
    }
    
    @IBAction func didTapActionButton(_ sender: UIButton) {
        delegate?.didSelect(self, index: Index(part: 0, section: 0, row: 0))
    }
}

extension OverviewViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.numberOfParts
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfSections(part: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let part = indexPath.section
        let section = indexPath.row
        
        let cell = UITableViewCell(style: .default, reuseIdentifier: "reuseID")
        cell.textLabel?.text = "\(viewModel.sectionTitle(part: part, section: section)): \(viewModel.numberOfQuestions(section: section, part: part)) itens"
        cell.textLabel?.font = UIFont(SFPro: .text, variant: .medium, size: 20)
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return viewModel.partTitles[section]
    }
}

extension OverviewViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.didSelect(self, index: Index(part: indexPath.section, section: indexPath.row, row: 0))
    }
}

extension OverviewViewController: UITextFieldDelegate {
    @IBAction func textFieldDidEnd(_ sender: SkyFloatingLabelTextField) {
        titleTextField.resignFirstResponder()
        
        guard let newTitle = titleTextField.text, !newTitle.isEmpty else {
            titleTextField.text = viewModel.title
            return
        }
        
        let save = viewModel.saveInterview()
        print("Tried to save the interview: \(save ? "worked" : "failed")")
        
        viewModel.updateTitle(newTitle)
    }
}
