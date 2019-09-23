//
//  RecordManager.swift
//  TheInterviewer
//
//  Created by Athos Lagemann on 23/09/19.
//  Copyright © 2019 Athos Lagemann. All rights reserved.
//

import AVFoundation
import Foundation

protocol RecordManagerDelegate: class {
    func didFinishRecording(_ success: Bool)
}

final class RecordManager: NSObject {
    private let filename: String
    private let url: URL
    private let settings: [String: Int]
    private var recordingSession: AVAudioSession
    private var audioRecorder: AVAudioRecorder!
    
    weak var delegate: RecordManagerDelegate?
    
    init?(filename: String, url: URL) {
        self.filename = filename
        self.url = url
        self.recordingSession = AVAudioSession.sharedInstance()
        self.settings =
            [
                AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
                AVSampleRateKey: 12000,
                AVNumberOfChannelsKey: 1,
                AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
            ]
        
        do {
            try recordingSession.setCategory(.playAndRecord, mode: .spokenAudio, options: .defaultToSpeaker)
            try recordingSession.setActive(true)
        } catch {
            return nil
        }
    }
    
    func startRecording() -> Bool {
        recordingSession.requestRecordPermission { allowed in
            if !allowed {
                return
            }
        }
        
        do {
            audioRecorder = try AVAudioRecorder(url: url, settings: settings)
            audioRecorder.delegate = self
            audioRecorder.record()
            return true
        } catch {
            return false
        }
    }
    
    func stopRecording() {
        audioRecorder.stop()
        audioRecorder = nil
    }
}

extension RecordManager: AVAudioRecorderDelegate {
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        stopRecording()
        delegate?.didFinishRecording(flag)
    }
}
