//
//  TimeTableView.swift
//  ferry-app
//
//  Created by Sydnee Stanley on 12/30/19.
//  Copyright © 2019 Sydnee Stanley. All rights reserved.
//

import SwiftUI

//struct TimeTableView: View {
//  var body: some View {
//    VStack {
//      Text("2:00")
//      Text("10:00")
//    }
//  }
//}

class TimeTableView: UIView {
  
  lazy var stackView: UIStackView = {
    let stackView = UIStackView()
    stackView.translatesAutoresizingMaskIntoConstraints = false
    stackView.axis = .vertical
    stackView.alignment = .center
    stackView.spacing = 10
    
    let spacer = UIView()
    stackView.addArrangedSubviews([lockupView, firstTime, secondTime, spacer])
    return stackView
  }()
  
  lazy var lockupView = LockupView()
  lazy var firstTime = makeCountdownView()
  lazy var secondTime = makeCountdownView()
  
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
  
  private func makeCountdownView() -> UIView {
    let label = UILabel()
    label.textColor = .white
    label.backgroundColor = .green
    label.text = "10:00"
    return label
  }
}

extension UIStackView {
  func addArrangedSubviews(_ subviews: [UIView]) {
    subviews.forEach { addArrangedSubview($0) }
  }
}
