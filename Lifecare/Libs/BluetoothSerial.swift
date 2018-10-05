//
//  BluetoothSerial.swift
//  Lifecare
//
//  Created by cagri calis on 8.08.2018.
//  Copyright © 2018 Cagri Mehmet Calis. All rights reserved.
//

import UIKit
import CoreBluetooth

/// Global serial handler, don't forget to initialize it with init(delgate:)
var serial: BluetoothSerial!

// Delegate functions
protocol BluetoothSerialDelegate {
    // ** Required **
    
    /// Called when de state of the CBCentralManager changes (e.g. when bluetooth is turned on/off)
    func serialDidChangeState()
    
    /// Called when a peripheral disconnected
    func serialDidDisconnect(_ peripheral: CBPeripheral, error: NSError?)
    
    // ** Optionals **
    
    /// Called when a message is received
    func serialDidReceiveString(_ message: String)
    
    /// Called when a message is received
    func serialDidReceiveBytes(_ bytes: [UInt8])
    
    /// Called when a message is received
    func serialDidReceiveData(_ data: Data)
    
    /// Called when the RSSI of the connected peripheral is read
    func serialDidReadRSSI(_ rssi: NSNumber)
    
    /// Called when a new peripheral is discovered while scanning. Also gives the RSSI (signal strength)
    func serialDidDiscoverPeripheral(_ peripheral: CBPeripheral, RSSI: NSNumber?)
    
    /// Called when a peripheral is connected (but not yet ready for communication)
    func serialDidConnect(_ peripheral: CBPeripheral)
    
    /// Called when a pending connection failed
    func serialDidFailToConnect(_ peripheral: CBPeripheral, error: NSError?)
    
    /// Called when a peripheral is ready for communication
    func serialIsReady(_ peripheral: CBPeripheral)
}

// Make some of the delegate functions optional
extension BluetoothSerialDelegate {
    func serialDidReceiveString(_ message: String) {}
    func serialDidReceiveBytes(_ bytes: [UInt8]) {}
    func serialDidReceiveData(_ data: Data) {}
    func serialDidReadRSSI(_ rssi: NSNumber) {}
    func serialDidDiscoverPeripheral(_ peripheral: CBPeripheral, RSSI: NSNumber?) {}
    func serialDidConnect(_ peripheral: CBPeripheral) {}
    func serialDidFailToConnect(_ peripheral: CBPeripheral, error: NSError?) {}
    func serialIsReady(_ peripheral: CBPeripheral) {}
}


final class BluetoothSerial: NSObject, CBCentralManagerDelegate, CBPeripheralDelegate {
    
    //MARK: Variables
    
    var mainScreenVC:MainScreenViewController!
    
    /// The delegate object the BluetoothDelegate methods will be called upon
    var delegate: BluetoothSerialDelegate!
    
    /// The CBCentralManager this bluetooth serial handler uses for... well, everything really
    var centralManager: CBCentralManager!
    
    /// The peripheral we're trying to connect to (nil if none)
    var pendingPeripheral: CBPeripheral?
    
    /// The connected peripheral (nil if none is connected)
    var connectedPeripheral: CBPeripheral?
    
    /// The characteristic 0xFFE1 we need to write to, of the connectedPeripheral
    weak var writeCharacteristic: CBCharacteristic?
    
    /// Whether this serial is ready to send and receive data
    var isReady: Bool {
        get {
            return centralManager.state == .poweredOn &&
                connectedPeripheral != nil &&
                writeCharacteristic != nil
        }
    }
    
    /// CC2650's writeType is .withRespose do not use .withoutResponse
    var writeType: CBCharacteristicWriteType = .withResponse
    
    
    //MARK: functions
    
    /// Always use this to initialize an instance
    init(delegate: BluetoothSerialDelegate) {
        super.init()
        self.delegate = delegate
        centralManager = CBCentralManager(delegate: self, queue: nil)
    }
    
    /// Start scanning for peripherals
    func startScan() {
        guard centralManager.state == .poweredOn else { return }
        
        print(centralManager.isScanning.description)
        
        // start scanning for peripherals with correct service UUID
        
        
        let uuid = CBUUID(string: "0x180A")

        print(uuid.uuidString)
        print(uuid.data)

        
        centralManager.scanForPeripherals(withServices: [uuid], options: nil)

        let peripherals = centralManager.retrieveConnectedPeripherals(withServices: [uuid])
        print(self.centralManager.scanForPeripherals(withServices: nil, options: nil))
        
        print(peripherals)
        
        
        
        // let peripherals = centralManager.retrieveConnectedPeripherals(withServices: [uuid])
        for peripheral in peripherals {
            
            print(peripheral)
            
            let StrenghtOfRSSI = peripheral.readRSSI()
            delegate.serialDidDiscoverPeripheral(peripheral, RSSI: nil)
            
        }
    }
    
    /// Stop scanning for peripherals
    func stopScan() {
        centralManager.stopScan()
    }
    
    /// Try to connect to the given peripheral
    func connectToPeripheral(_ peripheral: CBPeripheral) {
        pendingPeripheral = peripheral
        centralManager.connect(peripheral, options: nil)
    }
    
