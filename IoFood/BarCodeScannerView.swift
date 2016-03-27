//
//  BarCodeScannerView.swift
//  IoFood
//
//  Created by Wilson Ding on 3/26/16.
//  Copyright © 2016 Wilson Ding. All rights reserved.
//

import AVFoundation
import UIKit
import Firebase
import Alamofire

class BarCodeScannerView: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    
    var captureSession: AVCaptureSession!
    var previewLayer: AVCaptureVideoPreviewLayer!
    
    var lastReadValue = 0
    var lastReadTime: Double = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.blackColor()
        captureSession = AVCaptureSession()
        
        let videoCaptureDevice = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
        let videoInput: AVCaptureDeviceInput
        
        do {
            videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
        } catch {
            return
        }
        
        if (captureSession.canAddInput(videoInput)) {
            captureSession.addInput(videoInput)
        } else {
            failed();
            return;
        }
        
        let metadataOutput = AVCaptureMetadataOutput()
        
        if (captureSession.canAddOutput(metadataOutput)) {
            captureSession.addOutput(metadataOutput)
            
            metadataOutput.setMetadataObjectsDelegate(self, queue: dispatch_get_main_queue())
            metadataOutput.metadataObjectTypes = [AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypePDF417Code]
        } else {
            failed()
            return
        }
        
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession);
        previewLayer.frame = view.layer.bounds;
        previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
        view.layer.addSublayer(previewLayer);
        
        captureSession.startRunning();
    }
    
    func failed() {
        let ac = UIAlertController(title: "Scanning not supported", message: "Your device does not support scanning a code from an item. Please use a device with a camera.", preferredStyle: .Alert)
        ac.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
        presentViewController(ac, animated: true, completion: nil)
        captureSession = nil
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if (captureSession?.running == false) {
            captureSession.startRunning();
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        if (captureSession?.running == true) {
            captureSession.stopRunning();
        }
    }
    
    func captureOutput(captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [AnyObject]!, fromConnection connection: AVCaptureConnection!) {

        if let metadataObject = metadataObjects.first {
            let readableObject = metadataObject as! AVMetadataMachineReadableCodeObject;
            
            foundCode(readableObject.stringValue);
        }
    }
    
    func addDataToFirebase(upc: String, quantity: String){
        let date = NSDate()
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components([.Day, .Month, .Hour, .Minute, .Second], fromDate: date)
        let month = components.month
        let day = components.day
        let hour = components.hour
        let minutes = components.minute
        let seconds = components.second
        let digitHour = String(format: "%02d", hour) // returns "01"
        let digitMinute = String(format: "%02d", minutes) // returns "01"
        let digitDay = String(format: "%02d", day) // returns "01"
        let digitMonth = String(format: "%02d", month) // returns "01"
        let digitSecond = String(format: "%02d", seconds) // returns "01"
        
        let currentString :String = upc + "&" + quantity + "&2016" + digitMonth + digitDay + "&" + digitHour + digitMinute + digitSecond
        let url = "http://inoutfood.herokuapp.com/update/\(currentString)"
        print(url)
        Alamofire.request(.GET, url).validate().responseJSON {_ in
        }
    }
    
    func time() -> Double {
        let date = NSDate()
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components([.Day, .Month, .Hour, .Minute, .Second], fromDate: date)
        let month = components.month
        let day = components.day
        let hour = components.hour
        let minutes = components.minute
        let seconds = components.second
        let digitHour = String(format: "%02d", hour) // returns "01"
        let digitMinute = String(format: "%02d", minutes) // returns "01"
        let digitDay = String(format: "%02d", day) // returns "01"
        let digitMonth = String(format: "%02d", month) // returns "01"
        let digitSecond = String(format: "%02d", seconds) // returns "01"
        
        let currentTime : Double = Double(digitMonth + digitDay + digitHour + digitMinute + digitSecond)!
        
        print(currentTime)
        
        return currentTime
    }
    
    func foundCode(code: String) {
        let code = String(code.characters.dropFirst())
        
        if time() != lastReadTime {
            lastReadValue = Int(code)!
            lastReadTime = time()
            print(code)
            
            let quantity = "-1"
            
            addDataToFirebase(code, quantity: quantity)
            
            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
        }
        
        else if Int(code) != lastReadValue {
            lastReadValue = Int(code)!
            lastReadTime = time()
            print(code)
            
            let quantity = "-1"
            
            addDataToFirebase(code, quantity: quantity)
            
            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
        }
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return .Portrait
    }
}