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
    private let path: URL
    private let settings: [String: Int]
    private var recordingSession: AVAudioSession
    private var audioRecorder: AVAudioRecorder?
    private(set) var isRecording: Bool = false
    
    weak var delegate: RecordManagerDelegate?
    
    init?(folder: String, filename: String) {
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        
        self.filename = filename
        self.path = documentsURL.appendingPathComponent("Recordings", isDirectory: true).appendingPathComponent(folder, isDirectory: true)
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
            audioRecorder = try AVAudioRecorder(url: path, settings: settings)
            audioRecorder?.delegate = self
            audioRecorder?.record()
            isRecording = true
            return true
        } catch {
            isRecording = false
            return false
        }
    }
    
    func stopRecording() {
        audioRecorder?.stop()
        audioRecorder = nil
        isRecording = false
    }
}

extension RecordManager: AVAudioRecorderDelegate {
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        stopRecording()
        delegate?.didFinishRecording(flag)
    }
}
