//
//  PhotosTableViewCell.swift
//  Navigation
//
//  Created by Андрей Банин on 23.12.22..
//

import UIKit

class PhotosTableViewCell: UITableViewCell {
    
    struct ViewModel {
        var imageOne: UIImage?
        var imageTwo: UIImage?
        var imageThree: UIImage?
        var imageFour: UIImage?
    }
    
    private lazy var photosLabel: UILabel = {
        let label = UILabel()
        label.text = "Photos"
        label.textColor = .black
        label.font = .boldSystemFont(ofSize: 24)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var arrowLabel: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(systemName: "arrow.right")
        image.tintColor = .black
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    private lazy var photoOne: UIImageView = {
        let photo = UIImageView()
        photo.layer.cornerRadius = 6
        photo.clipsToBounds = true
        photo.translatesAutoresizingMaskIntoConstraints = false
        return photo
    }()
    
    private lazy var photoTwo: UIImageView = {
        let photo = UIImageView()
        photo.layer.cornerRadius = 6
        photo.clipsToBounds = true
        photo.translatesAutoresizingMaskIntoConstraints = false
        return photo
    }()
    
    private lazy var photoThree: UIImageView = {
        let photo = UIImageView()
        photo.layer.cornerRadius = 6
        photo.clipsToBounds = true
        photo.translatesAutoresizingMaskIntoConstraints = false
        return photo
    }()
    
    private lazy var photoFour: UIImageView = {
        let photo = UIImageView()
        photo.layer.cornerRadius = 6
        photo.clipsToBounds = true
        photo.translatesAutoresizingMaskIntoConstraints = false
        return photo
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.setupConstraints()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setup(with viewModel: ViewModel){
        self.photoOne.image = viewModel.imageOne
        self.photoTwo.image = viewModel.imageTwo
        self.photoThree.image = viewModel.imageThree
        self.photoFour.image = viewModel.imageFour
    }
    
    private func setupConstraints() {
        
        let wigthFrame = (self.contentView.frame.width - 48 ) / 3.25
        
        self.contentView.addSubview(self.photosLabel)
        self.contentView.addSubview(self.arrowLabel)
        
        self.contentView.addSubview(self.photoOne)
        self.contentView.addSubview(self.photoTwo)
        self.contentView.addSubview(self.photoThree)
        self.contentView.addSubview(self.photoFour)
        
        NSLayoutConstraint.activate([
            
            self.photosLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 12),
            self.photosLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 12),
            
            self.arrowLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -12),
            self.arrowLabel.centerYAnchor.constraint(equalTo: self.photosLabel.centerYAnchor),
            
            
            self.photoOne.topAnchor.constraint(equalTo: self.photosLabel.bottomAnchor, constant: 12),
            self.photoOne.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 12),
            self.photoOne.widthAnchor.constraint(equalToConstant: wigthFrame),
            self.photoOne.heightAnchor.constraint(equalToConstant: wigthFrame),
            self.photoOne.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -12),
            
            self.photoTwo.topAnchor.constraint(equalTo: self.photosLabel.bottomAnchor, constant: 12),
            self.photoTwo.leadingAnchor.constraint(equalTo: self.photoOne.trailingAnchor, constant: 8),
            self.photoTwo.widthAnchor.constraint(equalToConstant: wigthFrame),
            self.photoTwo.heightAnchor.constraint(equalToConstant: wigthFrame),
            self.photoTwo.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -12),
            
            self.photoThree.topAnchor.constraint(equalTo: self.photosLabel.bottomAnchor, constant: 12),
            self.photoThree.leadingAnchor.constraint(equalTo: self.photoTwo.trailingAnchor, constant: 8),
            self.photoThree.widthAnchor.constraint(equalToConstant: wigthFrame),
            self.photoThree.heightAnchor.constraint(equalToConstant: wigthFrame),
            self.photoThree.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -12),
            
            self.photoFour.topAnchor.constraint(equalTo: self.photosLabel.bottomAnchor, constant: 12),
            self.photoFour.leadingAnchor.constraint(equalTo: self.photoThree.trailingAnchor, constant: 8),
            self.photoFour.widthAnchor.constraint(equalToConstant: wigthFrame),
            self.photoFour.heightAnchor.constraint(equalToConstant: wigthFrame),
            self.photoFour.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -12)
        ])
    }

}

