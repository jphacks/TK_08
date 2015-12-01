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
    
    let appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    // LocationManager.
    var myPheripheralManager:CBPeripheralManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // PeripheralManagerを定義.
        myPheripheralManager = CBPeripheralManager(delegate: self, queue: nil)
    }
    
    func peripheralManagerDidUpdateState(peripheral: CBPeripheralManager) {
        
        // iBeaconのUUID.
        let myProximityUUID = NSUUID(UUIDString: "B9407F30-F5F8-466E-AFF9-33333B57FE6D")
        
        // iBeaconのIdentifier.
        let myIdentifier = "AirMeer"
        
        //サーバーからMajorを受けとり
        print("Make AirMeet Sucsess [ \(appDelegate.parentID!) ]")
        
        let myMajor : CLBeaconMajorValue = UInt16(appDelegate.parentID!)!
        
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
