//
//  MovieCell.swift
//  MyMovieApp
//
//  Created by Kamil on 28/09/2020.
//  Copyright © 2020 Kamil Gacek. All rights reserved.
//

import UIKit
import LBTAComponents
import TinyConstraints

class MovieCell: UITableViewCell {
    
    private let movieImageView = CachedImageView()
    private let starImageView = UIButton()
    private let nameLabel = UILabel()
    private let descriptionLabel = UILabel()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubviews()
        setupSubviews()
        setupConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with movie: Movie) {
        movieImageView.loadImage(string: movie.backdrop_path ?? "")
        nameLabel.text = movie.title
        
        let movieID = movie.id ?? 0
        let isFav = UserDefaults.standard.bool(forKey: "\(movieID)")
        let imgName = isFav ? "star.fill" : "star"
        starImageView.setImage(UIImage(named: imgName), for: .normal)
        movieImageView.backgroundColor = .black
    }
    
    private func addSubviews() {
        [movieImageView, nameLabel, descriptionLabel, starImageView].forEach {
            addSubview($0)
        }
    }
    
    private func setupConstraints() {
        movieImageView.leadingToSuperview(offset: Constants.standardOffset)
        movieImageView.centerYToSuperview()
        
        nameLabel.top(to: movieImageView, offset: Constants.smallerOffset)
        nameLabel.leadingToTrailing(of: movieImageView, offset: Constants.standardOffset)
        
        starImageView.leadingToTrailing(of: nameLabel, offset: Constants.smallerOffset)
        starImageView.trailingToSuperview(offset: 8)
        starImageView.centerYToSuperview()
        starImageView.width(30)
        starImageView.height(30)
    }
    
    private func setupSubviews() {
        movieImageView.size(CGSize(width: Constants.buttonSize, height: Constants.buttonSize))
        movieImageView.layer.cornerRadius = Constants.cornerRadius
        
        nameLabel.font = .boldSystemFont(ofSize: Constants.standardOffset)
        nameLabel.numberOfLines = 2
        
        
        
        starImageView.tintColor = .black
        starImageView.addTarget(self, action: #selector(starImageTapped), for: .touchUpInside)
        
        descriptionLabel.font = .systemFont(ofSize: Constants.descriptionFont)
        descriptionLabel.textColor = .darkGray
    }
    
    @objc private func starImageTapped() {
        
    }
}

extension MovieCell {
    private struct Constants {
        static let smallerOffset: CGFloat = 8
        static let standardOffset: CGFloat = 16
        static let descriptionFont: CGFloat = 15
        static let cornerRadius: CGFloat = 10
        static let buttonSize: CGFloat = 64
    }
    
}
