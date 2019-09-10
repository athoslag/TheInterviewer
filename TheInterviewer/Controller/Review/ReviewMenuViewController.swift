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
    }
}

extension ReviewMenuViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.interviewCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let interview = viewModel.interviewInfos(for: indexPath.row)
        let cell = tableView.dequeueReusableCell(withIdentifier: "review", for: indexPath)
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
