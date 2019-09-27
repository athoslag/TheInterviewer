//
//  QALongViewController.swift
//  TheInterviewer
//
//  Created by Athos Lagemann on 03/09/19.
//  Copyright © 2019 Athos Lagemann. All rights reserved.
//

import AVFoundation
import UIKit

protocol QALongViewControllerDelegate: class {
    func didTapBack(_ viewController: QALongViewController, viewModel: InterviewViewModel)
    func didTapOverview(_ viewController: QALongViewController, viewModel: InterviewViewModel)
    func didFinishAnswer(_ viewController: QALongViewController, viewModel: InterviewViewModel, index: Index)
}

final class QALongViewController: UIViewController {
    private enum RecordState {
        case disabled
        case ready
        case recording
        case hide
    }
    
    private enum PlaybackState {
        case ready
        case playing
        case unavailable
        case hide
    }
    
    @IBOutlet private weak var partProgressionLabel: UILabel!
    @IBOutlet private weak var sectionProgressionLabel: UILabel!
    @IBOutlet private weak var questionLabel: UILabel!
    @IBOutlet private weak var textView: UITextView!
    @IBOutlet private weak var recordButton: UIButton!
    private var tabAccessoryView: UIToolbar?

    private let questionIndex: Index
    private let viewModel: InterviewViewModel
    private let presentationMode: Mode
    
    // Recording
    private var recordingSession: AVAudioSession!
    private var audioRecorder: AVAudioRecorder?
    
