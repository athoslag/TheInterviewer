//
//  SectionOverviewViewController.swift
//  TheInterviewer
//
//  Created by Athos Lagemann on 27/08/19.
//  Copyright © 2019 Athos Lagemann. All rights reserved.
//

import UIKit

protocol SectionDelegate: class {
    func didSelectRow(_ viewController: SectionOverviewViewController, row: IndexPath)
}

final class SectionOverviewViewController: UIViewController {

    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var tableView: UITableView!
    
    private let sectionModel: Section
    private let cellReuseID: String = "SectionID"
    
    weak var delegate: SectionDelegate?
    
    init(section: Section) {
        self.sectionModel = section
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.text = sectionModel.title
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseID)
        tableView.dataSource = self
        tableView.delegate = self
        
        configureUI()
    }
    
    private func configureUI() {
        // Title
        titleLabel.font = UIFont(SFPro: .display, variant: .medium, size: 22)
    }
}

extension SectionOverviewViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sectionModel.questionPairs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let questionAnswer = sectionModel.questionPairs[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseID, for: indexPath)
        cell.textLabel?.text = questionAnswer.question
        cell.detailTextLabel?.text = questionAnswer.answer
        return cell
    }
}

extension SectionOverviewViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.didSelectRow(self, row: indexPath)
    }
}
