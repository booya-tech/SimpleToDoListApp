//
//  TaskStoreWorker.swift
//  SimpleToDoListApp
//
//  Created by Panachai Sulsaksakul on 2/5/26.
//

import Foundation

//MARK: - Protocol

// Defines storage operations for tasks (UserDefaults)
protocol TaskStoreWorkerProtocol {
    func fetchTasks() -> [Task]
    func saveTask(_ tasks: [Task])
}

//MARK: - Worker Implementation

class TaskStoreWorker: TaskStoreWorkerProtocol {
    private let userDefaultsKey = "saved_tasks"
    
    func fetchTasks() -> [Task] {
        //TODO: - Load from UserDefaults
        return []
    }
    
    func saveTask(_ tasks: [Task]) {
        //TODO: - Save to UserDefaults
    }
}
