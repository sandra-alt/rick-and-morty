//
//  CharacterCell.swift
//  RickAndMorty
//
//  Created by  Oleksandra on 07.04.2025.
//

import UIKit
import Kingfisher

class CharacterCell: UITableViewCell {
    
    // MARK: - Layout properties
    private struct Layout {
        static let spacing: CGFloat = 16.0
        static let cellMargin: CGFloat = 6.0
        static let horizontalSpacing: CGFloat = 24.0
        static let cornerRadius: CGFloat = 12.0
        static let imageSize: CGFloat = 80.0
        static let imageCornerRadius: CGFloat = 8.0
        
        static let tileColor1 = UIColor.gray.cgColor
        static let tileColor2 = UIColor.systemTeal.cgColor
        static let textColor = UIColor.white
        static let statusTextColor = UIColor.darkGray
        static let nameFont = UIFont.systemFont(ofSize: 16, weight: .semibold)
        static let secondaryFont = UIFont.systemFont(ofSize: 14)
    }
    
    // MARK: - UI Components
    private lazy var tileView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = Layout.cornerRadius
        return view
    }()
    
    private lazy var gradientLayer: CAGradientLayer = {
        let gradient = CAGradientLayer()
        gradient.colors = [
            Layout.tileColor1,
            Layout.tileColor2
        ]
        gradient.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradient.endPoint = CGPoint(x: 1.0, y: 1.0)
        gradient.cornerRadius = Layout.cornerRadius
        return gradient
    }()
    
    private lazy var hStack: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.alignment = .fill
        view.distribution = .fill
        view.spacing = Layout.spacing
        return view
    }()
    
    private lazy var vStack: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.alignment = .fill
        view.distribution = .fill
        view.spacing = Layout.spacing
        return view
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = Layout.textColor
        label.font = Layout.nameFont
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var speciesLabel: UILabel = {
        let label = UILabel()
        label.textColor = Layout.textColor
        label.font = Layout.secondaryFont
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var statusLabel: UILabel = {
        let label = UILabel()
        label.textColor = Layout.statusTextColor
        label.font = Layout.secondaryFont
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var characterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = Layout.imageCornerRadius
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
    }
    
    private func setupViews() {
        [nameLabel, speciesLabel, statusLabel].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            vStack.addArrangedSubview($0)
        }
        
        [characterImageView, vStack].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            hStack.addArrangedSubview($0)
        }
        
        NSLayoutConstraint.activate([
            characterImageView.widthAnchor.constraint(equalToConstant: Layout.imageSize),
            characterImageView.heightAnchor.constraint(equalToConstant: Layout.imageSize),
        ])
        
        
        tileView.addSubview(hStack)
        hStack.bindFrameToSuperview(margin: Layout.spacing)
        
        addSubview(tileView)
        tileView.bindFrameToSuperview(margin: Layout.cellMargin)
        
        tileView.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    func configure(with character: CharacterList.FetchCharacters.ViewModel.CharacterViewModel) {
        nameLabel.text = character.name
        speciesLabel.text = "Species: " + character.species
        statusLabel.text = "Status: " + character.status
        characterImageView.kf.setImage(with: URL(string: character.imageUrl))
        
        accessoryType = .disclosureIndicator
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        characterImageView.image = nil
        
        nameLabel.text = ""
        speciesLabel.text = ""
        statusLabel.text = ""
    }
    
    override func layoutSubviews() {
        gradientLayer.frame = tileView.bounds
        super.layoutSubviews()
    }
}
