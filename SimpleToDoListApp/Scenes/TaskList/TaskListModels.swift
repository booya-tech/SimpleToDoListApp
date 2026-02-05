//
//  TaskListModels.swift
//  SimpleToDoListApp
//
//  Created by Panachai Sulsaksakul on 2/5/26.
//

import Foundation

enum TaskList {
    //MARK: - Use Cases
    // Fetch task
    enum FetchTask {
        struct Request { }
        
        struct Response {
            let tasks: [Task]
        }
        
        struct ViewModel {
            struct DisplayTask {
                let id: UUID
                let title: String
                let isCompleted: Bool
                let displayData: String
            }
            
            let displayTasks: [DisplayTask]
            let emptyStateMessage: String?
        }
    }
    
    // Toggle task
    enum ToggleTask {
        struct Request {
            let taskId: UUID
        }
        
        struct Response {
            let updatedTask: Task
            let success: Bool
        }
        
        struct ViewModel {
            let taskId: UUID
            let isCompleted: Bool
        }
    }
    
    // Add task
    enum AddTask {
        struct Request {
            let title: String
        }
        
        struct Response {
            let task: Task?
            let success: Bool
            let errorMessage: String?
        }
        
        struct ViewModel {
            let success: Bool
            let errorMessage: String?
        }
    }
    
    // Delete task
    enum DeleteTask {
        struct Request {
            let taskId: UUID
        }
        
        struct Response {
            let success: Bool
        }
        
        struct ViewModel {
            let success: Bool
        }
    }
}
