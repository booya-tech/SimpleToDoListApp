//
//  TaskListInteractor.swift
//  SimpleToDoListApp
//
//  Created by Panachai Sulsaksakul on 2/5/26.
//

import Foundation

//MARK: - Protocols

// What the View can ask the Interactor to do
protocol TaskListBusinessLogic {
    func fetchTasks()
    func toggleTask(request: TaskList.ToggleTask.Request)
    func addTask(request: TaskList.AddTask.Request)
    func deleteTask(request: TaskList.DeleteTask.Request)
}

// What the Interactor uses to send results to Presenter
protocol TaskListPresentationLogic {
    func presentTasks(response: TaskList.FetchTask.Response)
    func presentToggleResult(response: TaskList.ToggleTask.Response)
    func presentAddResult(response: TaskList.AddTask.Response)
    func presentDeleteResult(response: TaskList.DeleteTask.Response)
}

//MARK: - Interactor Implementation
class TaskListInteractor: TaskListBusinessLogic {
    // Output: Talks to Presenter
    var presenter: TaskListPresentationLogic?
    
    // Dependency: Worker that handles storage
    //TODO: - Implement
    //    var worker: TaskStoreWorkerProtocol?
    
    
    // Business Logic Methods
    func fetchTasks() {
        //TODO: - Implement
    }
    
    func toggleTask(request: TaskList.ToggleTask.Request) {
        //TODO: - Implement
    }
    
    func addTask(request: TaskList.AddTask.Request) {
        //TODO: - Implement
    }
    
    func deleteTask(request: TaskList.DeleteTask.Request) {
        //TODO: - Implement
    }
}
