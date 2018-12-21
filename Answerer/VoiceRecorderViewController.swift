//
//  VoiceRecorderViewController.swift
//  Divar
//
//  Created by Apple on 11/11/18.
//  Copyright © 2018 Divar. All rights reserved.
//

import UIKit
import AVFoundation

protocol AudioRecorderViewControllerDelegate: class {
    func audioRecorderViewControllerDismissed(withFileURL fileURL: URL?)
    func timerFinishedCounting()
}

class VoiceRecorderViewController: UIViewController, AVAudioRecorderDelegate, AVAudioPlayerDelegate {

    @IBOutlet weak var eraseButton: UIButton!
    @IBOutlet weak var blinkingView: UIView!
    @IBOutlet weak var duration: UILabel!

    var timer: Timer?
    var counter = 0
    var sizeOfTheView: CGFloat!
    var isAudioRecordingGranted = false
    var outPutUrl: URL
    var recorder: AVAudioRecorder!
    var player: AVAudioPlayer?

    weak var audioRecorderDelegate: AudioRecorderViewControllerDelegate?

    init(size: CGFloat) {
        outPutUrl = ChatAudioFileManager.m4aPathWithName("\(UUID().uuidString).m4a")

        sizeOfTheView = size
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        cleanup()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.frame.size.width = 327.0
        blinkingView.layer.cornerRadius = blinkingView.frame.width/2
        checkRecordPermission()
        duration.text = ""
        if isAudioRecordingGranted {
            startAnimating(false)
            setupRecorder()
        }
        self.view.frame.size.width = sizeOfTheView
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        NotificationCenter.default.addObserver(self, selector: #selector(stopRecording), name: UIApplication.didEnterBackgroundNotification, object: nil)
    }

    @IBAction func dismissVoice(_ sender: Any) {
        cleanup()
        audioRecorderDelegate?.audioRecorderViewControllerDismissed(withFileURL: nil)
    }

    func startAnimating(_ alphaVal: Bool) {
        UIView.animate(withDuration: 1.0, delay: 0, options: .curveEaseInOut, animations: {
            self.blinkingView?.alpha = alphaVal ? 0 : 1
        }, completion: { _ in
            if self.counter < 60 || self.timer != nil {
                self.startAnimating(!alphaVal)
            } else {
                self.blinkingView.layer.removeAllAnimations()
                self.blinkingView?.alpha = 1
            }
        })
    }

    @objc func handleTimerLabel() {
        if counter == 61 {
            self.killTimer()
            return
        }

        duration.text = formatSecondsToString(TimeInterval(counter))
        counter += 1
    }

    func killTimer() {
        timer?.invalidate()
        timer = nil
        audioRecorderDelegate?.timerFinishedCounting()
    }

    func formatSecondsToString(_ seconds: TimeInterval) -> String {
        if seconds.isNaN {
            return "00:00"
        }

        let Min = Int(seconds / 60)
        let Sec = Int(seconds.truncatingRemainder(dividingBy: 60))

        return String(format: "%02d:%02d", Min, Sec)
    }

    func checkRecordPermission() {
        switch AVAudioSession.sharedInstance().recordPermission {
        case AVAudioSession.RecordPermission.granted:
            isAudioRecordingGranted = true
        case AVAudioSession.RecordPermission.denied:
            isAudioRecordingGranted = false
        case AVAudioSession.RecordPermission.undetermined:
            AVAudioSession.sharedInstance().requestRecordPermission({ (allowed) in
                if allowed {
                    self.isAudioRecordingGranted = true
                } else {
                    self.isAudioRecordingGranted = false
                }
            })
        default:
            break
        }
    }

    func setupRecorder() {
        if isAudioRecordingGranted {
            let session = AVAudioSession.sharedInstance()
            try? session.setCategory(.playAndRecord, mode: .spokenAudio)
            try? session.setActive(true)
            let settings = [
                AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
                AVSampleRateKey: 44100,
                AVNumberOfChannelsKey: 2,
                AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
            ]

            recorder = try? AVAudioRecorder(url: outPutUrl, settings: settings)
            recorder.delegate = self
            recorder.isMeteringEnabled = true
            recorder.prepareToRecord()

            if recorder != nil && !(timer?.isValid ?? false) {
                startRecording()
            }
        }
    }

    func startRecording() {
        timer?.invalidate()
        timer = nil
        if recorder.isRecording {
            recorder.stop()
        } else {
            counter = 0
            timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(handleTimerLabel), userInfo: nil, repeats: true)
            recorder.deleteRecording()
            recorder.record()
        }

        updateControls()
    }

    func saveAudio() {
        cleanup()
        audioRecorderDelegate?.audioRecorderViewControllerDismissed(withFileURL: outPutUrl)
    }

    @objc func stopRecording() {
        if recorder != nil && recorder.isRecording {
            timer?.invalidate()
            timer = nil
            recorder.stop()
            updateControls()
        }
    }

    func cleanup() {
        timer?.invalidate()
        timer = nil
        if recorder != nil, recorder.isRecording {
            recorder.stop()
            recorder.deleteRecording()
            duration.text = ""
        }

        if let player = player {
            player.stop()
            self.player = nil
        }
    }

    func playRecording() {
        if let player = player {
            player.stop()
            self.player = nil
            updateControls()
            return
        }

        try? player = AVAudioPlayer(contentsOf: outPutUrl)

        player?.delegate = self
        player?.play()
        updateControls()
    }

    func updateControls() {
        eraseButton.isHidden = recorder.isRecording
    }

    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        self.player = nil
        updateControls()
    }
}
