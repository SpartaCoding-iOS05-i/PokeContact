//
//  RoundImageView.swift
//  PokeContact
//
//  Created by t0000-m0112 on 2024-12-10.
//

import UIKit

class RoundImageView: UIImageView {
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = bounds.height / 2
        self.layer.borderWidth = 2
        self.layer.borderColor = UIColor.systemGray4.cgColor
    }
}
