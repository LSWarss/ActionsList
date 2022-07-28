//
//  LocalActionsRepository.swift
//  
//
//  Created by Łukasz Stachnik on 26/07/2022.
//

import Foundation

final class LocalActionsRepository {
    let localFileReader: FileReader
    let localFileWriter: FileWriter
    let repositoryFile: String
    
    init(repositoryFile: String,
         fileReader: FileReader = LocalFileReader(),
         fileWriter: FileWriter = LocalFileWriter()) {
        self.repositoryFile = repositoryFile
        self.localFileReader = fileReader
        self.localFileWriter = fileWriter
    }
    
    func readActions() throws -> [Action] {
        return try localFileReader.readFile(inputFilePath: repositoryFile)
    }
    
    func saveActions(actions: [Action]) throws {
        let data = try JSONEncoder().encode(actions)
        try localFileWriter.writeToFile(fileName: repositoryFile, content: data)
    }
}
