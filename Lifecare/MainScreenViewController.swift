//
//  MainScreenViewController.swift
//  Lifecare
//
//  Created by cagri calis on 6.08.2018.
//  Copyright © 2018 Cagri Mehmet Calis. All rights reserved

import UIKit
import CoreBluetooth
import Firebase
import SwiftKeychainWrapper

var bluetoothCounter:Bool = true
let MessageOptionKey = "MessageOption"
let ReceivedMessageOptionKey = "ReceivedMessageOption"
let WriteWithResponseKey = "WriteWithResponse"

var sumString = String()
var testArray2 = [String]()
let bt05ServiceCBUUID = CBUUID(string: "FFE0")
var heartRatePeripheral: CBPeripheral!
let customCharacteristicCBUUID = CBUUID(string: "FFE1")
var centralManager2: CBCentralManager!

struct MainPageContent {
    static var mainPageTableViewDictionary = [String : String]()
}

struct bodyMeasurements {
    static var vucutKutlesi = Double()
    static var bedenKutleIndeksi = String()
    static var yag = String()
    static var kas = String()
    static var sivi = String()
    static var metabolizmaHizi = String()
    static var boy = String()
    static var kilo = String()
    static var yas = String()
    static var bazalMetabolizmaHiziErkek = Double()
    static var bazalMetabolizmaHiziKadin = Double()
    static var idealVucutAgirligiErkek = Double()
    static var idealVucutAgirligiKadin = Double()
    static var yagsizVucutKutlesiErkek = Double()
    static var yagsizVucutKutlesiKadin = Double()
    static var vucutYagAgirligiErkek = Double()
    static var vucutYagAgirligiKadin = Double()
    static var vucutYagOraniErkek = Double()
    static var vucutYagOraniKadin = Double()
    static var impedance = String()
    static var bmi = Double()
    
    
    
}


class MainScreenViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    //default parameters for body meausurement
    
    let neck:Double = 50
    let waist:Double = 95
    let hip:Double = 95
    var impedance:String = "" {
        didSet {
            bodyMeasurements.impedance = self.impedance
            DispatchQueue.main.async { [unowned self] in
                DataService.ds.REF_USER_CURRENT.child("mainMeasurements").child("Vücut Empedansı").setValue(bodyMeasurements.impedance)
            }
            
            
            self.tableView.reloadData()
        }
    }

    
    @IBAction func newMeasurementButton(_ sender: Any) {
        
        MainPageContent.mainPageTableViewDictionary = testDict
        //DataService.ds.REF_USER_CURRENT.child("mainMeasurements").setValue(MainPageContent.mainPageTableViewDictionary)
        
        
        DataService.ds.REF_USER_CURRENT.child("personal").observe(.value) { (snapshot) in
            
            let value = snapshot.value as? NSDictionary
            print(value!)
            Variables.generalDictionary = value as! [String : String]
            
            print("General Dictionary: \(Variables.generalDictionary)")
            print("Kilo: \(Double(Variables.generalDictionary["Kilo"]!)!)")
            print("Boy: \(Double(Variables.generalDictionary["Boy"]!)!)")
            
            let boyInt = Double(Variables.generalDictionary["Boy"]!)
            let kiloInt = Double(Variables.generalDictionary["Kilo"]!)
            
            bodyMeasurements.vucutKutlesi = ((kiloInt!)/(pow((boyInt!/100), 2)))
            bodyMeasurements.bmi = Double(round(1000*bodyMeasurements.vucutKutlesi)/1000)
            print("BMI \(bodyMeasurements.bmi)")
            
            //BMR Bazal Metabolizama Hızı
            let calendar = NSCalendar.init(calendarIdentifier: NSCalendar.Identifier.gregorian)
            let currentYear = Double((calendar?.component(NSCalendar.Unit.year, from: Date()))!)
            let dogumTarihi = Double((Variables.generalDictionary["Doğum Tarihi"]?.suffix(4))!)
            let age = currentYear - dogumTarihi!
            
            print(age)
            
            bodyMeasurements.bazalMetabolizmaHiziErkek = 66 + (13.7*kiloInt!) + (5*boyInt!) - (6.8*age)
            bodyMeasurements.bazalMetabolizmaHiziKadin = 655 + (4.35*kiloInt!) + (4.7*boyInt!) - (4.7*age)
            print("BazalErkek: \(bodyMeasurements.bazalMetabolizmaHiziErkek)")
            print("BazalKadin: \(bodyMeasurements.bazalMetabolizmaHiziKadin)")
            
//            bodyMeasurements.yagsizVucutAgirligiKadin = (1.10 * kiloInt!) - (128 * (pow(kiloInt!, 2)/(100*(pow(boyInt!, 2)))))
//            bodyMeasurements.yagsizVucutAgirligiErkek = (1.07 * kiloInt!) - (148 * (pow(kiloInt!, 2)/(100*(pow(boyInt!, 2)))))
//           //BF= (1.2*(kilo/pow(boy,2)))+(0.23*yas)-5.4-(10.8*sex)-(0.321*(pow(boy,2)/(tot/b)))+0.154;
//
            let ffw = (1.2*(kiloInt!/pow(1.87 , 2))) + (0.23*age) - 5.4 - (10.8) - (0.321*(pow(1.87 , 2)/(24))) + 0.154
            
            print("FFW: \(ffw)")
            
//            print("YVAK: \(bodyMeasurements.yagsizVucutAgirligiKadin)")
//            print("YVAE \(bodyMeasurements.yagsizVucutAgirligiErkek)")
            
            let boyInc = (boyInt! * 0.39370)
            bodyMeasurements.idealVucutAgirligiErkek = Double(round(1000*(50 + (2.3*((boyInc) - 60))))/1000)
            
            bodyMeasurements.idealVucutAgirligiKadin = Double(round(1000*(45.5 + (2.3*((boyInc) - 60))))/1000)
            
            
            print("IVAE: \(bodyMeasurements.idealVucutAgirligiErkek)")
            print("IVAK: \(bodyMeasurements.idealVucutAgirligiKadin)")
            
            bodyMeasurements.yagsizVucutKutlesiErkek = Double(round(1000*((0.407*kiloInt!) + (0.267*boyInt!) - 19.2))/1000)
            bodyMeasurements.yagsizVucutKutlesiKadin = Double(round(1000*((0.252*kiloInt!) + (0.473*boyInt!) - 48.3))/1000)
                
            
            
            print("YCKE: \(bodyMeasurements.yagsizVucutKutlesiErkek)")
            print("YCKK: \(bodyMeasurements.yagsizVucutKutlesiKadin)")
            
            bodyMeasurements.vucutYagAgirligiErkek = kiloInt! - bodyMeasurements.yagsizVucutKutlesiErkek
            bodyMeasurements.vucutYagAgirligiKadin = kiloInt! - bodyMeasurements.yagsizVucutKutlesiKadin
            
            print("YVAE: \(bodyMeasurements.vucutYagAgirligiErkek)")
            print("YVAK: \(bodyMeasurements.vucutYagAgirligiKadin)")
            

           
            

            
            bodyMeasurements.vucutYagOraniErkek = Double(round(1000*(495/((1.0324 - (0.19077*log10(self.waist - self.neck))) + (0.15456*log10(boyInt!))) - 450))/1000)
                
            
            bodyMeasurements.vucutYagOraniKadin = Double(round(1000*(495/((1.29579 - (0.35004*log10(self.waist + self.hip - self.neck))) + (0.22100*log10(boyInt!))) - 450))/1000)
            
            
            print("vücutyagoranıerkek: \(bodyMeasurements.vucutYagOraniErkek)")
            print("vücutyagoranıkadın: \(bodyMeasurements.vucutYagOraniKadin)")
            
            
            
            if Variables.generalDictionary["Cinsiyet"] == "Erkek" {
                
                Variables.measurementsDictionary = ["BMI" : "\(bodyMeasurements.bmi)", "Yağsız Vücut Kütlesi" : "\(bodyMeasurements.yagsizVucutKutlesiErkek)", "İdeal Vücut Ağırlığı" : "\(bodyMeasurements.idealVucutAgirligiErkek)", "Vücut Yağ Oranı" : "\(bodyMeasurements.vucutYagOraniErkek)", "Bazal Metabolizma Hızı" : "\(bodyMeasurements.bazalMetabolizmaHiziErkek)", "Vücut Empedansı" : "\(bodyMeasurements.impedance)"]
                
                DataService.ds.REF_USER_CURRENT.child("mainMeasurements").setValue(Variables.measurementsDictionary)
                
            } else if Variables.generalDictionary["Cinsiyet"] == "Kadın" {
                
                               Variables.measurementsDictionary = ["BMI" : "\(bodyMeasurements.bmi)", "Yağsız Vücut Kütlesi" : "\(bodyMeasurements.yagsizVucutKutlesiKadin)", "İdeal Vücut Ağırlığı" : "\(bodyMeasurements.idealVucutAgirligiKadin)", "Vücut Yağ Oranı" : "\(bodyMeasurements.vucutYagOraniKadin)", "Bazal Metabolizma Hızı" : "\(bodyMeasurements.bazalMetabolizmaHiziKadin)", "Vücut Empedansı" : "\(bodyMeasurements.impedance)"]
                
                DataService.ds.REF_USER_CURRENT.child("mainMeasurements").setValue(Variables.measurementsDictionary)
            }
        
        }

    }
    
  
    let testDict = ["BMI" : "\(bodyMeasurements.bmi)", "Yağsız Vücut Kütlesi" : "\(bodyMeasurements.yagsizVucutKutlesiErkek)", "İdeal Vücut Ağırlığı" : "\(bodyMeasurements.idealVucutAgirligiErkek)", "Vücut Yağ Oranı" : "\(bodyMeasurements.vucutYagOraniErkek)", "Bazal Metabolizma Hızı" : "\(bodyMeasurements.bazalMetabolizmaHiziErkek)", "Vücut Empedansı" : "\(bodyMeasurements.impedance)"]
    
    var mainPageDictionary = [String : String]()
    var testArray:[String] = ["BMI", "Yağsız Vücut Kütlesi", "İdeal Vücut Ağırlığı", "Vücut Yağ Oranı", "Bazal Metabolizma Hızı", "Vücut Empedansı"]
    var detailedArray: [String] = ["default", "default", "default", "default", "default", "default"]
    
    
    
    

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        centralManager2 = CBCentralManager(delegate: self, queue: nil)
        
        //serial.writeType = UserDefaults.standard.bool(forKey: WriteWithResponseKey) ? .withResponse : .withoutResponse
        setMainPageDictionary()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
