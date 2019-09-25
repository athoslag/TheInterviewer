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
    func didFinishAnswer(_ viewController: QALongViewController, viewModel: InterviewViewModel, index: Index)
}

final class QALongViewController: UIViewController {
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
    private var audioRecorder: AVAudioRecorder!
    
    private var recordingsPath: URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let recordings = paths[0].appendingPathComponent("recordings", isDirectory: true)
        return recordings
    }
    
    private var dirPath: URL {
        let newPath = recordingsPath.appendingPathComponent(viewModel.title.replacingOccurrences(of: " ", with: "_"), isDirectory: true)
        return newPath
    }
    
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
        configureAudioRecording()
        
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
        super.viewWillDisappear(animated)
        delegate?.didTapBack(self, viewModel: viewModel)
    }
    
    private func configureUI() {
        hideKeyboardWhenTappedAround()
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
        
        // Record
        guard presentationMode == .edition else {
            recordButton.isHidden = true
            return
        }
        
        recordButton.tintColor = .white
        recordButton.setTitle(nil, for: .normal)
        recordButton.setImage(UIImage.record, for: .normal)
        
        let edge = recordButton.layer.bounds.height / 5
        recordButton.imageEdgeInsets = UIEdgeInsets(top: edge, left: edge, bottom: edge, right: edge)
        recordButton.backgroundColor = AppConfiguration.mainColor
        recordButton.layer.cornerRadius = recordButton.layer.bounds.height / 2
    }
}

// MARK: - Recording
extension QALongViewController {
    private func configureAudioRecording() {
        recordingSession = AVAudioSession.sharedInstance()
        
        do {
            try recordingSession.setCategory(.playAndRecord, mode: .spokenAudio)
            try recordingSession.setActive(true)
            recordingSession.requestRecordPermission { [weak self] allowed in
                DispatchQueue.main.async {
                    self?.loadRecordingUI(show: allowed)
                }
            }
        } catch {
            self.loadRecordingUI(show: false)
        }
    }
    
    private func loadRecordingUI(show: Bool) {
        self.recordButton.isHidden = !show && presentationMode == .edition
    }
    
    private func createRecordingsDirectory() -> URL {
        
        var isDir: ObjCBool = true
        if !FileManager.default.fileExists(atPath: recordingsPath.path, isDirectory: &isDir) {
            do {
                try FileManager.default.createDirectory(at: recordingsPath, withIntermediateDirectories: false)
                print("Created directory:", recordingsPath.path)
            } catch {
                fatalError("Could not createDirectory")
            }
        } else {
            print("Recordings dir already exists.")
        }
        
        if !FileManager.default.fileExists(atPath: dirPath.path, isDirectory: &isDir) {
            do {
                try FileManager.default.createDirectory(at: dirPath, withIntermediateDirectories: true)
                print("Created directory:", dirPath.path)
            } catch {
                fatalError("Could not createDirectory")
            }
        } else {
            print("\(viewModel.title) dir already exists.")
        }
        
        return dirPath
    }
    
    private func startRecording() {
        let path = createRecordingsDirectory()
        let audioFilename = path.appendingPathComponent("\(questionIndex.filename).m4a")
        print("audioFilename:", audioFilename.path)
        
        let settings =
            [
                AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
                AVSampleRateKey: 12000,
                AVNumberOfChannelsKey: 1,
                AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
            ]
        
        do {
            audioRecorder = try AVAudioRecorder(url: audioFilename, settings: settings)
            audioRecorder.delegate = self
            let status = audioRecorder.record()
            recordButton.isEnabled = status
            // TODO: show recording indicator
        } catch {
            finishRecording(success: false)
            recordButton.isEnabled = false
        }
        
    }
    
    private func finishRecording(success: Bool) {
        audioRecorder.stop()
        audioRecorder = nil
        print("Finished recording. Status:", success)
        printContentsOfDirectory()
        
        loadRecordingUI(show: success) // TODO: refactor this
    }
    
    private func printContentsOfDirectory() {
        let contents = try! FileManager.default.contentsOfDirectory(atPath: dirPath.path)
        
        print("Contents of folder \(dirPath.path)")
        print(contents)
    }
}

// MARK: - Actions
extension QALongViewController {
    @objc
    private func nextTapped() {
        viewModel.updateAnswer(textView.text, for: questionIndex)
        delegate?.didFinishAnswer(self, viewModel: viewModel, index: questionIndex)
    }
    
    @IBAction func didTapRecord(_ sender: UIButton) {
        if audioRecorder == nil {
            startRecording()
        } else {
            finishRecording(success: true)
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

// MARK: - RecordManager Delegate
extension QALongViewController: RecordManagerDelegate {
    func didFinishRecording(_ success: Bool) {
        recordButton.layer.borderColor = UIColor.red.cgColor
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
