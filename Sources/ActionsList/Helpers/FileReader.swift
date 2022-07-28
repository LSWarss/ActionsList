//
//  FileReader.swift
//  
//
//  Created by Łukasz Stachnik on 26/07/2022.
//

import Foundation

protocol FileReader {
    func readFile(inputFilePath: String) throws -> String
    func readFile<T: Codable>(inputFilePath: String) throws -> T
}

enum FileReaderError: Error {
    case fileNotFound(name: String)
    case stringConversionError
}

struct LocalFileReader: FileReader {
    
    let fileManager: FileManager
    let jsonDecoder: JSONDecoder
    
    init(fileManager: FileManager = FileManager.default,
         jsonDecoder: JSONDecoder = JSONDecoder()) {
        self.fileManager = fileManager
        self.jsonDecoder = jsonDecoder
    }
    
    func readFile(inputFilePath: String) throws -> String {
        guard let data = fileManager.contents(atPath: inputFilePath) else {
            throw FileReaderError.fileNotFound(name: inputFilePath)
        }
        
        guard let savedData = String(data: data, encoding: .utf8) else {
            throw FileReaderError.stringConversionError
        }
        
        return savedData
    }
    
    func readFile<T: Codable>(inputFilePath: String) throws -> T {
        guard let data = fileManager.contents(atPath: inputFilePath) else {
            throw FileReaderError.fileNotFound(name: inputFilePath)
        }
        
        return try jsonDecoder.decode(T.self, from: data)
    }
}
