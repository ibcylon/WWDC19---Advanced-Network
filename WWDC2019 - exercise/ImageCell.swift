//
//  ImageCell.swift
//  WWDC2019 - exercise
//
//  Created by Kanghos on 2024/01/23.
//

import UIKit
import Combine

final class ImageCell: UITableViewCell {

  static let id = "ImageCell"
  lazy var config: UIListContentConfiguration = self.defaultContentConfiguration()

  var image: UIImage? {
    didSet {
      config.image = image
      DispatchQueue.main.async { [config] in
        self.contentConfiguration = config
      }
    }
  }

  var subscriber: AnyCancellable? // cell 내에 cancellable을 사용하여 잘못된 바인딩 제거

  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)

    makeUI()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func makeUI() {
  }

  func bind(_ item: MenuItem) {
    config.image = UIImage(systemName: "exclamationmark.triangle.fill")
    config.imageProperties.maximumSize = CGSize(width: 100, height: 200)
    config.imageProperties.reservedLayoutSize = CGSize(width: 100, height: 100)
    config.attributedText = NSAttributedString(string: item.title)
    config.secondaryText = item.subTitle
    config.imageToTextPadding = 10

    self.contentConfiguration = self.config
  }

  override func prepareForReuse() {
    image = nil
    subscriber?.cancel() // 기존 구독 해제
  }
}
