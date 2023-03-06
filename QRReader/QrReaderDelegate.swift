//
//  QrReaderDelegate.swift
//  QRReader
//
//  Created by 竹田恭 on 2023/03/06.
//

import SwiftUI
import AVFoundation

class QrReaderDelegate: NSObject, AVCaptureVideoDataOutputSampleBufferDelegate, ObservableObject {
    
    var onFound: (String) -> Void = { _  in }
    
    //カメラ用のAVsessionインスタンス作成
    private let AVsession = AVCaptureSession()
    //カメラ画像を表示するレイヤー
    var videoPreviewLayer:AVCaptureVideoPreviewLayer!
    // カメラの設定
    // 今回は背面カメラなのでposition: .back
    let discoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera], mediaType: .video, position: .back)
    
    override init() {
        super.init()
        cameraInit()
    }
    
    func cameraInit(){
        //カメラデバイスの取得
        let devices = discoverySession.devices
        
        //背面のカメラ情報を取得
        if let backCamera = devices.first {
            do {
                //カメラ入力をinputとして取得
                let input = try AVCaptureDeviceInput(device: backCamera)
                
                //Metadata情報（今回はQRコード）を取得する準備
                //AVssessionにinputを追加:既に追加されている場合を考慮してemptyチェックをする
                if AVsession.inputs.isEmpty {
                    AVsession.addInput(input)
                    //MetadataOutput型の出力用の箱を用意
                    let captureMetadataOutput = AVCaptureMetadataOutput()
                    //captureMetadataOutputに先ほど入力したinputのmetadataoutputを入れる
                    AVsession.addOutput(captureMetadataOutput)
                    //MetadataObjectsのdelegateに自己(self)をセット
                    captureMetadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
                    //Metadataの出力タイプをqrにセット
                    captureMetadataOutput.metadataObjectTypes = [AVMetadataObject.ObjectType.qr]
                    
                    //カメラ画像表示viewの準備とカメラの開始
                    //カメラ画像を表示するAVCaptureVideoPreviewLayer型のオブジェクトをsessionをAVsessionで初期化でプレビューレイヤを初期化
                    videoPreviewLayer = AVCaptureVideoPreviewLayer.init(session: AVsession)
                    //カメラ画像を表示するvideoPreviewLayerの大きさをview（superview）の大きさに設定
                    //videoPreviewLayer?.frame = previewLayer.bounds
                    //カメラ画像を表示するvideoPreviewLayerをビューに追加
                    //previewLayer.addSublayer(videoPreviewLayer!)
                }
                //セッションの開始(今回はカメラの開始)
                DispatchQueue.global(qos: .background).async {
                    self.AVsession.startRunning()
                }
            } catch {
                print("Error occured while creating video device input: \(error)")
            }
        }
    }
    

    func startSession() {
        if AVsession.isRunning { return }
        AVsession.startRunning()
    }
    
    func stopSession() {
        if !AVsession.isRunning { return }
        AVsession.stopRunning()
    }
    
    
}
//MARK: - AVCaptureMetadataOutputObjectsDelegate
extension QrReaderDelegate: AVCaptureMetadataOutputObjectsDelegate{
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        
        //カメラ画像にオブジェクトがあるか確認
        if metadataObjects.count == 0 {
            return
        }
        //オブジェクトの中身を確認
        for metadata in metadataObjects as! [AVMetadataMachineReadableCodeObject] {
            // metadataのtype： metadata.type
            // QRの中身： metadata.stringValue
            guard let stringValue: String = metadata.stringValue else { return }
            onFound(stringValue)
        }
    }
}
