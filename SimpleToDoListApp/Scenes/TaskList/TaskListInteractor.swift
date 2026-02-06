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
    var worker: TaskStoreWorkerProtocol?
    
    // In-memory cache of tasks
    private var tasks: [Task] = []
    
    // Business Logic Methods
    func fetchTasks() {
        // Get tasks from Worker
        tasks = worker?.fetchTasks() ?? []
        
        // Create a response
        let response = TaskList.FetchTask.Response(tasks: tasks)
        
        // Send to Presenter
        presenter?.presentTasks(response: response)
    }
    
    func toggleTask(request: TaskList.ToggleTask.Request) {
        // Find the task
        guard let index = tasks.firstIndex(where: { $0.id == request.taskId }) else {
            // Task not found - create failure response
            let response = TaskList.ToggleTask.Response(
                updatedTask: Task(id: request.taskId, title: ""),
                success: false
            )
            presenter?.presentToggleResult(response: response)
            
            return
        }
        
        // Toggle completion status
        tasks[index].isCompleted.toggle()
        
        // Save to storage
        worker?.saveTask(tasks)
        
        // Create success response
        let response = TaskList.ToggleTask.Response(
            updatedTask: tasks[index],
            success: true
        )
        
        // Send to Presenter
        presenter?.presentToggleResult(response: response)
        
    }
    
    func addTask(request: TaskList.AddTask.Request) {
        // Validate title (Business Rule)
        let trimmedTitle = request.title.trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard !trimmedTitle.isEmpty else {
            // Validation failed
            let response = TaskList.AddTask.Response(
                task: nil,
                success: false,
                errorMessage: Constants.addTaskErrorMessageEmptyKey
            )
            presenter?.presentAddResult(response: response)
            
            return
        }
        
        guard trimmedTitle.count <= 100 else {
            // Validation failed
            let response = TaskList.AddTask.Response(
                task: nil,
                success: false,
                errorMessage: Constants.addTaskErrorMessageExceededCharactersKey
            )
            presenter?.presentAddResult(response: response)
            
            return
        }
        
        // Create new task
        let newTask = Task(
            id: UUID(),
            title: trimmedTitle,
            isCompleted: false,
            createdAt: Date()
        )
        
        // Add to collection
        tasks.append(newTask)
        
        // Save to storage
        worker?.saveTask(tasks)
        
        // Create a success response
        let response = TaskList.AddTask.Response(
            task: newTask,
            success: true,
            errorMessage: nil
        )
        
        // Send to Presenter
        presenter?.presentAddResult(response: response)
    }
    
    func deleteTask(request: TaskList.DeleteTask.Request) {
        // Find and remove task
        guard let index = tasks.firstIndex(where: { $0.id == request.taskId }) else {
            // Task not found
            let response = TaskList.DeleteTask.Response(success: false)
            presenter?.presentDeleteResult(response: response)
            
            return
        }
        
        // Remove from array
        tasks.remove(at: index)
        
        // Save to storage
        worker?.saveTask(tasks)
        
        // Create success response
        let response = TaskList.DeleteTask.Response(success: true)
        
        // Send to Presenter
        presenter?.presentDeleteResult(response: response)
    }
}
