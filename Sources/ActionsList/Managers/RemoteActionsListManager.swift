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
        service.getActions(completionHandler: { [weak self] result in
            switch result {
            case .success(let actions):
                self.actions = actions
                
//                print("====================================================================")
//                actions
//                    .sorted { !$0.completed  && $1.completed }
//                    .forEach { action in
//                        action.completed ? print("✅: \(action.title)") : print("❗️: \(action.id) \(action.title)")
//                    }
//                print("====================================================================")
            case .failure(let error):
                print(error)
            }
        })
    }
    
    func getActionsAsync() {
        if #available(macOS 10.15, *) {
            Task {
                actions = try! await service.getActions()
            }
        } else {
            // Fallback on earlier versions
        }
        
//        print("====================================================================")
//        actions
//            .sorted { !$0.completed  && $1.completed }
//            .forEach { action in
//                action.completed ? print("✅: \(action.title)") : print("❗️: \(action.id) \(action.title)")
//            }
//        print("====================================================================")
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
