//
//  ViewController.swift
//  compassApp
//
//  Created by Kazama Ryusei on 2017/03/09.
//  Copyright © 2017年 Malfoy. All rights reserved.
//

import UIKit
import CoreLocation

@available(iOS 10.0, *)
class ViewController: UIViewController, CLLocationManagerDelegate, UITextFieldDelegate {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var compassLabel: UILabel!
    
    var locationManager: CLLocationManager!
    let generator = UIImpactFeedbackGenerator(style: .medium)
    
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted, .denied:
            break
        case .authorizedAlways, .authorizedWhenInUse:
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        // コンパスの値を表示
        compassLabel.text = "".appendingFormat("%.2f", newHeading.magneticHeading)
        // imageView回転コード
        let rt = CGFloat(2*M_PI*newHeading.magneticHeading/360.0)
        imageView.transform = CGAffineTransform(rotationAngle: rt)
        if newHeading.magneticHeading >= 0.0 && newHeading.magneticHeading < 0.2 {
            generator.impactOccurred()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        if CLLocationManager.locationServicesEnabled() {
            locationManager = CLLocationManager()
            locationManager.delegate = self
            
            // 何度か動いたら更新する(デフォルトは1度)
            locationManager.headingFilter = kCLHeadingFilterNone
            
            // デバイスのどの向きを北にするか (デフォルトは画面上部が北)
            locationManager.headingOrientation = .portrait
            
            locationManager.startUpdatingHeading()
            
            // イメージ画像の読み込み
            let myImage = UIImage(named: "にゃんちゅう.jpg")
            imageView.image = myImage
            
            // 触覚フィードバック準備
            generator.prepare()
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        if CLLocationManager.locationServicesEnabled(){
            locationManager.stopUpdatingHeading()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

