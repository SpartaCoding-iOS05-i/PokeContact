//
//  MainTableViewCell.swift
//  PokeContact
//
//  Created by 이명지 on 12/9/24.
//
import UIKit

final class MainTableViewCell: UITableViewCell {
    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.borderWidth = 10
        imageView.layer.borderColor = UIColor.lightGray.cgColor
        return imageView
    }()
}