//    func serialDidChangeState() {
//
//        if serial.centralManager.state != .poweredOn {
//
//            print("Bluetooth turned off")
//
//
//        }
//    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return testArray.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell =  tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MainPageTableViewCell
        cell.mainLabel.text = testArray[indexPath.row]
        cell.detailLabel.text = detailedArray[indexPath.row]
        
        return cell
    }
    
    func setMainPageDictionary() {
        
        DataService.ds.REF_USER_CURRENT.child("mainMeasurements").observe(.value) { (snapshot) in
            
            if let value = snapshot.value as? NSDictionary {
            
                print(value)
            self.mainPageDictionary = value as! [String : String]
            
            self.testArray.removeAll()
            self.detailedArray.removeAll()
            
            
            for (key, value) in self.mainPageDictionary {
                
                self.testArray.append(key)
                self.detailedArray.append(value)
                print(self.testArray)
            }
            
            self.tableView.reloadData()
            
            }
        }
        
    }
    

}

extension MainScreenViewController: CBCentralManagerDelegate {
    
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
            centralManager2.scanForPeripherals(withServices: [bt05ServiceCBUUID])
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        print(peripheral)
        heartRatePeripheral = peripheral
        centralManager2.stopScan()
        centralManager2.connect(heartRatePeripheral)
        heartRatePeripheral.delegate = self
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        print("connected")
        //heartRatePeripheral.discoverServices(nil)
        heartRatePeripheral.discoverServices([bt05ServiceCBUUID])
    }
    
}

extension MainScreenViewController: CBPeripheralDelegate {
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
            if let data = characteristic.value, let string = String(data: data, encoding: .utf8) {
                
                print("String: \(string)")
                
               testArray2.append(string)
                
                if let index = testArray2.index(of: "\u{01}") {
                    testArray2.remove(at: index)
                }
                
                if let index2 = testArray2.index(of: "\0") {
                    testArray2.remove(at: index2)
                }
            
                
                //sumString = sumString + string
                //print("SumString:  \(sumString)")
                print("TestArray:  \(testArray2)")
                
                if testArray2.count == 2 {
                    sumString = testArray2[0] + testArray2[1]
                    testArray2.removeAll()
                    print("SumString:  \(sumString)")
                    
                    bodyMeasurements.impedance = sumString
                    
                    let c = sumString.characters
                    // Get character indexes.
                    let indexE = c.index(of:"e")!
                    let indexE2 = c.index(of:"e")!
                    let indexR = c.index(of: "r")!
                    let indexI = c.index(of: "i")!
                    let indexAfterI = c.index(after: indexI)
                    
                    let impedanceString1 = String(sumString[...indexI])
                    let impedanceString2 = String(sumString[indexAfterI..<sumString.endIndex])
                    
                    print("IMPEDANSSTRING1: \(impedanceString1)")
                    print("IMPEDANSSTRING2: \(impedanceString2)")
                    
                    let impedanceString2Index = impedanceString2.characters.index(of:"e")!
                    
                    // Get before and after indexes.
                    // let indexBeforeE = c.index(before: indexE)
                    // let indexAfterE = c.index(after: indexE)
                
                    
                    var firstimpedance = impedanceString1[..<indexE]
                    var secondimpedance = impedanceString2[..<impedanceString2Index]
                    
                    print("FIRST: \(firstimpedance)")
                    print("SECOND: \(secondimpedance)")
                   
                    let realImpedance = round((((Double(firstimpedance)! + Double(secondimpedance)!)/2)/1.7)*1000)/1000
                    
                    print("REALIMPEDANCE \(realImpedance)")
                    
                    self.impedance = String(realImpedance)
                    

                }
                

            } else {
                print("No response!")
            }
        default:
            print("Unhandled Characteristic UUID: \(characteristic.uuid)")
        }
    }
    
}


