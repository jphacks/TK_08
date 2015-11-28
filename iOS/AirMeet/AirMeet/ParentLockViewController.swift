//
//  ParentLockViewController.swift
//  AirMeet
//
//  Created by koooootake on 2015/11/28.
//  Copyright © 2015年 koooootake. All rights reserved.
//

import UIKit
import CoreLocation
import CoreBluetooth

class ParentLockSettingViewController: UIViewController , CBPeripheralManagerDelegate{
    
    // LocationManager.
    var myPheripheralManager:CBPeripheralManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("send")
        
        //magerがかえってきた前提
        // PeripheralManagerを定義.
        myPheripheralManager = CBPeripheralManager(delegate: self, queue: nil)
    }
    
    func peripheralManagerDidUpdateState(peripheral: CBPeripheralManager) {
        
        // iBeaconのUUID.
        //アプリであらかじめ決められたもの
        let myProximityUUID = NSUUID(UUIDString: "B9407F30-F5F8-466E-AFF9-33333B57FE6D")
        
        // iBeaconのIdentifier.
        let myIdentifier = "AirMeer"
        
        // Major.
        //サーバーから値を受け取ったと仮定
        let myMajor : CLBeaconMajorValue = 510
        
        // BeaconRegionを定義.
        let myBeaconRegion = CLBeaconRegion(proximityUUID: myProximityUUID!, major: myMajor, identifier: myIdentifier)
        
        // Advertisingのフォーマットを作成.
        let myBeaconPeripheralData = NSDictionary(dictionary: myBeaconRegion.peripheralDataWithMeasuredPower(nil))
        
        // Advertisingを発信.
        myPheripheralManager.startAdvertising(myBeaconPeripheralData as? [String : AnyObject])
    }

    
    //終了
    @IBAction func ParentStopButton(sender: AnyObject) {
        
        self.navigationController?.popToRootViewControllerAnimated(true)
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
