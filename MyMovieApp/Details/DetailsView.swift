//
//  DetailsView.swift
//  MyMovieApp
//
//  Created by Kamil on 27/09/2020.
//  Copyright © 2020 Kamil Gacek. All rights reserved.
//

import UIKit
import LBTAComponents
import TinyConstraints

protocol DetailsViewDelegate: AnyObject {
    func detailsViewCloseTapped(_ view: DetailsView)
}

final class DetailsView: BaseView {
    
    var viewModel: DetailsViewModelType
    
    weak var delegate: DetailsViewDelegate?
    
    private let avatarImageView = CachedImageView()
    private let likeButton = UIButton()
    private let titleLabel = UILabel()
    private let releaseLabel = UILabel()
    private let ratingLabel = UILabel()
    private let detailsTextView = UITextView()
    private let moreButton = UIButton()
    
    init(viewModel: DetailsViewModelType) {
        self.viewModel = viewModel
        super.init()
    }
    
    override func addSubviews() {
        [avatarImageView, titleLabel, releaseLabel, ratingLabel, detailsTextView, moreButton, likeButton].forEach {
            addSubview($0)
        }
    }
    
    override func setupConstraints() {
        avatarImageView.leadingToSuperview()
        avatarImageView.trailingToSuperview()
        avatarImageView.topToSuperview(offset: 50)
        avatarImageView.height(Constants.imageViewWidth)
        avatarImageView.backgroundColor = .black
        
        likeButton.leadingToSuperview(offset: 16)
        likeButton.topToBottom(of: avatarImageView, offset: 8)
        likeButton.width(40)
        likeButton.height(40)
        
        titleLabel.leadingToSuperview(offset: Constants.standardOffset)
        titleLabel.trailingToSuperview(offset: Constants.standardOffset)
        titleLabel.topToBottom(of: likeButton, offset: 8)
        
        releaseLabel.leadingToSuperview(offset: Constants.standardOffset)
        releaseLabel.trailingToSuperview(offset: Constants.standardOffset)
        releaseLabel.topToBottom(of: titleLabel, offset: Constants.smallOffset)
        
        ratingLabel.leadingToSuperview(offset: Constants.standardOffset)
        ratingLabel.trailingToSuperview(offset: Constants.standardOffset)
        ratingLabel.topToBottom(of: releaseLabel, offset: Constants.smallOffset)
        
        detailsTextView.topToBottom(of: ratingLabel, offset: Constants.normalFontSize)
        detailsTextView.leadingToSuperview(offset: 13)
        detailsTextView.trailingToSuperview(offset: Constants.standardOffset)
        detailsTextView.textAlignment = .left
        
        moreButton.topToBottom(of: detailsTextView, offset: Constants.standardOffset)
        moreButton.leadingToSuperview(offset: Constants.biggerOffset)
        moreButton.trailingToSuperview(offset: Constants.biggerOffset)
        moreButton.height(Constants.buttonHeight)
        moreButton.bottomToSuperview(offset: -Constants.biggerOffset)
    }
    
    override func setupSubviews() {
        titleLabel.font = .boldSystemFont(ofSize: Constants.bigFontSize)
        titleLabel.numberOfLines = Constants.doubleLine
        
        likeButton.setImage(UIImage(named: "star"), for: .normal)
        likeButton.setImage(UIImage(named: "star.fill"), for: .selected)
        likeButton.addTarget(self, action: #selector(likeTapped), for: .touchUpInside)
        
        likeButton.tintColor = .black
        
        releaseLabel.font = .systemFont(ofSize: Constants.normalFontSize)
        ratingLabel.font = .systemFont(ofSize: Constants.normalFontSize)
        
        likeButton.isSelected = viewModel.isMovieFavorite()

        detailsTextView.font = .systemFont(ofSize: Constants.normalFontSize)
        detailsTextView.isEditable = false
        
        moreButton.backgroundColor = .systemYellow
        moreButton.setTitle(Constants.closeString, for: .normal)
        moreButton.setTitleColor(.black, for: .normal)
        moreButton.layer.cornerRadius = Constants.standardCornerRadius
        moreButton.addTarget(self, action: #selector(showMoreAction), for: .touchUpInside)
        
        backgroundColor = .white
    }
    
    func configureView(movie: Movie) {
        
        avatarImageView.loadImage(string: movie.backdrop_path ?? "")
        avatarImageView.contentMode = .scaleAspectFit
        titleLabel.text = movie.title
        detailsTextView.text = movie.overview
        
        let releaseDate = movie.release_date ?? "Unnowned"
        let rating = Double(round(10 * (movie.vote_average ?? 0.0)) / 10)
        
        let ratingString: String = String(rating)
        releaseLabel.text = "Released: \(releaseDate)"
        ratingLabel.text = "Rating: \(ratingString)"
    }
    
    @objc private func showMoreAction() {
        delegate?.detailsViewCloseTapped(self)
    }
    
    @objc private func likeTapped() {
        viewModel.toggleLiked()
        likeButton.isSelected = viewModel.isMovieFavorite()
    }
}

extension DetailsView {
    private struct Constants {
        static let doubleLine = 2
        static let smallOffset: CGFloat = 6
        static let standardOffset: CGFloat = 16
        static let biggerOffset: CGFloat = 32
        static let buttonHeight: CGFloat = 50
        static let standardImageSize: CGFloat = 56
        static let imageViewWidth: CGFloat = 220
        static let normalFontSize: CGFloat = 18
        static let bigFontSize: CGFloat = 28
        static let standardCornerRadius: CGFloat = 20
        static let closeString = "Close"
    }
}