    private var recordingsPath: URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0].appendingPathComponent("recordings", isDirectory: true)
    }
    
    private var dirPath: URL {
        return recordingsPath.appendingPathComponent(viewModel.title.replacingOccurrences(of: " ", with: "_"), isDirectory: true)
    }
    
    private var filenameURL: URL {
        let filename = dirPath.appendingPathComponent("\(questionIndex.filename).m4a")
        debugPrint("audioFilename: \(filename.path)")
        return filename
    }
    
    // Playback
    private var audioPlayer: AVAudioPlayer?
    
    // Debug
    private let debug: Bool = false
    
    weak var delegate: QALongViewControllerDelegate?
    
    init(viewModel: InterviewViewModel, index: Index, presentationMode: Mode) {
        self.viewModel = viewModel
        self.questionIndex = index
        self.presentationMode = presentationMode
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        
        switch presentationMode {
        case .edition:
            createRecordingsDirectory()
            configureAudioRecording()
        case .review:
            configureAudioPlayback()
        }
        
        textView.delegate = self
        
        if let pair = viewModel.questionPair(for: questionIndex) {
            questionLabel.text = pair.question
            textView.text = pair.answer            
        }
        
        // Part & Section indicator
        let titles = viewModel.titles(for: questionIndex)
        partProgressionLabel.text = titles.part
        sectionProgressionLabel.text = titles.section
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if presentationMode == .edition {
            textView.becomeFirstResponder()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if presentationMode == .edition {
            finishRecording(success: true)
        }
        
        delegate?.didTapBack(self, viewModel: viewModel)
        super.viewWillDisappear(animated)
    }
    
    private func configureUI() {
        hideKeyboardWhenTappedAround()
        
        // Navigation
        let item = UIBarButtonItem(title: "Menu", style: .plain, target: self, action: #selector(tapOverview(sender:)))
        navigationItem.setRightBarButton(item, animated: false)
        
        // Progression
        partProgressionLabel.font = UIFont(SFPro: .display, variant: .medium, size: 26)
        sectionProgressionLabel.font = UIFont(SFPro: .display, variant: .medium, size: 24)
        
        // Question
        questionLabel.font = UIFont(SFPro: .text, variant: .medium, size: 24)
        
        // Answer
        textView.font = UIFont(SFPro: .text, variant: .regular, size: 20)
        textView.textAlignment = .justified
        textView.autocapitalizationType = .sentences
        textView.layer.borderWidth = 1.0
        textView.layer.borderColor = UIColor.lightGray.cgColor
        textView.layer.cornerRadius = 6.0
        textView.isUserInteractionEnabled = presentationMode == .edition
        
        recordButton.titleLabel?.textColor = .white
        recordButton.titleLabel?.font = UIFont(SFPro: .text, variant: .regular, size: 17)
        recordButton.backgroundColor = AppConfiguration.mainColor
        recordButton.layer.cornerRadius = 5.0
        recordButton.titleLabel?.numberOfLines = 1
    }
}

// MARK: - Recording
extension QALongViewController {
    private func configureAudioRecording() {
        recordingSession = AVAudioSession.sharedInstance()
        
        do {
            try recordingSession.setCategory(.playAndRecord, mode: .default)
            try recordingSession.setActive(true)
            recordingSession.requestRecordPermission { [weak self] allowed in
                DispatchQueue.main.async {
                    self?.loadRecordingUI(state: .ready)
                }
            }
        } catch {
            self.loadRecordingUI(state: .disabled)
        }
    }
    
    private func loadRecordingUI(state: RecordState) {
        recordButton.isHidden = false
        recordButton.isEnabled = true
        
        switch state {
        case .hide:
            recordButton.isHidden = true
        case .recording:
            recordButton.setTitle("Gravando...", for: .normal)
        case .ready:
            recordButton.setTitle("Gravar", for: .normal)
        case .disabled:
            recordButton.isEnabled = false
            recordButton.setTitle("Gravar", for: .disabled)
            recordButton.backgroundColor = .lightGray
        }
        
        recordButton.sizeToFit()
    }
    
    private func createRecordingsDirectory() {
        var isDir: ObjCBool = true
        if !FileManager.default.fileExists(atPath: recordingsPath.path, isDirectory: &isDir) {
            do {
                try FileManager.default.createDirectory(at: recordingsPath, withIntermediateDirectories: false)
                self.debugPrint("Created directory: \(recordingsPath.path)")
            } catch {
                fatalError("Could not createDirectory")
            }
        } else {
            debugPrint("Recordings dir already exists.")
        }
        
        if !FileManager.default.fileExists(atPath: dirPath.path, isDirectory: &isDir) {
            do {
                try FileManager.default.createDirectory(at: dirPath, withIntermediateDirectories: true)
                self.debugPrint("Created directory: \(dirPath.path)")
            } catch {
                fatalError("Could not createDirectory")
            }
        } else {
            if debug {
                debugPrint("\(viewModel.title) dir already exists.")
            }
        }
    }
    
    private func startRecording() {
        let settings =
            [
                AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
                AVSampleRateKey: 12000,
                AVNumberOfChannelsKey: 1,
                AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
            ]
        
        do {
            audioRecorder = try AVAudioRecorder(url: filenameURL, settings: settings)
            // audioRecorder can be unwrapped since was just attributed
            audioRecorder!.delegate = self
            
            let status = audioRecorder!.record()
            recordButton.isEnabled = status
        } catch {
            finishRecording(success: false)
            recordButton.isEnabled = false
        }
        
    }
    
    private func finishRecording(success: Bool) {
        guard audioRecorder != nil else {
            return
        }
        
        audioRecorder?.stop()
        audioRecorder = nil
        
        self.debugPrint("Finished recording. Status: \(success)")
        if debug {
            printContentsOfDirectory()
        }
        
        loadRecordingUI(state: .ready)
    }
    
    private func printContentsOfDirectory() {
        let contents = try! FileManager.default.contentsOfDirectory(atPath: dirPath.path)
        
        print("Contents of folder \(dirPath.path)")
        print(contents)
    }
}

// MARK: - Playback
extension QALongViewController {
    private func configureAudioPlayback() {
        // verifies the existance of file
        let fileManager = FileManager.default
        let exists = fileManager.fileExists(atPath: filenameURL.path)
        
        if exists {
            loadPlaybackUI(state: .ready)
            debugPrint("File found at \(filenameURL.path)")
        } else {
            loadPlaybackUI(state: .unavailable)
            debugPrint("File not found at \(filenameURL.path)")
        }
    }
    
    private func loadPlaybackUI(state: PlaybackState) {
        recordButton.isHidden = false
        recordButton.isEnabled = true
        
        switch state {
        case .hide:
            recordButton.isHidden = true
        case .ready:
            recordButton.setTitle("Reproduzir", for: .normal)
        case .playing:
            recordButton.setTitle("Parar", for: .normal)
        case .unavailable:
            recordButton.isEnabled = false
            recordButton.setTitle("Reproduzir", for: .disabled)
            recordButton.backgroundColor = .lightGray
        }
        
        recordButton.sizeToFit()
    }
    
    private func togglePlayback() {
        if audioPlayer != nil, audioPlayer!.isPlaying {
            audioPlayer?.stop()
            loadPlaybackUI(state: .ready)
            debugPrint("Audioplayer stopped.")
        } else {
            do {
                audioPlayer = try AVAudioPlayer(contentsOf: filenameURL)
                audioPlayer?.prepareToPlay()
                audioPlayer?.delegate = self
                audioPlayer?.volume = 1.0
                audioPlayer?.play()
                loadPlaybackUI(state: .playing)
                debugPrint("Audioplayer is now playing: \(filenameURL.absoluteString)")
            } catch {
                loadPlaybackUI(state: .unavailable)
                debugPrint("Audioplayer failed to play: \(filenameURL.absoluteString)")
            }
        }
    }
}

// MARK: - Debug
extension QALongViewController {
    private func debugPrint(_ content: Any) {
        if debug {
            print(content)
        }
    }
}

// MARK: - Actions
extension QALongViewController {
    @objc
    private func tapOverview(sender: Any) {
        delegate?.didTapOverview(self, viewModel: viewModel)
    }
    
    @objc
    private func nextTapped() {
        viewModel.updateAnswer(textView.text, for: questionIndex)
        delegate?.didFinishAnswer(self, viewModel: viewModel, index: questionIndex)
    }
    
    @IBAction func didTapRecord(_ sender: UIButton) {
        switch presentationMode {
        case .edition:
            if audioRecorder == nil {
                loadRecordingUI(state: .recording)
                startRecording()
            } else {
                finishRecording(success: true)
            }
        case .review:
            togglePlayback()
        }
    }
    
    @IBAction private func didTapNext(_ sender: UIButton) {
        nextTapped()
    }
}

// MARK: - TextView Delegate
extension QALongViewController: UITextViewDelegate {
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        if tabAccessoryView == nil {
            tabAccessoryView = UIToolbar(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 44))
            
            let barSpacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
            let barNext = UIBarButtonItem(title: "Próximo", style: .plain, target: self, action: #selector(nextTapped))
            barNext.tintColor = .black
            
            tabAccessoryView?.items = [barSpacer, barNext]
            textView.inputAccessoryView = tabAccessoryView
        }
        return true
    }
}

// MARK: - AudioRecorder Delegate
extension QALongViewController: AVAudioRecorderDelegate {
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if !flag {
            finishRecording(success: false)
        }
    }
}

// MARK: - AudioPlayer Delegate
extension QALongViewController: AVAudioPlayerDelegate {
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        loadPlaybackUI(state: .ready)
    }
}
