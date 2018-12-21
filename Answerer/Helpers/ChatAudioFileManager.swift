//
//  ChatAudioFileManager.swift
//  Divar
//
//  Created by Tara on 11/17/18.
//  Copyright © 2018 Divar. All rights reserved.
//

import Foundation

class ChatAudioFileManager {

    @discardableResult
    class func m4aPathWithName(_ fileName: String) -> URL {
        let filePath = self.m4aFilesFolder.appendingPathComponent("\(fileName)")
        return filePath
    }

    fileprivate class var m4aFilesFolder: URL {
        return self.createAudioFolder("ChatAudioM4aRecord")
    }

    @discardableResult
    class fileprivate func createAudioFolder(_ folderName: String) -> URL {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let folder = documentsDirectory.appendingPathComponent(folderName)
        let fileManager = FileManager.default
        if !fileManager.fileExists(atPath: folder.absoluteString) {
            try? fileManager.createDirectory(atPath: folder.path, withIntermediateDirectories: true, attributes: nil)
            return folder
        }

        return folder
    }
}
