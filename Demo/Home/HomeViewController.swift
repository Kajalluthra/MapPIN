//
//  HomeViewController.swift
//  Demo
//
//  Created by Kajal Luthra on 15/3/21.
//

import UIKit
import MapKit

final class HomeViewController: UIViewController {
    @IBOutlet weak var mapView: MKMapView!
    
    private let locationManagerInstance = CLLocationManager()
    private let service = HomeNetworkService()
    private var viewModel: HomeViewModel?

    override func viewDidLoad() {
        super.viewDidLoad()
        checkLocationServices()
        setup()
    }

    private func setup() {
        mapView.delegate = self

        viewModel = HomeViewModel(service: service)
        viewModel?.fetchData { [weak self] success in
            guard success else {
                let alert = UIAlertController(title: "DemoApp", message: "Something went wrong", preferredStyle: UIAlertController.Style.alert)
                self?.present(alert, animated: true, completion: nil)
                return
            }
            self?.showAnnotations()
        }
    }
}

extension HomeViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let annotationIdentifier = "AnnotationIdentifier"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: annotationIdentifier)

        if annotationView == nil {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: annotationIdentifier)
            annotationView!.canShowCallout = true
            if let title = annotation.title {
                viewModel?.fetchImage(title ?? "", completionBlock: { image in
                    var imageVw = UIImageView()
                    imageVw = UIImageView(image: image)
                    imageVw.contentMode = .scaleAspectFill
                    annotationView?.detailCalloutAccessoryView = imageVw
                })
            }
        }
        else {
            annotationView!.annotation = annotation
        }
        annotationView!.image = UIImage(named: "mapAnnotationIcon")
        return annotationView
    }
}

private extension HomeViewController {

    func checkLocationServices() {
        if CLLocationManager.locationServicesEnabled() {
            checkLocationPermission()
        } else {
            let alert = UIAlertController(title: "DemoApp", message: "App requires your permission from phone settings.", preferredStyle: UIAlertController.Style.alert)
            self.present(alert, animated: true, completion: nil)
        }
    }

    func checkLocationPermission() {
        switch CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse:
            mapView.showsUserLocation = true
        case .denied:
            break
        case .notDetermined:
            locationManagerInstance.requestWhenInUseAuthorization()
            mapView.showsUserLocation = true
        case .restricted:
            break
        case .authorizedAlways:
            break
        @unknown default:
            fatalError()
        }
    }

    func showAnnotations() {
        viewModel?.cameras.forEach { camera in
            let annotations = MKPointAnnotation()
            annotations.title = camera.image
            annotations.coordinate = CLLocationCoordinate2D(latitude: camera.location.latitude, longitude: camera.location.longitude)

            DispatchQueue.main.async {
                self.mapView.addAnnotation(annotations)
            }
        }
    }
}
