//
//  ReviewMenuViewController.swift
//  TheInterviewer
//
//  Created by Athos Lagemann on 10/09/19.
//  Copyright © 2019 Athos Lagemann. All rights reserved.
//

import UIKit

protocol ReviewDelegate: class {
    func didSelectRow(_ viewController: ReviewMenuViewController, viewModel: ReviewViewModel, row: Int)
}

final class ReviewMenuViewController: UIViewController {

    @IBOutlet private weak var calloutLabel: UILabel!
    @IBOutlet private weak var tableView: UITableView!
    
    @IBOutlet private weak var emptyStateStackView: UIStackView!
    @IBOutlet private weak var emptyStateLabel: UILabel!
    
    private let viewModel: ReviewViewModel
    
    
    weak var delegate: ReviewDelegate?
    
    init(viewModel: ReviewViewModel) {
        self.viewModel = viewModel
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
    }
    
    private func configureUI() {
        // callout label
        calloutLabel.font = UIFont(SFPro: .display, variant: .medium, size: 24)
        calloutLabel.text = "Revise aqui as suas entrevistas passadas"
        
        // table view
        tableView.tableFooterView = UIView()
        
        // empty state
        emptyStateLabel.text = "Nenhuma entrevista encontrada!"
        emptyStateLabel.font = UIFont(SFPro: .display, variant: .regular, size: 22)
    }
}

extension ReviewMenuViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.emptyStateStackView.isHidden = viewModel.interviewCount != 0
        self.tableView.isHidden = viewModel.interviewCount == 0
        
        return viewModel.interviewCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let interview = viewModel.interviewInfos(for: indexPath.row)
        
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "review")
        cell.textLabel?.text = interview.title
        cell.detailTextLabel?.text = interview.date
        return cell
    }
}

extension ReviewMenuViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.didSelectRow(self, viewModel: viewModel, row: indexPath.row)
    }
}
