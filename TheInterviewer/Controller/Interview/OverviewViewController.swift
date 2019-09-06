//
//  OverviewViewController.swift
//  TheInterviewer
//
//  Created by Athos Lagemann on 06/08/19.
//  Copyright © 2019 Athos Lagemann. All rights reserved.
//

import UIKit

protocol OverviewDelegate: class {
    func didSelect(_ viewController: OverviewViewController, index: Index)
}

final class OverviewViewController: UIViewController {

    @IBOutlet private weak var informationLabel: UILabel!
    @IBOutlet private weak var tableView: UITableView!
    
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
        
        tableView.dataSource = self
        tableView.delegate = self
        
        informationLabel.text = viewModel.title
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewModel.describeInterview()
    }
    
    private func configureUI() {
        // Information
        informationLabel.font = UIFont(SFPro: .text, variant: .medium, size: 26)
        
        // Tableview
        let nibView = UIView()
        nibView.backgroundColor = .white
        tableView.tableFooterView = nibView
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
        // FIXME: change IndexPath to (Part, Section, Row) format
        delegate?.didSelect(self, index: Index(part: 1, section: 0, row: 0))
    }
}
