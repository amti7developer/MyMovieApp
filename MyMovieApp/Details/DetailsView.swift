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
        avatarImageView.topToSuperview(offset: Constants.avatarTopOffset)
        avatarImageView.height(Constants.imageViewWidth)
        
        likeButton.leadingToSuperview(offset: Constants.standardOffset)
        likeButton.topToBottom(of: avatarImageView, offset: Constants.smallOffset)
        likeButton.width(Constants.likeButtonSize)
        likeButton.height(Constants.likeButtonSize)
        
        titleLabel.leadingToSuperview(offset: Constants.standardOffset)
        titleLabel.trailingToSuperview(offset: Constants.standardOffset)
        titleLabel.topToBottom(of: likeButton, offset: Constants.smallOffset)
        
        releaseLabel.leadingToSuperview(offset: Constants.standardOffset)
        releaseLabel.trailingToSuperview(offset: Constants.standardOffset)
        releaseLabel.topToBottom(of: titleLabel, offset: Constants.smallOffset)
        
        ratingLabel.leadingToSuperview(offset: Constants.standardOffset)
        ratingLabel.trailingToSuperview(offset: Constants.standardOffset)
        ratingLabel.topToBottom(of: releaseLabel, offset: Constants.smallOffset)
        
        detailsTextView.topToBottom(of: ratingLabel, offset: Constants.normalFontSize)
        detailsTextView.leadingToSuperview(offset: Constants.detailsOffset)
        detailsTextView.trailingToSuperview(offset: Constants.standardOffset)
        
        moreButton.topToBottom(of: detailsTextView, offset: Constants.standardOffset)
        moreButton.leadingToSuperview(offset: Constants.biggerOffset)
        moreButton.trailingToSuperview(offset: Constants.biggerOffset)
        moreButton.height(Constants.buttonHeight)
        moreButton.bottomToSuperview(offset: -Constants.biggerOffset)
    }
    
    override func setupSubviews() {
        titleLabel.font = .boldSystemFont(ofSize: Constants.bigFontSize)
        titleLabel.numberOfLines = Constants.doubleLine
        
        likeButton.setImage(UIImage(named: Constants.star), for: .normal)
        likeButton.setImage(UIImage(named: Constants.starFill), for: .selected)
        likeButton.addTarget(self, action: #selector(likeTapped), for: .touchUpInside)
        likeButton.tintColor = .black
        likeButton.isSelected = viewModel.isMovieFavorite()

        releaseLabel.font = .systemFont(ofSize: Constants.normalFontSize)
        ratingLabel.font = .systemFont(ofSize: Constants.normalFontSize)
        avatarImageView.backgroundColor = .black

        detailsTextView.font = .systemFont(ofSize: Constants.normalFontSize)
        detailsTextView.isEditable = false
        detailsTextView.textAlignment = .left

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
        
        let releaseDate = movie.release_date ?? Constants.unnowned
        let rating = viewModel.roundNumber(value: movie.vote_average ?? 0)
        let ratingString: String = String(rating)
        
        releaseLabel.text = "\(Constants.released) \(releaseDate)"
        ratingLabel.text = "\(Constants.rating) \(ratingString)"
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
        static let smallOffset: CGFloat = 8
        static let standardOffset: CGFloat = 16
        static let detailsOffset: CGFloat = 13
        static let biggerOffset: CGFloat = 32
        static let buttonHeight: CGFloat = 50
        static let likeButtonSize: CGFloat = 40
        static let avatarTopOffset: CGFloat = 50
        static let standardImageSize: CGFloat = 56
        static let imageViewWidth: CGFloat = 220
        static let normalFontSize: CGFloat = 18
        static let bigFontSize: CGFloat = 28
        static let standardCornerRadius: CGFloat = 20
        static let closeString = "Close"
        static let unnowned = "Unnowned"
        static let released = "Released:"
        static let rating = "Rating:"
        static let star = "star"
        static let starFill = "star.fill"
    }
}
