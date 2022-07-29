import ArgumentParser
import Foundation

enum ActionControl: String, ExpressibleByArgument {
    case add
    case show
    case delete
    case complete
}

enum InputType: String, ExpressibleByArgument {
    case remote
    case local
}

struct ActionsList: ParsableCommand {
    static let configuration = CommandConfiguration(abstract: "A Swift command-line tool for creating and managing action lists")
    
    @Option
    private var inputType: InputType
    
    @Option(name: [.short, .customLong("read")], help: "A file to read and write actions list to")
    private var file: String?
    
    @Option(name: [.short, .customLong("option")])
    private var action: ActionControl
    
    @Option(name: [.short])
    private var name: String?
    
    @Option
    private var id: String?
    
    func run() throws {
        let actionsManager: ActionsListManager!
        
        switch inputType {
        case .remote:
            actionsManager = RemoteActionsListManager(service: ActionsService())
        case .local:
            actionsManager = try LocalActionsListManager(localActionsRepository: LocalActionsRepository(repositoryFile: file ?? ""))
        }

        
        switch action {
        case .add:
            if let name = name {
                try actionsManager.addAction(with: name)
            }
        case .show:
            try actionsManager.showActions()
        case .delete:
            if let id = id {
                try actionsManager.deleteAction(with: id)
            }
        case .complete:
            if let id = id {
                try actionsManager.completeAction(with: id)
            }
        }
    }
}

ActionsList.main()
