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
    
    func presentTasks(response: TaskList.FetchTask.Response) {
        //TODO: - Format tasks for display
    }
    
    func presentToggleResult(response: TaskList.ToggleTask.Response) {
        //TODO: - Format toggle result
    }
    
    func presentAddResult(response: TaskList.AddTask.Response) {
        //TODO: - Format add result
    }
    
    func presentDeleteResult(response: TaskList.DeleteTask.Response) {
        //TODO: - Format delete result
    }
}
