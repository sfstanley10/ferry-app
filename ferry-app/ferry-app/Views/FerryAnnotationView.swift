//
//  FerryAnnotationView.swift
//  ferry-app
//
//  Created by Sydnee Stanley on 12/30/19.
//  Copyright © 2019 Sydnee Stanley. All rights reserved.
//

import SwiftUI
import MapKit

class FerryAnnotationView: MKMarkerAnnotationView {
  
  override var annotation: MKAnnotation? {
    didSet {
      updateAnnotation()
    }
  }
  
  private lazy var timesView: UIView = {
    let view = TimeTableView()
    view.translatesAutoresizingMaskIntoConstraints = false
    view.widthAnchor.constraint(equalToConstant: 200).isActive = true
    return view
  }()
  
  private func updateAnnotation() {
    guard let annotation = annotation as? FerryAnnotation else { return }
    canShowCallout = true
    calloutOffset = CGPoint(x: -5, y: 5)
    detailCalloutAccessoryView = timesView
    markerTintColor = color(forState: annotation.state)
//    glyphImage = TODO(ss)
  }
  
  private func color(forState state: DepartureState) -> UIColor {
    switch state {
    case .available:
      return .green
    case .risky:
      return .yellow
    case .unavailable:
      return .red
    }
  }
}
