//
//  ActionsListManager.swift
//  
//
//  Created by Łukasz Stachnik on 26/07/2022.
//

import Foundation

protocol ActionsListManager {
    var actions: [Action] { get set }
    func showActions() throws
    func addAction(with name: String) throws
    func completeAction(with id: String) throws
    func deleteAction(with id: String) throws
}

final class LocalActionsListManager: ActionsListManager {
    var actions: [Action]
    let localActionsRepository: LocalActionsRepository
    
    init(localActionsRepository: LocalActionsRepository) throws {
        self.localActionsRepository = localActionsRepository
        self.actions = try localActionsRepository.readActions()
        print("LOCAL INITALIZED")
    }
    
    func showActions() {
        print("====================================================================")
        actions
            .sorted { !$0.completed  && $1.completed }
            .forEach { action in
                action.completed ? print("✅: \(action.title)") : print("❗️: \(action.id) \(action.title)")
            }
        print("====================================================================")
    }
    
    func addAction(with name: String) throws {
        actions
            .append(Action(id: UUID().uuidString,
                           title: name,
                           completed: false))
        try localActionsRepository.saveActions(actions: actions)
        showActions()
    }
    
    func completeAction(with id: String) throws {
        let index = actions.firstIndex { $0.id == id }
        
        guard let index = index else {
            return
        }

        actions[index].completed = true
        try localActionsRepository.saveActions(actions: actions)
        showActions()
    }
    
    func deleteAction(with id: String) throws {
        let index = actions.firstIndex { $0.id == id }
        
        guard let index = index else {
            return
        }

        actions.remove(at: index)
        try localActionsRepository.saveActions(actions: actions)
        showActions()
    }
}
