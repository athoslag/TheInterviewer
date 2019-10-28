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
    
    @IBOutlet private weak var scrollView: UIScrollView!
    @IBOutlet private weak var partProgressionLabel: UILabel!
    @IBOutlet private weak var sectionProgressionLabel: UILabel!
    @IBOutlet private weak var questionLabel: UILabel!
    @IBOutlet private weak var textView: UITextView!
    @IBOutlet private weak var recordButton: UIButton!
    private var tabAccessoryView: UIToolbar?

    private let questionIndex: Index
    private let viewModel: InterviewViewModel
    private let presentationMode: Mode
    private let recordingEnabled: Bool
    
    // Recording
    private var recordingSession: AVAudioSession!
    private var audioRecorder: AVAudioRecorder?
    
    private var filenameURL: URL {
        let filename = viewModel.interviewDirectory.appendingPathComponent("\(questionIndex.filename).m4a")
        debugPrint("audioFilename: \(filename.path)")
        return filename
    }
    
    // Playback
    private var audioPlayer: AVAudioPlayer?
    
    // Debug
    private let debug: Bool = false
    
    weak var delegate: QALongViewControllerDelegate?
    
    init(viewModel: InterviewViewModel, index: Index, presentationMode: Mode, recordingEnabled: Bool) {
        self.viewModel = viewModel
        self.questionIndex = index
        self.presentationMode = presentationMode
        self.recordingEnabled = recordingEnabled
        
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
        
        // observers & delegates
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
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
        navigationController?.navigationBar.prefersLargeTitles = false
        
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
        recordButton.backgroundColor = recordingEnabled ? AppConfiguration.mainColor : .lightGray
        recordButton.setTitleColor(.white, for: .normal)
        recordButton.setTitleColor(.black, for: .disabled)
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
        recordButton.isEnabled = recordingEnabled
        
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
        if !FileManager.default.fileExists(atPath: viewModel.recordingsDirectory.path, isDirectory: &isDir) {
            do {
                try FileManager.default.createDirectory(at: viewModel.recordingsDirectory, withIntermediateDirectories: false)
                self.debugPrint("Created directory: \(viewModel.recordingsDirectory.path)")
            } catch {
                fatalError("Could not createDirectory")
            }
        } else {
            debugPrint("Recordings dir already exists.")
        }
        
        if !FileManager.default.fileExists(atPath: viewModel.interviewDirectory.path, isDirectory: &isDir) {
            do {
                try FileManager.default.createDirectory(at: viewModel.interviewDirectory, withIntermediateDirectories: true)
                self.debugPrint("Created directory: \(viewModel.interviewDirectory.path)")
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
        let contents = try! FileManager.default.contentsOfDirectory(atPath: viewModel.interviewDirectory.path)
        
        print("Contents of folder \(viewModel.interviewDirectory.path)")
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
        
        scrollView.scrollRectToVisible(textView.frame, animated: true)
        
        return true
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        scrollView.scrollRectToVisible(textView.frame, animated: true)
    }
    
    func textViewDidChange(_ textView: UITextView) {
        scrollView.scrollRectToVisible(textView.frame, animated: true)
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

// MARK: - Keyboard Management
extension QALongViewController {
    @objc
    func keyboardWillShow(notification:NSNotification) {
        let userInfo = notification.userInfo!
        var keyboardFrame: CGRect = (userInfo[UIResponder.keyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        
        keyboardFrame = self.view.convert(keyboardFrame, from: nil)

        var contentInset:UIEdgeInsets = self.scrollView.contentInset
        contentInset.bottom = keyboardFrame.size.height
        scrollView.contentInset = contentInset
    }

    @objc
    func keyboardWillHide(notification:NSNotification) {
        let contentInset:UIEdgeInsets = UIEdgeInsets.zero
        scrollView.contentInset = contentInset
    }
}
