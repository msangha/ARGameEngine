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
    private var imageView: UIImageView = UIImageView()
    var displayVideo: Bool = false {
        didSet{
            if displayVideo {
                captureSession.startRunning()
            } else {
                captureSession.stopRunning()
            }
        }
    }
    
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
            setupSession()
        }
        
        // for testing
        displayVideo = true
    }
    
    private func setupSession() {
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


