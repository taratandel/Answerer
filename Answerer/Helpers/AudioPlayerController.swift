//
//  AudioPlayManager.swift
//  Questioner
//
//  Created by negar on 97/Azar/30 AP.
//  Copyright © 1397 negar. All rights reserved.
//

import Foundation
import AVFoundation
import Alamofire

enum AudioPlayerStatus: String {
    case start = "start Playin"
    case finished = "finished Playing"
    case failed = "failed Playing"
    case interrupted = "interrupted"
}

protocol PlayAudioDelegate: class {
    func audioPlayStatus(status: AudioPlayerStatus)
}

let AudioPlayInstance = AudioPlayManager.sharedInstance

class AudioPlayManager: NSObject {
    fileprivate var audioPlayer: AVAudioPlayer?

    weak var delegate: PlayAudioDelegate?


    class var sharedInstance: AudioPlayManager {
        struct Static {
            static let instance: AudioPlayManager = AudioPlayManager()
        }
        return Static.instance
    }
    func startPlaying(_ message: Chat) {
        try? AVAudioSession.sharedInstance().setCategory(.playAndRecord, mode: .default, options: .defaultToSpeaker)
        try? AVAudioSession.sharedInstance().setActive(true, options: .notifyOthersOnDeactivation)

        let chunks = String(message.file.dropLast()).components(separatedBy: "/")
        guard let originalName = chunks.last else {
            delegate?.audioPlayStatus(status: .failed)
            return
        }
        let m4aOriginalFilePath = ChatAudioFileManager.m4aPathWithName(originalName)
        if FileManager.default.fileExists(atPath: m4aOriginalFilePath.path) {
            self.playSoundWithPath(m4aOriginalFilePath.path)
            return
        }


        self.downloadAudio(message)
    }

    fileprivate func playSoundWithPath(_ path: String) {
        let fileData = try? Data(contentsOf: URL(fileURLWithPath: path))
        do {
            self.audioPlayer = try AVAudioPlayer(data: fileData!, fileTypeHint: AVFileType.m4a.rawValue)
            guard let player = self.audioPlayer else { return }

            player.delegate = self
            player.prepareToPlay()

            guard let delegate = self.delegate else {
                return
            }

            if player.play() {
                delegate.audioPlayStatus(status: .start)
            } else {
                delegate.audioPlayStatus(status: .failed)
            }
        } catch {
            self.destroyPlayer()
        }
    }

    func destroyPlayer() {
        self.stopPlayer()
    }

    func stopPlayer() {
        if self.audioPlayer == nil { return }

        self.audioPlayer!.delegate = nil
        self.audioPlayer!.stop()
        self.audioPlayer?.prepareToPlay()
        self.audioPlayer = nil
    }

    fileprivate func convertAmrToWavAndPlaySound(_ message: Chat) {
        if self.audioPlayer != nil {
            self.stopPlayer()
        }
        let chunks = String(message.file.dropLast()).components(separatedBy: "/")
        guard let fileName = chunks.last else {
            delegate?.audioPlayStatus(status: .failed)
            return
        }

        let m4a = ChatAudioFileManager.m4aPathWithName(fileName).path
        if FileManager.default.fileExists(atPath: m4a) {
            self.playSoundWithPath(m4a)
        }
    }

    fileprivate func downloadAudio(_ message: Chat) {
        let chunks = String(message.file.dropLast()).components(separatedBy: "/")
        guard let fileName = chunks.last else {
            delegate?.audioPlayStatus(status: .failed)
            return
        }
        let filePath = ChatAudioFileManager.m4aPathWithName(fileName)
        let destination: DownloadRequest.DownloadFileDestination = { (temporaryURL, response)  in

            if response.statusCode == 200 {
                if FileManager.default.fileExists(atPath: filePath.path) {
                    try! FileManager.default.removeItem(at: filePath)
                }
                return (filePath, [])
            } else {
                return (temporaryURL, [])
            }
        }
        let dlPath = message.file

        Alamofire.download(dlPath, to: destination).downloadProgress { _ in }
            .responseData { response in
                if let error = response.result.error, let delegate = self.delegate {
                    print(error)
                    delegate.audioPlayStatus(status: .failed)
                } else {
                    self.convertAmrToWavAndPlaySound(message)
                }
        }
    }
}

extension AudioPlayManager: AVAudioPlayerDelegate {
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        UIDevice.current.isProximityMonitoringEnabled = false

        if flag {
            self.delegate?.audioPlayStatus(status: .finished)
        } else {
            self.delegate?.audioPlayStatus(status: .failed)
        }
        self.stopPlayer()
    }

    func audioPlayerDecodeErrorDidOccur(_ player: AVAudioPlayer, error: Error?) {
        self.stopPlayer()
        self.delegate?.audioPlayStatus(status: .failed)
    }

    func audioPlayerBeginInterruption(_ player: AVAudioPlayer) {
        self.stopPlayer()
        self.delegate?.audioPlayStatus(status: .failed)
    }

    func audioPlayerEndInterruption(_ player: AVAudioPlayer, withOptions flags: Int) {
        self.delegate?.audioPlayStatus(status: .interrupted)
    }
}