    /// Disconnect from the connected peripheral or stop connecting to it
    func disconnect() {
        if let p = connectedPeripheral {
            centralManager.cancelPeripheralConnection(p)
        } else if let p = pendingPeripheral {
            centralManager.cancelPeripheralConnection(p) //TODO: Test whether its neccesary to set p to nil
        }
    }
    
    /// The didReadRSSI delegate function will be called after calling this function
    func readRSSI() {
        guard isReady else { return }
        connectedPeripheral!.readRSSI()
    }
    
    /// Send a string to the device
    func sendMessageToDevice(_ message: String) {
        guard isReady else { return }
        
        //  connectedPeripheral?.writeValue(message, for: writeCharacteristic!, type: .withResponse)
        
        if let data = message.data(using: String.Encoding.init(rawValue: UInt(message)!)) {

            connectedPeripheral?.writeValue(data, for: writeCharacteristic!, type: .withResponse)
            print(connectedPeripheral)
 
        }
        
        

    }
    
    /// Send an array of bytes to the device
    func sendBytesToDevice(_ bytes: [UInt8]) {
        guard isReady else { return }
        
        let data = Data(bytes: UnsafePointer<UInt8>(bytes), count: bytes.count)
        connectedPeripheral!.writeValue(data, for: writeCharacteristic!, type: .withResponse)
        
    }
    
    /// Send data to the device
    func sendDataToDevice(_ data: Data) {
        guard isReady else { return }
        
        
        connectedPeripheral!.writeValue(data, for: writeCharacteristic!, type: writeType)
    }
    
    
    //MARK: CBCentralManagerDelegate functions
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        // just send it to the delegate
        delegate.serialDidDiscoverPeripheral(peripheral, RSSI: RSSI)
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        // set some stuff right
        peripheral.delegate = self
        pendingPeripheral = nil
        connectedPeripheral = peripheral
        print(connectedPeripheral)
        
        // send it to the delegate
        delegate.serialDidConnect(peripheral)
        
        
        peripheral.discoverServices([CBUUID(string: "F0001110-0451-4000-B000-000000000000")])
        print(peripheral.discoverServices([CBUUID(string: "F0001110-0451-4000-B000-000000000000")]))

    }
    
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        connectedPeripheral = nil
        pendingPeripheral = nil
        
        // send it to the delegate
        delegate.serialDidDisconnect(peripheral, error: error as NSError?)
    }
    
    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        pendingPeripheral = nil
        
        // just send it to the delegate
        delegate.serialDidFailToConnect(peripheral, error: error as NSError?)
    }
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        // note that "didDisconnectPeripheral" won't be called if BLE is turned off while connected
        connectedPeripheral = nil
        pendingPeripheral = nil
        
        // send it to the delegate
        delegate.serialDidChangeState()

    }
    
    
    //MARK: CBPeripheralDelegate functions
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        // discover the 0xFFE1 characteristic for all services (though there should only be one)
        
        
        
        //peripheral.discoverServices([CBUUID(string: "0x180A")])
        print(peripheral.services)
        for service in peripheral.services! {
            print(service)
            
            peripheral.discoverCharacteristics(nil, for: service)
            
            //peripheral.discoverCharacteristics([CBUUID(string: "F0001111-0451-4000-B000-000000000000")], for: service)
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        // check whether the characteristic we're looking for (0x180A) is present - just to be sure
        
        //print(service.characteristics!)
        
        for characteristic in service.characteristics! {

            
   
            if bluetoothCounter == false {
                
                print(characteristic)
                if characteristic.uuid == CBUUID(string: "F0001112-0451-4000-B000-000000000000") {
                    // subscribe to this value (so we'll get notified when there is serial data for us..)
                    peripheral.setNotifyValue(true, for: characteristic)
                    
                    // keep a reference to this characteristic so we can write to it
                    writeCharacteristic = characteristic
                    
                    // notify the delegate we're ready for communication
                    delegate.serialIsReady(peripheral)
                }
                
            } else {
                
                print(characteristic)
                if characteristic.uuid == CBUUID(string: "F0001113-0451-4000-B000-000000000000") {
                    // subscribe to this value (so we'll get notified when there is serial data for us..)
                    peripheral.setNotifyValue(true, for: characteristic)
                    
                    // keep a reference to this characteristic so we can write to it
                    writeCharacteristic = characteristic
                    
                    // notify the delegate we're ready for communication
                    delegate.serialIsReady(peripheral)
                }
                
            }
            
            
            
        }
        
        
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        // notify the delegate in different ways
        
        let data = characteristic.value
        print(data)
        guard data != nil else { return }
        
        // first the data
        delegate.serialDidReceiveData(data!)
        
        // then the string
        if let str = String(data: data!, encoding: String.Encoding.utf8) {
            delegate.serialDidReceiveString(str)
        } else {
            print("Received an invalid string!")
        }

    }
    
    func peripheral(_ peripheral: CBPeripheral, didReadRSSI RSSI: NSNumber, error: Error?) {
        delegate.serialDidReadRSSI(RSSI)
    }
}
