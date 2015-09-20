//
//  CameraViewController.swift
//  ARGameEngine
//
//  Created by Manjot Sangha on 2015-09-19.
//  Copyright (c) 2015 Manjot Sangha. All rights reserved.
//

import UIKit
import AVFoundation

class CameraFeedViewController: UIViewController {

    var done = false;
    var previewView: UIView!;
    var videoDataOutput: AVCaptureVideoDataOutput!;
    var videoDataOutputQueue : dispatch_queue_t!;
    var previewLayer:CALayer!;
    var captureDevice : AVCaptureDevice!
    let session=AVCaptureSession();
    var currentFrame:CIImage!
    var displayEngine = DisplayEngine()
    var tracker = PoseTracker()
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func shouldAutorotate() -> Bool {
        return false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.previewView = UIView(frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.size.width, UIScreen.mainScreen().bounds.size.height));
        self.previewView.contentMode = UIViewContentMode.ScaleAspectFit
        self.view.addSubview(previewView);
        self.setupAVCapture()
        tracker.startTracking()
    }
    
    override func viewWillAppear(animated: Bool) {
        if !done {
            session.startRunning();
        }
    }
}

// AVCaptureVideoDataOutputSampleBufferDelegate protocol and related methods
extension CameraFeedViewController:  AVCaptureVideoDataOutputSampleBufferDelegate{
    func setupAVCapture() {
        session.sessionPreset = AVCaptureSessionPresetHigh
        
        let devices = AVCaptureDevice.devices()

        for device in devices {
            if (device.hasMediaType(AVMediaTypeVideo)) {
                if (device.position == AVCaptureDevicePosition.Back) {
                    captureDevice = device as? AVCaptureDevice
                    done = true
                    break
                }
            }
        }
        
        if (captureDevice != nil) {
            beginSession()
        }
    }

    func beginSession() {
        var deviceInput = AVCaptureDeviceInput()
        do {
            try deviceInput = AVCaptureDeviceInput(device: captureDevice);
        } catch {
            print("ERROR")
        }

        if self.session.canAddInput(deviceInput) {
            self.session.addInput(deviceInput);
        }
        
        self.videoDataOutput = AVCaptureVideoDataOutput();
        self.videoDataOutput.alwaysDiscardsLateVideoFrames=true;
        self.videoDataOutputQueue = dispatch_queue_create("VideoDataOutputQueue", DISPATCH_QUEUE_SERIAL);

        self.videoDataOutput.setSampleBufferDelegate(self, queue:self.videoDataOutputQueue);
        if session.canAddOutput(self.videoDataOutput){
            session.addOutput(self.videoDataOutput);
        }
        self.videoDataOutput.connectionWithMediaType(AVMediaTypeVideo).enabled = true;
        
        //self.previewLayer = AVCaptureVideoPreviewLayer(session: self.session);
        self.previewLayer = CALayer()
        //self.previewLayer.videoGravity = AVLayerVideoGravityResizeAspect;
        var rootLayer: CALayer = self.previewView.layer;
        rootLayer.masksToBounds = true;
        self.previewLayer.frame = rootLayer.bounds;
        rootLayer.addSublayer(self.previewLayer);

        session.startRunning();
    }
    
    func captureOutput(captureOutput: AVCaptureOutput!, didOutputSampleBuffer sampleBuffer: CMSampleBuffer!, fromConnection connection: AVCaptureConnection!) {
        currentFrame = self.convertImageFromCMSampleBufferRef(sampleBuffer);
        dispatch_async(self.videoDataOutputQueue) {
            var layer = CALayer()
            var context = CIContext()
            layer.contents = context.createCGImage(self.currentFrame, fromRect: (self.currentFrame?.extent)!)
            self.previewLayer.addSublayer(layer)
        }
    }
    
    // clean up AVCapture
    func stopCamera(){
        session.stopRunning()
        done = false;
    }
    
    func convertImageFromCMSampleBufferRef(sampleBuffer:CMSampleBuffer) -> CIImage{
        let pixelBuffer:CVPixelBufferRef = CMSampleBufferGetImageBuffer(sampleBuffer)!;
        var ciImage:CIImage = CIImage(CVPixelBuffer: pixelBuffer)
        if (displayEngine.objects.isEmpty && tracker.globalPosition.o.u.len() > 0.0) {
            var pikachuObject = GameObject(imagePath: "pikachu.gif", playerLocation: tracker.globalPosition)
            displayEngine.addObject(pikachuObject)
        }
        return displayEngine.overlayGameObjects(ciImage, playerPosition: tracker.globalPosition);
    }
}

