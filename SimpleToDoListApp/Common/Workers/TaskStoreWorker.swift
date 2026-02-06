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
    private let userDefaultsKey = Constants.taskWorkerUserDefaultsKey
    private let userDefaults: UserDefaults
    
    init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
    }
    
    func fetchTasks() -> [Task] {
        guard let data = userDefaults.data(forKey: userDefaultsKey) else {
            return []
        }
        
        do {
            let tasks = try JSONDecoder().decode([Task].self, from: data)
            
            return tasks
        } catch {
            print("Error decoding tasks: \(error)")
            
            return []
        }
    }
    
    func saveTask(_ tasks: [Task]) {
        do {
            let data = try JSONEncoder().encode(tasks)
            userDefaults.set(data, forKey: userDefaultsKey)
        } catch {
            print("Error encoding tasks: \(error)")
        }
    }
}
