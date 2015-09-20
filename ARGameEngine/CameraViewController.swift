//
//  CameraViewController.swift
//  ARGameEngine
//
//  Created by Manjot Sangha on 2015-09-19.
//  Copyright (c) 2015 Manjot Sangha. All rights reserved.
//

import UIKit
import AVFoundation

class CameraViewController: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate {
    
    private let captureSession = AVCaptureSession()
    private var captureDevice: AVCaptureDevice?
    private var previewLayer: AVCaptureVideoPreviewLayer?
    //private let dataOutput = AVCaptureVideoDataOutput()
    
    
    var imageView: UIImageView = UIImageView()
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func shouldAutorotate() -> Bool {
        return false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView.frame = self.view.layer.frame
        self.view.addSubview(imageView)
        
        captureSession.sessionPreset = AVCaptureSessionPresetHigh
        
        let devices = AVCaptureDevice.devices()
        for device in devices {
            if (device.hasMediaType(AVMediaTypeVideo)) {
                if (device.position == AVCaptureDevicePosition.Back) {
                    captureDevice = device as? AVCaptureDevice
                }
            }
        }
        
        if (captureDevice != nil) {
            beginSession()
        }
    }
    
    private func beginSession() {
        var error: NSError?
        
        captureSession.addInput(AVCaptureDeviceInput(device: captureDevice, error: &error))

        if (error != nil) {
            println("Error: \(error?.description)")
        }
        
        let dataOutput = AVCaptureVideoDataOutput()
        
        dataOutput.alwaysDiscardsLateVideoFrames = true
        dataOutput.videoSettings = [kCVPixelBufferPixelFormatTypeKey: kCVPixelFormatType_420YpCbCr8BiPlanarFullRange]
        dataOutput.setSampleBufferDelegate(self, queue: dispatch_get_main_queue())
        
        captureSession.addOutput(dataOutput)

        captureSession.startRunning()
        
        /*
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        
        UIGraphicsBeginImageContext(previewLayer!.bounds.size)
        previewLayer?.renderInContext(UIGraphicsGetCurrentContext())
        //var cgImage: CGImageRef = CGBitmapContextCreateImage(UIGraphicsGetCurrentContext())
        UIGraphicsEndImageContext();
        
        //var ciImage: CIImage = CIImage(CGImage: cgImage)
        
        self.view.layer.addSublayer(previewLayer)
        previewLayer?.frame = self.view.layer.frame
        captureSession.startRunning()
        */
    }
    
    func mockChangeImage(image: CIImage) -> CIImage {
        return image
    }
    
    func captureOutput(captureOutput: AVCaptureOutput!, didOutputSampleBuffer sampleBuffer: CMSampleBuffer!, fromConnection connection: AVCaptureConnection!) {
        var imageRotationMatrix = CGAffineTransformMakeRotation(CGFloat(-1*M_PI_2))
        var ciImage: CIImage = CIImage(CVPixelBuffer: CMSampleBufferGetImageBuffer(sampleBuffer)).imageByApplyingTransform(imageRotationMatrix)
        var newCIImage: CIImage = mockChangeImage(ciImage)
        var uiImage: UIImage = UIImage(CIImage: newCIImage)!
        imageView.image = uiImage
    }
    
}


