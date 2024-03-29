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
    func shouldFinalize(_ viewController: OverviewViewController)
    func shouldDismiss(_ viewController: OverviewViewController)
}

final class OverviewViewController: UIViewController {
    @IBOutlet private weak var titleTextField: SkyFloatingLabelTextField!
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var actionButton: UIButton!
    
    private let viewModel: InterviewViewModel
    private let canEditTitle: Bool
    weak var delegate: OverviewDelegate?
    
    init(interviewVM: InterviewViewModel, canEditTitle: Bool) {
        self.viewModel = interviewVM
        self.canEditTitle = canEditTitle
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleTextField.delegate = self
        titleTextField.text = viewModel.title
        
        tableView.dataSource = self
        tableView.delegate = self
        
        configureUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tableView.indexPathsForSelectedRows?.forEach({ indexPath in
            tableView.deselectRow(at: indexPath, animated: false)
        })
    }
    
    // MARK: - UI
    private func configureUI() {
        // Navigation
        navigationController?.navigationBar.setupNavigationBar()
        if !canEditTitle {
            navigationItem.title = titleTextField.text
        }
        
        // Information
        titleTextField.font = UIFont(SFPro: .text, variant: .medium, size: 26)
        titleTextField.selectedLineColor = AppConfiguration.mainColor
        titleTextField.isHidden = !canEditTitle
        
        // Tableview
        tableView.tableFooterView = UIView()
        
        // Begin Button
        actionButton.layer.cornerRadius = actionButton.layer.bounds.height / 2
        actionButton.setTitleColor(.white, for: .normal)
        actionButton.setTitleColor(.white, for: .disabled)
        actionButton.titleLabel?.font = UIFont(SFPro: .display, variant: .medium, size: 22)
        
        // Navigation buttons & states
        addBackButton()
        addFinalizeButton()
        updateButtonState(titleTextField.text?.isEmpty)
    }
    
    private func addBackButton() {
        let backButton = UIButton(type: .custom)
        backButton.setTitle("Sair", for: .normal)
        backButton.setTitleColor(.black, for: .normal)
        backButton.addTarget(self, action: #selector(backTapped), for: .touchUpInside)
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
    }
    
    private func addFinalizeButton() {
        let finalizeButton = UIButton(type: .custom)
        finalizeButton.setTitle("Finalizar", for: .normal)
        finalizeButton.setTitleColor(.black, for: .normal)
        finalizeButton.addTarget(self, action: #selector(finalizeTapped), for: .touchUpInside)
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: finalizeButton)
    }
    
    private func updateButtonState(_ disabled: Bool?) {
        actionButton.isEnabled = !(disabled ?? true)
        actionButton.backgroundColor = !(disabled ?? true) ? AppConfiguration.mainColor : .lightGray
    }
    
    private func proceedWithInterview(index: Index) {
        delegate?.didSelect(self, index: index)
    }
    
    // MARK: - Actions
    @objc
    private func backTapped() {
        delegate?.shouldDismiss(self)
    }
    
    @objc
    private func finalizeTapped() {
        guard canEditTitle else {
            delegate?.shouldFinalize(self)
            return
        }
        
        let bundle = AlertBundle(title: "Você tem certeza?",
                                 details: "Uma vez finalizada, a entrevista não poderá mais ser alterada.",
                                 options: [
                                    AlertOption(title: "Cancelar", style: .cancel, completion: { _ in }),
                                    AlertOption(title: "Finalizar", style: .destructive, completion: { _ in
                                        self.delegate?.shouldFinalize(self)
                                    })])
        presentAlert(bundle)
    }
    
    @IBAction func didTapActionButton(_ sender: UIButton) {
        proceedWithInterview(index: Index(part: 0, section: 0, row: 0))
    }
}

// MARK: - DataSource
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
        cell.textLabel?.numberOfLines = 2
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return viewModel.partTitles[section]
    }
}

// MARK: - Delegates
extension OverviewViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        proceedWithInterview(index: Index(part: indexPath.section, section: indexPath.row, row: 0))
    }
}

extension OverviewViewController: UITextFieldDelegate {
    @IBAction func editingDidChange(_ sender: SkyFloatingLabelTextField) {
        updateButtonState(titleTextField.text?.isEmpty)
        
        guard let newTitle = titleTextField.text, !newTitle.isEmpty else {
            return
        }
        
        viewModel.updateTitle(newTitle)
    }
    
    @IBAction func textFieldDidEnd(_ sender: SkyFloatingLabelTextField) {
        titleTextField.resignFirstResponder()
        updateButtonState(titleTextField.text?.isEmpty)
        
        guard let newTitle = titleTextField.text, !newTitle.isEmpty else {
            return
        }
        
        viewModel.updateTitle(newTitle)
    }
}
