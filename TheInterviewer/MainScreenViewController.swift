//
//  MainScreenViewController.swift
//  TheInterviewer
//
//  Created by Athos Lagemann on 19/06/19.
//  Copyright © 2019 Athos Lagemann. All rights reserved.
//

import UIKit

final class MainScreenViewController: UIViewController {
    
    @IBOutlet weak var calloutLabel: UILabel!
    private let callout: String
    
    init(text: String) {
        callout = text
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        calloutLabel.text = callout
    }
}
