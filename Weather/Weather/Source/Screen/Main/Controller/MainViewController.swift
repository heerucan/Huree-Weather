//
//  MainViewController.swift
//  Weather
//
//  Created by heerucan on 2022/08/15.
//

import UIKit

import CoreLocation

final class MainViewController: UIViewController {
    
    // MARK: - Property
    
    private let locationManager = CLLocationManager()
    
    var latitude = 37.552102211961085
    var longitude = 126.95587037133782

    // MARK: - @IBOutlet
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var windLabel: UILabel!
    @IBOutlet weak var commentLabel: UILabel!
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet var backView: [UIView]!
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        setupCoreLocation()
        requestWeather()
    }
    
    // MARK: - Configure UI & Layout
    
    private func configureUI() {
        dateLabel.text = getCurrentTime()
        backView.forEach { $0.makeRound(10) }
        backgroundImageView.backgroundColor = .orange
    }
    
    // MARK: - @IBAction
    
    @IBAction func touchupLocationButton(_ sender: UIButton) {
        
    }
    
    // MARK: - Custom Method
    
    private func setupCoreLocation() {
        locationManager.delegate = self
    }
    
    private func getCurrentTime() -> String {
        let now = Date()
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "MM월 dd일(EEEEE) hh시 mm분"
        return formatter.string(from: now)
    }
    
    // MARK: - Network
    
    func requestWeather() {
        WeatherManager.shared.requestWeather(lat: latitude, lon: longitude) { json in
//            print(json)
        }
    }

}

// MARK: - CLLocationManagerDelegate

extension MainViewController: CLLocationManagerDelegate {
    // 위치 정보를 성공적으로 가져온 경우
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let coordinate = locations.last?.coordinate {
            latitude = coordinate.latitude
            longitude = coordinate.longitude
        }
        locationManager.stopUpdatingLocation()
    }
    
    // 위치 정보를 가져오지 못한 경우
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("💥 위치 정보를 가져오지 못했습니다!")
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
    // 1단계, 디바이스 자체에서 위치 서비스가 켜져있긴 하니?
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
            print("디바이스 자체에서 위치 서비스가 꺼져 있습니다.")
            showLocationServiceAlert()
        }
    }
    
    // 2단계, 사용자가 위치 권한을 허용하긴 했니?
    private func checkUserCurrentLocationAuthorization(_ authorizationStatus: CLAuthorizationStatus) {
        switch authorizationStatus {
        case .notDetermined:
            print("아직 결정 안함")
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestWhenInUseAuthorization()
            
        case .restricted, .denied:
            print("거부")
            showLocationServiceAlert()
                        
        case .authorizedWhenInUse:
            print("사용 시에만 허용")
            locationManager.startUpdatingLocation()
            
        default: print("디폴트")
        }
    }
    
    // 3단계, 위치 서비스 자체가 꺼져 있을 경우에 환경설정으로 가게 하자!
    private func showLocationServiceAlert() {
        let locationServiceAlert = UIAlertController(title: "위치 정보 이용",
                                                     message: "위치 서비스를 사용할 수 없습니다. 기기의 '설정>개인정보 보호'에서 위치 서비스를 켜주세요.",
                                                     preferredStyle: .alert)
        let settingAction = UIAlertAction(title: "설정으로 이동", style: .destructive) { _ in
            if let appSetting = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(appSetting)
            }
        }
        
        let cancelAction = UIAlertAction(title: "취소", style: .cancel)
        
        locationServiceAlert.addAction(cancelAction)
        locationServiceAlert.addAction(settingAction)
        present(locationServiceAlert, animated: true)
    }
}
