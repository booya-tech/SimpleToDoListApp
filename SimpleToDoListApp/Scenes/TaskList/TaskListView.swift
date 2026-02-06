//
//  TaskListView.swift
//  SimpleToDoListApp
//
//  Created by Panachai Sulsaksakul on 2/6/26.
//

import SwiftUI

struct TaskListView: View {
    @StateObject var viewModel: TaskListViewModel
    
    var body: some View {
        NavigationView {
            ZStack {
                if viewModel.displayTasks.isEmpty {
                    // Empty State
                    VStack(spacing: 16) {
                        Image(systemName: AppStrings.checkListIcon)
                            .font(.system(size: 64))
                            .foregroundStyle(.gray)
                        
                        Text(viewModel.emptyMessage ?? AppStrings.emptyTaskListMessageDefault)
                            .font(.headline)
                            .foregroundStyle(.gray)
                    }
                } else {
                    // Task List
                    List {
                        ForEach(viewModel.displayTasks) { task in
                            TaskRowView(task: task) {
                                viewModel.toggleTask(id: task.id)
                            }
                        }
                        .onDelete { indexSet in
                            indexSet.forEach { index in
                                let task = viewModel.displayTasks[index]
                                viewModel.deleteTask(id: task.id)
                            }
                        }
                    }
                }
            }
        }
        .navigationTitle(AppStrings.myTasksNavigationTitle)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    viewModel.showAddSheet = true
                } label: {
                    Image(
                        systemName: AppStrings.plusIcon
                    )
                }
            }
        }
        .sheet(isPresented: $viewModel.showAddSheet) {
            AddTaskSheet { title in
                viewModel.addTask(title: title)
            } onCancel: {
                viewModel.showAddSheet = false
            }

        }
        .alert(AppStrings.error, isPresented: $viewModel.showAlert) {
            Button(AppStrings.ok, role: .cancel) { }
        } message: {
            Text(viewModel.alertMessage ?? AppStrings.somethingWentWrongErrorMessage)
        }
        .onAppear {
            viewModel.onAppear()
        }
    }
}

//MARK: - Task Row Component
struct TaskRowView: View {
    let task: TaskList.FetchTask.ViewModel.DisplayTask
    let onToggle: () -> Void
    
    var body: some View {
        HStack {
            // Checkbox
            Button(action: onToggle) {
                Image(systemName: task.isCompleted ? AppStrings.checkmarkCircleFillIcon : AppStrings.checkmarkCircleIcon)
                    .foregroundStyle(task.isCompleted ? .green : .gray)
                    .font(.title2)
            }
            
            // Task Info
            VStack(alignment: .leading, spacing: 4) {
                // Title
                Text(task.title)
                    .font(.body)
                    .strikethrough(task.isCompleted)
                    .foregroundStyle(task.isCompleted ? .gray : .primary)
                
                // Date
                Text(task.displayDate)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            
            Spacer()
        }
        .padding(.vertical, 4)
    }
}

//MARK: - Add Task Sheet
struct AddTaskSheet: View {
    @State private var taskTitle = ""
    @FocusState private var isFocused: Bool
    
    let onSave: (String) -> Void
    let onCancel: () -> Void
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField(AppStrings.taskTitle, text: $taskTitle)
                        .focused($isFocused)
                } header: {
                    Text(AppStrings.newTaskHeader)
                }
            }
            .navigationTitle(AppStrings.addTaskNavigationTitle)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button(AppStrings.cancel) {
                        onCancel()
                    }
                }
                
                ToolbarItem(placement: .topBarLeading) {
                    Button(AppStrings.save) {
                        onSave(taskTitle)
                        taskTitle = "" // Reset to empty string
                    }
                }
            }
            .onAppear {
                isFocused = true
            }
        }
    }
}

#Preview {
    let viewModel = TaskListViewModel()
    
    // Mock data for preview
    viewModel.displayTasks = [
        TaskList.FetchTask.ViewModel.DisplayTask(
            id: UUID(),
            title: "Buy milk",
            isCompleted: false,
            displayDate: "Feb 6, 2026"
        ),
        TaskList.FetchTask.ViewModel.DisplayTask(
            id: UUID(),
            title: "Call dentist",
            isCompleted: true,
            displayDate: "Feb 5, 2026"
        )
    ]
    
    return TaskListView(viewModel: viewModel)
}
