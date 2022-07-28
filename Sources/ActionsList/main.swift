import ArgumentParser
import Foundation

enum ActionControl: String, ExpressibleByArgument {
    case add
    case show
    case delete
    case complete
}

struct ActionsList: ParsableCommand {
    static let configuration = CommandConfiguration(abstract: "A Swift command-line tool for creating and managing action lists")
    
    @Option(name: [.short, .customLong("read")], help: "A file to read and write actions list to")
    private var inputFile: String
    
    @Option(name: [.short, .customLong("option")])
    private var action: ActionControl
    
    @Option(name: [.short])
    private var name: String?
    
    @Option
    private var id: String?
    
    func run() throws {
        let manager = try LocalActionsListManager(localActionsRepository: LocalActionsRepository(repositoryFile: inputFile))
        switch action {
        case .add:
            if let name = name {
                try manager.addAction(with: name)
            }
        case .show:
            manager.showActions()
        case .delete:
            if let id = id {
                try manager.deleteAction(with: id)
            }
        case .complete:
            if let id = id {
                try manager.completeAction(with: id)
            }
        }
    }
}

ActionsList.main()
