//
//  TaskListPresenter.swift
//  SimpleToDoListApp
//
//  Created by Panachai Sulsaksakul on 2/5/26.
//

import Foundation

//MARK: - Protocols
protocol TaskListDisplayLogic: AnyObject {
    func displayTasks(viewModel: TaskList.FetchTask.ViewModel)
    func displayToggleResult(viewModel: TaskList.ToggleTask.ViewModel)
    func displayAddResult(viewModel: TaskList.AddTask.ViewModel)
    func displayDeleteResult(viewModel: TaskList.DeleteTask.ViewModel)
}

//MARK: - Presenter Implementation
class TaskListPresenter: TaskListPresentationLogic {
    // Output: Talks back to View (WEAK to avoid retain cycle)
    weak var viewController: TaskListDisplayLogic?
    
    // Date Formatter (Reusable)
    // Feb 6, 2026 at 10:30 AM
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        
        return formatter
    }()
    
    func presentTasks(response: TaskList.FetchTask.Response) {
        // Check if empty
        let emptyMessage: String? = response.tasks.isEmpty ? AppStrings.presentTasksEmptyMessage : nil
        
        // Format each task for display
        let displayTasks = response.tasks.map { task in
            TaskList.FetchTask.ViewModel.DisplayTask(
                id: task.id,
                title: task.title,
                isCompleted: task.isCompleted,
                displayDate: formateDate(task.createdAt)
            )
        }
        
        // Create ViewModel
        let viewModel = TaskList.FetchTask.ViewModel(
            displayTasks: displayTasks,
            emptyStateMessage: emptyMessage
        )
        
        // Send to View
        viewController?.displayTasks(viewModel: viewModel)
    }
    
    func presentToggleResult(response: TaskList.ToggleTask.Response) {
        guard response.success else { return }
        
        // Create simple ViewModel with updated state
        let viewModel = TaskList.ToggleTask.ViewModel(
            taskId: response.updatedTask.id,
            isCompleted: response.updatedTask.isCompleted
        )
        
        viewController?.displayToggleResult(viewModel: viewModel)
    }
    
    func presentAddResult(response: TaskList.AddTask.Response) {
        // Format error message for display
        let formattedError: String? = {
            guard let errorKey = response.errorMessage else { return nil }
            
            switch errorKey {
            case Constants.addTaskErrorMessageEmptyKey:
                return AppStrings.presentAddResultEmptyTitle
            case Constants.addTaskErrorMessageExceededCharactersKey:
                return AppStrings.presentAddResultExceededTitle
            default:
                return AppStrings.somethingWentWrongErrorMessage
            }
        }()
        
        // Create ViewModel
        let viewModel = TaskList.AddTask.ViewModel(
            success: response.success,
            errorMessage: formattedError
        )
        
        // Send to View
        viewController?.displayAddResult(viewModel: viewModel)
    }
    
    func presentDeleteResult(response: TaskList.DeleteTask.Response) {
        let viewModel = TaskList.DeleteTask.ViewModel(success: response.success)
        
        viewController?.displayDeleteResult(viewModel: viewModel)
    }
    
    // Helper Methods
    private func formateDate(_ date: Date) -> String {
        return dateFormatter.string(from: date)
    }
}
