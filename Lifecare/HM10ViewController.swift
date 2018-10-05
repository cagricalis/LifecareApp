//
//  HM10ViewController.swift
//  Lifecare
//
//  Created by cagri calis on 29.08.2018.
//  Copyright © 2018 Cagri Mehmet Calis. All rights reserved.
//


import UIKit
import CoreBluetooth


class HM10ViewController: UIViewController {
    
    var sumString = String()

    var centralManager: CBCentralManager!
    let bt05ServiceCBUUID = CBUUID(string: "FFE0")
    var bt05Peripheral: CBPeripheral!
    let customCharacteristicCBUUID = CBUUID(string: "FFE1")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        centralManager = CBCentralManager(delegate: self, queue: nil)
        
        // Make the digits monospaces to avoid shifting when the numbers change
        //heartRateLabel.font = UIFont.monospacedDigitSystemFont(ofSize: heartRateLabel.font!.pointSize, weight: .regular)
    }
    

}

extension HM10ViewController: CBCentralManagerDelegate {
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch central.state {
            
            
        case .unknown:
            print("unknown")
        case .resetting:
            print("resetting")
        case .unsupported:
            print("unsupported")
        case .unauthorized:
            print("unauthorized")
        case .poweredOff:
            print("poweredOff")
        case .poweredOn:
            print("poweredOn")
            centralManager.scanForPeripherals(withServices: [bt05ServiceCBUUID])
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        print(peripheral)
        bt05Peripheral = peripheral
        centralManager.stopScan()
        centralManager.connect(bt05Peripheral)
        bt05Peripheral.delegate = self
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        print("connected")
        //heartRatePeripheral.discoverServices(nil)
        bt05Peripheral.discoverServices([bt05ServiceCBUUID])
    }
    
}

extension HM10ViewController: CBPeripheralDelegate {
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        guard let services = peripheral.services else {return}
        for service in services {
            print(service)
            peripheral.discoverCharacteristics(nil, for: service)
            print(service.characteristics ?? "characteristics are nil")
        }
        
    }
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService,
                    error: Error?) {
        guard let characteristics = service.characteristics else { return }
        
        for characteristic in characteristics {
            print(characteristic)
            peripheral.setNotifyValue(true, for: characteristic)
            peripheral.readValue(for: characteristic)
            
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic,
                    error: Error?) {
        switch characteristic.uuid {
        case customCharacteristicCBUUID:
            //print(characteristic.value ?? "no value")
            print(characteristic)
            if let data = characteristic.value, let string = String(data: data, encoding: String.Encoding.utf8) {
                print(string)
                
                sumString = sumString + string
                print(sumString)
                
                
            } else {
                print("No response!")
            }
        default:
            print("Unhandled Characteristic UUID: \(characteristic.uuid)")
        }
    }
    
}
