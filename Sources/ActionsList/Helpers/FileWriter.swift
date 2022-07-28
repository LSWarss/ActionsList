//
//  FileWriter.swift
//  
//
//  Created by Łukasz Stachnik on 26/07/2022.
//

import Foundation

protocol FileWriter {
    func writeToFile(fileName: String, content: Data?) throws
}

enum FileWriterError: Error {
    case fileWriteError
}

struct LocalFileWriter: FileWriter {
    
    let fileManager: FileManager
    
    init(fileManager: FileManager = FileManager.default) {
        self.fileManager = fileManager
    }
    
    func writeToFile(fileName: String, content: Data?) throws {
        let created = fileManager.createFile(atPath: fileName, contents: content)
        
        if !created {
            throw FileWriterError.fileWriteError
        }
    }
}
