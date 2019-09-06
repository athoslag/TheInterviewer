//
//  SectionOverviewViewController.swift
//  TheInterviewer
//
//  Created by Athos Lagemann on 27/08/19.
//  Copyright © 2019 Athos Lagemann. All rights reserved.
//

import UIKit

protocol SectionDelegate: class {
    func didSelectRow(_ viewController: SectionOverviewViewController, row: Int)
}

final class SectionOverviewViewController: UIViewController {

    @IBOutlet private weak var partTitleLabel: UILabel!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var calloutLabel: UILabel!
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var beginButton: UIButton!
    
    private let partTitle: String
    private let sectionModel: Section
    private let cellReuseID: String = "SectionID"
    
    weak var delegate: SectionDelegate?
    
    init(section: Section, partTitle: String) {
        self.sectionModel = section
        self.partTitle = partTitle
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        partTitleLabel.text = partTitle
        titleLabel.text = sectionModel.title
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseID)
        tableView.dataSource = self
        tableView.delegate = self
        
        configureUI()
    }
    
    private func configureUI() {
        // Titles
        partTitleLabel.font = UIFont(SFPro: .display, variant: .medium, size: 26)
        titleLabel.font = UIFont(SFPro: .display, variant: .medium, size: 24)
        calloutLabel.font = UIFont(SFPro: .text, variant: .medium, size: 22)
        
        // Tableview
        tableView.tableFooterView = UIView()
        
        // Begin Button
        beginButton.layer.cornerRadius = beginButton.layer.bounds.height / 2
        beginButton.backgroundColor = AppConfiguration.mainColor
        beginButton.setTitleColor(.white, for: .normal)
        beginButton.titleLabel?.font = UIFont(SFPro: .display, variant: .medium, size: 22)
    }
    
    @IBAction func didTapBegin(_ sender: UIButton) {
        delegate?.didSelectRow(self, row: 0)
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
        delegate?.didSelectRow(self, row: indexPath.row)
    }
}
