//
//  MapView.swift
//  ferry-app
//
//  Created by Sydnee Stanley on 11/2/19.
//  Copyright © 2019 Sydnee Stanley. All rights reserved.
//

import SwiftUI
import MapKit

struct MapView: UIViewRepresentable {
  
  var viewModel: MapViewModel
  
  // TODO(ss): actually pass this in
  init(viewModel: MapViewModel = MapViewModel()) {
    self.viewModel = viewModel
  }
  
  func makeUIView(context: Context) -> MKMapView {
    let view = MKMapView(frame: .zero)
    view.delegate = viewModel
    view.register(FerryAnnotationView.self,
                  forAnnotationViewWithReuseIdentifier: String(describing: FerryAnnotationView.self))
    return view
  }
  
  func updateUIView(_ view: MKMapView, context: UIViewRepresentableContext<MapView>) {
    let span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
    let region = MKCoordinateRegion(center: viewModel.centerPoint, span: span)
    view.setRegion(region, animated: true)
    view.addAnnotations(viewModel.mockAnnotations)
  }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView()
    }
}
