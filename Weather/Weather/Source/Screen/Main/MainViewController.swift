//
//  MainViewController.swift
//  Weather
//
//  Created by heerucan on 2022/08/15.
//

import UIKit
import MapKit
import CoreLocation

import Kingfisher

final class MainViewController: UIViewController {
    
    // MARK: - Property
    
    private let locationManager = CLLocationManager()
    private let geocoder = CLGeocoder()
    
    var latitude = 37.552102211961085
    var longitude = 126.95587037133782
    
    // MARK: - @IBOutlet
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var maxMinLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var windLabel: UILabel!
    @IBOutlet weak var commentLabel: UILabel!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet var backView: [UIView]!
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        setupCoreLocation()
        setupMap()
        findAddress()
        requestWeather()
    }
    
    // MARK: - Configure UI & Layout
    
    private func configureUI() {
        commentLabel.numberOfLines = 0
        dateLabel.text = Date().getCurrentTime()
        backView.forEach { $0.makeRound(10) }
        backView.forEach { $0.makeBorder(1) }
    }
    
    // MARK: - @IBAction
    
    @IBAction func touchupLocationButton(_ sender: UIButton) {
        setupMap()
    }
    
    // MARK: - Custom Method
    
    private func setupCoreLocation() {
        locationManager.delegate = self
    }
    
    private func setupMap() {
        let center = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        let region = MKCoordinateRegion(center: center,
                                        latitudinalMeters: 800,
                                        longitudinalMeters: 800)
        mapView.setRegion(region, animated: true)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = center
        annotation.title = "?????? ??????"
        mapView.addAnnotation(annotation)
    }
    
    private func findAddress() {
        let locale = Locale(identifier: "Ko-kr")
        let location = CLLocation(latitude: latitude,
                                  longitude: longitude)
        geocoder.reverseGeocodeLocation(location,
                                        preferredLocale: locale) { (placemarks, error) in
            if let locality = placemarks?.last?.locality,
               let subLocality = placemarks?.last?.subLocality {
                self.locationLabel.text = locality + ", " + subLocality
            }
        }
    }
    
    // MARK: - Network
    
    func requestWeather() {
        WeatherManager.shared.requestWeather(lat: latitude, lon: longitude) { weather in
            DispatchQueue.main.async {
                self.tempLabel.text = weather.tempLabel
                self.maxMinLabel.text = weather.maxMinLabel
                self.humidityLabel.text = weather.humidityLabel
                self.windLabel.text = weather.windLabel
                self.commentLabel.text = weather.descriptionLabel
                self.iconImageView.kf.setImage(with: URL(string: weather.icon))
            }
        }
    }
}

// MARK: - CLLocationManagerDelegate

extension MainViewController: CLLocationManagerDelegate {
    // ?????? ????????? ??????????????? ????????? ??????
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let coordinate = locations.last?.coordinate {
            latitude = coordinate.latitude
            longitude = coordinate.longitude
            requestWeather()
        }
        locationManager.stopUpdatingLocation()
    }
    
    // ?????? ????????? ???????????? ?????? ??????
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("???? ?????? ????????? ???????????? ???????????????!")
        checkUserCurrentLocationAuthorization(locationManager.authorizationStatus)
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkUserDeviceLocationServiceAuthorization()
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        checkUserDeviceLocationServiceAuthorization()
    }
}

// MARK: - Custom Method

extension MainViewController {
    // 1??????, ???????????? ???????????? ?????? ???????????? ???????????? ???????
    private func checkUserDeviceLocationServiceAuthorization() {
        let authorizationStatus: CLAuthorizationStatus
        
        if #available(iOS 14.0, *) {
            authorizationStatus = locationManager.authorizationStatus
        } else {
            authorizationStatus = CLLocationManager.authorizationStatus()
        }
        
        if CLLocationManager.locationServicesEnabled() {
            checkUserCurrentLocationAuthorization(authorizationStatus)
        } else {
            print("???????????? ???????????? ?????? ???????????? ?????? ????????????.")
            showLocationServiceAlert()
        }
    }
    
    // 2??????, ???????????? ?????? ????????? ???????????? ???????
    private func checkUserCurrentLocationAuthorization(_ authorizationStatus: CLAuthorizationStatus) {
        switch authorizationStatus {
        case .notDetermined:
            print("?????? ?????? ??????")
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestWhenInUseAuthorization()
            
        case .restricted, .denied:
            print("??????")
            showLocationServiceAlert()
                        
        case .authorizedWhenInUse:
            print("?????? ????????? ??????")
            locationManager.startUpdatingLocation()
            
        default: print("?????????")
        }
    }
    
    // 3??????, ?????? ????????? ????????? ?????? ?????? ????????? ?????????????????? ?????? ??????!
    private func showLocationServiceAlert() {
        let locationServiceAlert = UIAlertController(title: "?????? ?????? ??????",
                                                     message: "?????? ???????????? ????????? ??? ????????????. ????????? '??????>???????????? ??????'?????? ?????? ???????????? ????????????.",
                                                     preferredStyle: .alert)
        let settingAction = UIAlertAction(title: "???????????? ??????", style: .destructive) { _ in
            if let appSetting = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(appSetting)
            }
        }
        
        let cancelAction = UIAlertAction(title: "??????", style: .cancel)
        
        locationServiceAlert.addAction(cancelAction)
        locationServiceAlert.addAction(settingAction)
        present(locationServiceAlert, animated: true)
    }
}
