//
//  LockupView.swift
//  ferry-app
//
//  Created by Sydnee Stanley on 12/30/19.
//  Copyright © 2019 Sydnee Stanley. All rights reserved.
//

import UIKit

class LockupView: UIView {
  lazy var stackView: UIStackView = {
    let stackView = UIStackView()
    stackView.translatesAutoresizingMaskIntoConstraints = false
    stackView.axis = .horizontal
    stackView.alignment = .center
    stackView.addArrangedSubviews([startingLabel, startingCircle, connectingLine, endingCircle, endingLabel])
    return stackView
  }()
  
  lazy var startingLabel: UILabel = {
    let label = UILabel()
    label.lineBreakMode = .byWordWrapping
    label.numberOfLines = 0
    label.text = "NDSM"
    label.sizeToFit()
    return label
  }()
  
  lazy var endingLabel: UILabel = {
    let label = UILabel()
    label.numberOfLines = 0
    label.lineBreakMode = .byWordWrapping
    label.text = "Centraal Station"
    label.sizeToFit()
    return label
  }()
  
  lazy var startingCircle: UIView = makeCircle()
  lazy var endingCircle: UIView = makeCircle()
  
  lazy var connectingLine: UIView = {
    let view = UIView()
    view.backgroundColor = .gray
    view.heightAnchor.constraint(equalToConstant: 2).isActive = true
    return view
  }()
  
  override init(frame: CGRect) {
    super.init(frame: .zero)

    addSubview(stackView)
    NSLayoutConstraint.activate([
      stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
      stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
      stackView.topAnchor.constraint(equalTo: topAnchor),
      stackView.bottomAnchor.constraint(equalTo: bottomAnchor)
    ])
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func makeCircle() -> UIView {
    let view = UIView()
    view.translatesAutoresizingMaskIntoConstraints = false
    view.widthAnchor.constraint(equalToConstant: 10).isActive = true
    view.heightAnchor.constraint(equalToConstant: 10).isActive = true
    view.backgroundColor = .gray
    view.layer.masksToBounds = true
    view.layer.cornerRadius = 5
    return view
  }
}
