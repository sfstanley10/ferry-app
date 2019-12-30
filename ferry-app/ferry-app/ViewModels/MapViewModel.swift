//
//  MapViewModel.swift
//  ferry-app
//
//  Created by Sydnee Stanley on 12/13/19.
//  Copyright © 2019 Sydnee Stanley. All rights reserved.
//

import CoreLocation
import MapKit

class MapViewModel: NSObject {
  lazy var location: CLLocation? = locationManager.location
  
  private lazy var locationManager: CLLocationManager = {
    let manager = CLLocationManager()
    manager.requestWhenInUseAuthorization()
    return manager
  }()
  
  let mapModel = MockMapModel()
  
  var mockAnnotations: [FerryAnnotation] {
    return mapModel.ferryLocations.flatMap {
      $0.value.map { data in
        let state: DepartureState = data.1 == "NDSM" ? .available : .unavailable
        return FerryAnnotation(data.0.coordinate, title: data.1, state: state)
      }
    }
  }
  
  var centerPoint: CLLocationCoordinate2D {
    return mapModel.centerPoint.coordinate
  }
}

// TODO(ss): move this to...?

extension MapViewModel: MKMapViewDelegate {
  
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
}

struct MockMapModel {
  enum Direction {
    case northBound
    case southBound
  }
  
  let NDSMFerryLocation = CLLocation(latitude: 52.401211, longitude: 4.891276)
  let BuiksloterwegFerryLocation = CLLocation(latitude: 52.382217, longitude: 4.903215)
  
  let centerPoint = CLLocation(latitude: 52.388299, longitude: 4.905057)
  
  var ferryLocations: [Direction: [(CLLocation, String)]] {
    return [.southBound: [(NDSMFerryLocation, "NDSM"), (BuiksloterwegFerryLocation, "Buiksloterweg")]]
  }
}
