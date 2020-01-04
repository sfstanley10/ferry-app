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
  
  private var locationManager = CLLocationManager()
  
  private var lastKnownLocation: CLLocation?
  
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
  
  override init() {
    super.init()
    locationManager.delegate = self
    locationManager.requestWhenInUseAuthorization()
    locationManager.desiredAccuracy = kCLLocationAccuracyBest
    locationManager.distanceFilter = kCLDistanceFilterNone
    
    locationManager.startUpdatingLocation()
  }
  
  func updateTravelTimes(for userLocation: CLLocation) {
    let ferryLocations = mapModel.ferryLocations.flatMap { $0.value.map { $0.0 } }
    for ferryLocation in ferryLocations {
      let request = MKDirections.Request()
      request.source = MKMapItem(placemark: MKPlacemark(coordinate: userLocation.coordinate))
      request.destination = MKMapItem(placemark: MKPlacemark(coordinate: ferryLocation.coordinate))
      request.transportType = .walking
      let directions = MKDirections(request: request)
      directions.calculate { response, error in
        guard let response = response else { return } // TODO(ss): handle error
        print("=====", response.routes.first?.expectedTravelTime)
      }
    }
  }
}

extension MapViewModel: CLLocationManagerDelegate {
  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    guard let userLocation = locations.first else { return }

    // Don't calculate if the user's location hasn't changed
    guard userLocation != lastKnownLocation else { return }

    lastKnownLocation = userLocation
    updateTravelTimes(for: userLocation)
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
