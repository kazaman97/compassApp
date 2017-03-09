//
//  ViewController.swift
//  compassApp
//
//  Created by Kazama Ryusei on 2017/03/09.
//  Copyright © 2017年 Malfoy. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate, UITextFieldDelegate {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var compassTF: UITextField!
    
    var locationManager: CLLocationManager!
    
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
        compassTF.text = "".appendingFormat("%.2f", newHeading.magneticHeading)
        // imageView回転コード
        let rt = CGFloat(2*M_PI*newHeading.magneticHeading/360.0)
        imageView.transform = CGAffineTransform(rotationAngle: rt)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        compassTF.resignFirstResponder()
        return true
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
            
            // キーボードのデリゲート処理
            compassTF.delegate = self
            compassTF.returnKeyType = .done
            
            let myImage = UIImage(named: "にゃんちゅう.jpg")
            imageView.image = myImage
            
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

