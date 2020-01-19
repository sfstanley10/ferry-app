//
//  MapView.swift
//  ferry-app
//
//  Created by Sydnee Stanley on 11/2/19.
//  Copyright © 2019 Sydnee Stanley. All rights reserved.
//

import SwiftUI
import MapKit
import Combine

final class MapView: NSObject, UIViewRepresentable {

  var viewModel: MapViewModel
  
  private var disposables = Set<AnyCancellable>()
  
  // TODO(ss): actually pass this in
  init(viewModel: MapViewModel = MapViewModel()) {
    self.viewModel = viewModel
  }
  
  func makeUIView(context: Context) -> MKMapView {
    let view = MKMapView(frame: .zero)
    view.delegate = self
    view.showsUserLocation = true
    view.register(FerryAnnotationView.self,
                  forAnnotationViewWithReuseIdentifier: String(describing: FerryAnnotationView.self))
    
    // TODO(ss): store(in: &disposables)
    viewModel.$ferryRoutes
      .receive(on: DispatchQueue.main)
      .map { $0.map { $0.polyline } }
      .sink(receiveValue: { $0.forEach { view.addOverlay($0) } })
      .store(in: &disposables)
    
    viewModel.topFerryRoutes
      .receive(on: DispatchQueue.main)
      .map { $0.map { return $0.polyline } }
      .sink(receiveCompletion: { _ in return }, // TODO(ss)
            receiveValue: {
              view.removeOverlays(view.overlays)
              $0.forEach { view.addOverlay($0) }
            })
      .store(in: &disposables)

    return view
  }
  
  func updateUIView(_ view: MKMapView, context: UIViewRepresentableContext<MapView>) {
    let span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
    let region = MKCoordinateRegion(center: viewModel.centerPoint, span: span)
    view.setRegion(region, animated: true)
    view.addAnnotations(viewModel.annotations)
  }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView()
    }
}

extension MapView: MKMapViewDelegate {
  
  func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
    let identifier = String(describing: FerryAnnotationView.self)
    guard let annotation = annotation as? FerryAnnotation else { return nil }

    let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? FerryAnnotationView
    dequeuedView?.annotation = annotation
    let view = dequeuedView ?? FerryAnnotationView(annotation: annotation, reuseIdentifier: identifier)
    return view
  }
  
  func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
    guard let coordinate = view.annotation?.coordinate else { return }
    let span = mapView.region.span
    let region = MKCoordinateRegion(center: coordinate, span: span)
    mapView.setRegion(region, animated: true)
  }
  
  func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
    guard let overlay = overlay as? MKPolyline else {
      return MKOverlayRenderer()
    }
    let renderer = MKPolylineRenderer(polyline: overlay)
    renderer.strokeColor = .blue
    return renderer
  }
}
