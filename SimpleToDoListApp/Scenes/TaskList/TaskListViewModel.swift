//
//  TaskListViewModel.swift
//  SimpleToDoListApp
//
//  Created by Panachai Sulsaksakul on 2/6/26.
//

import SwiftUI
internal import Combine

class TaskListViewModel: ObservableObject, TaskListDisplayLogic {
    // Published properties trigger UI updates
    @Published var displayTasks: [TaskList.FetchTask.ViewModel.DisplayTask] = []
    @Published var emptyMessage: String?
    @Published var showAddSheet = false
    @Published var alertMessage: String?
    @Published var showAlert = false
    
    // VIP components
    var interactor: TaskListBusinessLogic?
    //TODO: - Implement
    //    var router: TaskListRoutingLogic?
    
    func onAppear() {
        interactor?.fetchTasks()
    }
    
    func toggleTask(id: UUID) {
        let request = TaskList.ToggleTask.Request(taskId: id)
        interactor?.toggleTask(request: request)
    }
    
    func addTask(title: String) {
        let request = TaskList.AddTask.Request(title: title)
        interactor?.addTask(request: request)
    }
    
    func deleteTask(id: UUID) {
        let request = TaskList.DeleteTask.Request(taskId: id)
        interactor?.deleteTask(request: request)
    }
    
    //MARK: - Display Logic Protocol (Presenter calls here)
    func displayTasks(viewModel: TaskList.FetchTask.ViewModel) {
        displayTasks = viewModel.displayTasks
        emptyMessage = viewModel.emptyStateMessage
    }
    
    func displayToggleResult(viewModel: TaskList.ToggleTask.ViewModel) {
        // Update the specific task in our array
        if let index = displayTasks.firstIndex(where: { $0.id == viewModel.taskId }) {
            displayTasks[index] = TaskList.FetchTask.ViewModel.DisplayTask(
                id: displayTasks[index].id,
                title: displayTasks[index].title,
                isCompleted: displayTasks[index].isCompleted,
                displayDate: displayTasks[index].displayDate
            )
        }
    }
    
    func displayAddResult(viewModel: TaskList.AddTask.ViewModel) {
        if viewModel.success {
            // Success - dismiss sheet and refresh
            showAddSheet = false
            interactor?.fetchTasks()
        } else {
            // Error - show alert
            alertMessage = viewModel.errorMessage
            showAlert = true
        }
    }
    
    func displayDeleteResult(viewModel: TaskList.DeleteTask.ViewModel) {
        if viewModel.success {
            // Refresh List
            interactor?.fetchTasks()
        }
    }
}
