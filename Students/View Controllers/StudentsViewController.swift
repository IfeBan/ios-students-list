//
//  MainViewController.swift
//  Students
//
//  Created by Ben Gohlke on 6/17/19.
//  Copyright © 2019 Lambda Inc. All rights reserved.
//

import UIKit

class StudentsViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var sortSelector: UISegmentedControl!
    @IBOutlet weak var filterSelector: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    
    private let studentController = StudentController()
    
    private var students: [Student] = [] {
        didSet {
            updateDataSource()
        }
    }
    
    // MARK: - Properties
    
    private var filteredAndSortedStudents: [Student] = [] {
        didSet {
            tableView.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        studentController.loadFromPersistenceStore { students, error in
            if let error = error {
                print("Error loading students: \(error)")
                return
            }
            
            DispatchQueue.main.async {
                self.students = students ?? []
            }
        }
    }
    
    // MARK: - Action Handlers
    
    @IBAction func sort(_ sender: UISegmentedControl) {
        updateDataSource()
    }
    
    @IBAction func filter(_ sender: UISegmentedControl) {
        updateDataSource()
    }
    
    // MARK: - Private
    
    private func updateDataSource() {
        var updatedStudents: [Student]
        
        switch filterSelector.selectedSegmentIndex {
        case 1:
            updatedStudents = students.filter({ student  -> Bool in
                return student.course == "iOS"
            })
        case 2:
            updatedStudents = students.filter { $0.course == "Web"}
        case 3:
            updatedStudents = students.filter { $0.course == "UX"}
        default:
            updatedStudents = students
            
        }
        
        if sortSelector.selectedSegmentIndex == 0 {
            updatedStudents = updatedStudents.sorted { $0.firstName < $1.lastName }
        } else {
            updatedStudents = updatedStudents.sorted(by: { (lhs, rhs) -> Bool in
                lhs.lastName < rhs.firstName
            })
        }
        
        filteredAndSortedStudents = updatedStudents
    }
}

extension StudentsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredAndSortedStudents.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StudentCell", for: indexPath)
        
        let aStudent = filteredAndSortedStudents[indexPath.row]
        cell.textLabel?.text = aStudent.name
        cell.detailTextLabel?.text = aStudent.course
        
        return cell
    }
}
