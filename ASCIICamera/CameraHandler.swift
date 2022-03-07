//
//  CameraHandler.swift
//  ASCIICamera
//
//  Created by Jacopo Gasparetto on 06/03/22.
//

import AVKit
import Foundation

class CameraOutput: NSObject, ObservableObject, AVCaptureVideoDataOutputSampleBufferDelegate {
    
    @Published var text = ""
    
    @inline(__always)
    func lerp<V: Numeric>(_ v0: V, _ v1: V, _ t: V) -> V {
      return v0 + t * (v1 - v0);
    }
    
    let density = Array("#####********+++++++++=========--------:::::::::..")
    
    
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        if let imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) {
            CVPixelBufferLockBaseAddress(imageBuffer, .readOnly)
            let height = CVPixelBufferGetHeight(imageBuffer)
            let width = CVPixelBufferGetWidth(imageBuffer)
            guard CVPixelBufferGetPixelFormatType(imageBuffer) == kCVPixelFormatType_32BGRA else {
                print("Wrong pixel format")
                return
            }
            
            var message = ""
            if let bufferAddress = CVPixelBufferGetBaseAddress(imageBuffer) {
                let pixels = bufferAddress.assumingMemoryBound(to: UInt32.self)
                
                for row in 0..<height {
                    for col in 0..<width {
                        let luma = pixels[row * width + col]
                        let blue = (luma >> 0) & 0xFF
                        let green = (luma >> 8) & 0xFF
                        let red = (luma >> 16) & 0xFF
                        let luminosity = (Float(red + green + blue) / 3.0) / 255
                        let characterIndex = Int(lerp(0.0, Float(density.count) - 1, luminosity))
                        message += String(density[characterIndex])
                    }
                   message += "\n"
                }
            }
            CVPixelBufferUnlockBaseAddress(imageBuffer, .readOnly)
            text = message
        }
    }
}

class CameraHandler {
    
    weak var delegate: AVCaptureVideoDataOutputSampleBufferDelegate?
    var captureSession: AVCaptureSession
    var cameraOutput = CameraOutput()
    
    init() {
        captureSession = AVCaptureSession()
        setupCamera()
    }
    
    private
    func setupCaptureSession() {
        captureSession.beginConfiguration()
        let videoDevice = AVCaptureDevice.default(.builtInWideAngleCamera,
                                                  for: .video, position: .unspecified)
        guard let videoDeviceInput = try? AVCaptureDeviceInput(device: videoDevice!),
            captureSession.canAddInput(videoDeviceInput)
            else { return }
        
       
        captureSession.addInput(videoDeviceInput)
        
        let videoOutput = AVCaptureVideoDataOutput()
        videoOutput.setSampleBufferDelegate(cameraOutput, queue: .main)
        videoOutput.videoSettings = [
            String(kCVPixelBufferPixelFormatTypeKey): kCVPixelFormatType_32BGRA,
            String(kCVPixelBufferWidthKey): 80,
            String(kCVPixelBufferHeightKey): 60
        ]
        guard captureSession.canAddOutput(videoOutput) else { return }
        captureSession.addOutput(videoOutput)
        captureSession.commitConfiguration()
    }
    
    public
    func setupCamera() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
            case .authorized: // The user has previously granted access to the camera.
                self.setupCaptureSession()
                break
            
            case .notDetermined: // The user has not yet been asked for camera access.
                AVCaptureDevice.requestAccess(for: .video) { granted in
                    if granted {
                        self.setupCaptureSession()
                    }
                }
            
            case .denied: // The user has previously denied access.
                return

            case .restricted: // The user can't grant access due to restrictions.
                return
        @unknown default:
            fatalError()
        }
    }
    
    func startSession() {
            guard !captureSession.isRunning else { return }
            captureSession.startRunning()
            print("Session Started")
        }

        func stopSession() {
            guard captureSession.isRunning else { return }
            captureSession.stopRunning()
            print("Session stopped")
        }
    
    
}

