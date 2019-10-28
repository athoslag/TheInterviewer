//
//  Checkbox.swift
//  TheInterviewer
//
//  Created by Athos Lagemann on 14/10/19.
//  Copyright © 2019 Athos Lagemann. All rights reserved.
//

import UIKit

final class Checkbox: UIView {
    enum CheckBoxStyle {
        case rounded, squared
    }
        
    private let checkColor: UIColor
    private let style: CheckBoxStyle
    var isChecked: Bool {
        didSet {
            self.updateUI()
        }
    }
    
    init(style: CheckBoxStyle, checked: Bool, checkColor: UIColor = AppConfiguration.mainColor) {
        self.isChecked = checked
        self.style = style
        self.checkColor = checkColor
        super.init(frame: CGRect.zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    private func setupUI() {
        switch style {
        case .rounded:
            layer.cornerRadius = bounds.height / 2
        case .squared:
            break
        }
        
        layer.borderWidth = 0.5
        layer.borderColor = UIColor.darkGray.cgColor
        
        updateUI()
    }
    
    private func updateUI() {
        UIViewPropertyAnimator(duration: 0.5, curve: .easeOut) {
            self.backgroundColor = self.isChecked ? self.checkColor : .white
        }.startAnimation()
    }
}
