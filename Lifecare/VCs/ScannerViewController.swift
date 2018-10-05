//
//  ScannerViewController.swift
//  Created by cagri calis on 8.08.2018.
//

import UIKit
import CoreBluetooth




class ScannerViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, BluetoothSerialDelegate{
    
    
    
    @IBAction func tryAgain(_ sender: Any) {
        
        // empty array an start again
        peripherals = []
        tableView.reloadData()
        tryAgainButton.isEnabled = false
        title = "Scanning ..."
        serial.startScan()
        Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(ScannerViewController.scanTimeOut), userInfo: nil, repeats: false)
        
        
    }
    
    @IBAction func cancel(_ sender: Any) {
        serial.stopScan()
        dismiss(animated:true, completion: nil)
        
    }
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tryAgainButton: UIBarButtonItem!
    
    //MARK: Variables
    
    /// The peripherals that have been discovered (no duplicates and sorted by asc RSSI)
    var peripherals: [(peripheral: CBPeripheral, RSSI: Float)] = []
    
    /// The peripheral the user has selected
    var selectedPeripheral: CBPeripheral?
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        // tryAgainButton is only enabled when we've stopped scanning
        tryAgainButton.isEnabled = false
        
        // remove extra seperator insets (looks better imho)
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        
        // tell the delegate to notificate US instead of the previous view if something happens
        serial.delegate = self
        
        if serial.centralManager.state != .poweredOn {
            title = "Bluetooth not turned on"
            return
        }
        
        // start scanning and schedule the time out
        serial.startScan()
        Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(ScannerViewController.scanTimeOut), userInfo: nil, repeats: false)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /// Should be called 10s after we've begun scanning
    @objc func scanTimeOut() {
        // timeout has occurred, stop scanning and give the user the option to try again
        serial.stopScan()
        tryAgainButton.isEnabled = true
        title = "Done scanning"
    }
    
    /// Should be called 10s after we've begun connecting
    @objc func connectTimeOut() {
        
        // don't if we've already connected
        if let _ = serial.connectedPeripheral {
            return
        }
        

        
        if let _ = selectedPeripheral {
            serial.disconnect()
            selectedPeripheral = nil
        }
        

    }
    
    
    
    
    //MARK: UITableViewDataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        print(peripherals.count)
        return peripherals.count
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // return a cell with the peripheral name as text in the label
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        //let label = cell?.viewWithTag(1) as! UILabel!
        
        
        cell?.textLabel?.text = peripherals[(indexPath as NSIndexPath).row].peripheral.name
        
        
        
        //label?.text = peripherals[indexPath.row].peripheral.name
        //label?.text = "Onlock Digit"
        print(peripherals[indexPath.row].peripheral.name)
        return cell!
    }
    
    
    //MARK: UITableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        // the user has selected a peripheral, so stop scanning and proceed to the next view
        serial.stopScan()
        selectedPeripheral = peripherals[(indexPath as NSIndexPath).row].peripheral
        serial.connectToPeripheral(selectedPeripheral!)

        
        Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(ScannerViewController.connectTimeOut), userInfo: nil, repeats: false)
    }
    
    
    //MARK: BluetoothSerialDelegate
    
    
    
    func serialDidDiscoverPeripheral(_ peripheral: CBPeripheral, RSSI: NSNumber?) {
        // check whether it is a duplicate
        for exisiting in peripherals {
            if exisiting.peripheral.identifier == peripheral.identifier { return }
        }
        
        // add to the array, next sort & reload
        let theRSSI = RSSI?.floatValue ?? 0.0
        print(theRSSI)
        peripherals.append((peripheral: peripheral, RSSI: theRSSI))
        print(peripherals)
        peripherals.sorted { $0.RSSI < $1.RSSI }
        tableView.reloadData()
    }
    
    func serialDidFailToConnect(_ peripheral: CBPeripheral, error: NSError?) {

        
        tryAgainButton.isEnabled = true
        
    }
    
    func serialDidDisconnect(_ peripheral: CBPeripheral, error: NSError?) {

        
        tryAgainButton.isEnabled = true
        
        
    }
    
    func serialIsReady(_ peripheral: CBPeripheral) {
 
        
        NotificationCenter.default.post(name: Notification.Name(rawValue: "mainScreenVC"), object: self)
        dismiss(animated: true, completion: nil)
    }
    
    func serialDidChangeState() {

        
        if serial.centralManager.state != .poweredOn {
            NotificationCenter.default.post(name: Notification.Name(rawValue: "reloadStartViewController"), object: self)
            dismiss(animated: true, completion: nil)
        }
    }
}
