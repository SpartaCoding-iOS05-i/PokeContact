//
//  ContactImageView.swift
//  PokeContact
//
//  Created by 권승용 on 12/12/24.
//

import UIKit

final class ContactImageView: UIView {
    
    // MARK: - View Property
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let circleView: UIView = {
        let circleView = UIView()
        circleView.layer.borderWidth = 2.0
        circleView.layer.borderColor = UIColor.gray.cgColor
        circleView.clipsToBounds = true
        return circleView
    }()
    
    // MARK: - Property
    
    private let width: CGFloat
    
    // MARK: - Initializer
    
    init(width: CGFloat) {
        self.width = width
        super.init(frame: .zero)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("not using storyboard")
    }
    
    // MARK: - Life Cycle

    override func layoutSubviews() {
        super.layoutSubviews()
        let circleWidth = CGRectGetWidth(circleView.bounds)
        let radius = circleWidth / 2
        circleView.layer.cornerRadius = radius
    }
    
    // MARK: - Configure UI
    
    private func configureUI() {
        let subviews = [
            circleView,
            imageView
        ]
        
        subviews.forEach {
            addSubview($0)
        }
        
        circleView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
            make.width.equalTo(width)
            make.height.equalTo(width)
        }
        
        imageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
            make.width.equalTo(calculateSquareSideFromDiameter(diameter: width))
            make.height.equalTo(imageView.snp.width)
        }
    }
    
    // MARK: - ConfigureData
    
    func configure(with image: UIImage?) {
        imageView.image = image
    }
    
    func getImageData() -> Data? {
        return imageView.image?.pngData()
    }
    
    func prepareForReuse() {
        imageView.image = nil
    }
}

private extension ContactImageView {
    // 원애 내접하는 정사각형의 한 변의 길이 구하는 함수
    func calculateSquareSideFromDiameter(diameter: Double) -> Double {
        return diameter / sqrt(2)
    }
}

@available(iOS 17, *)
#Preview {
    ContactImageView(width: 200)
}
