//
//  RemoteActionsListManager.swift
//  
//
//  Created by Łukasz Stachnik on 29/07/2022.
//

import Foundation

final class RemoteActionsListManager: ActionsListManager {
    var actions: [Action]
    let service: ActionsService
    
    init(service: ActionsService) {
        self.service = service
        self.actions = []
        print("REMOTE INITALIZED")
    }
    
    func getActions() {
        service.getActions(completionHandler: { [unowned self] result in
            switch result {
            case .success(let actions):
                self.actions = actions
                
                print("====================================================================")
                actions
                    .sorted { !$0.completed  && $1.completed }
                    .forEach { action in
                        action.completed ? print("✅: \(action.name)") : print("❗️: \(action.id) \(action.name)")
                    }
                print("====================================================================")
            case .failure(let error):
                print(error)
            }
        })
    }
    
    func getActions() async throws {
        actions = try await service.getActions()
        print("====================================================================")
        actions
            .sorted { !$0.completed  && $1.completed }
            .forEach { action in
                action.completed ? print("✅: \(action.name)") : print("❗️: \(action.id) \(action.name)")
            }
        print("====================================================================")
    }
    
    func showActions() throws {
        if #available(macOS 10.15, *) {
            Task {
                try await getActions()
            }
        } else {
            getActions()
        }
        sleep(10)
    }
    
    func addAction(with name: String) throws {
        
    }
    
    func completeAction(with id: String) throws {

    }
    
    func deleteAction(with id: String) throws {

    }
}
