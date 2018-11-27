//
//  OverviewTableViewController.swift
//  DanalMobile
//
//  Created by BENJAMIN BRYANT BUDIMAN on 05/09/18.
//  Copyright © 2018 Danal, Inc. All rights reserved.
//

import UIKit

class OverviewTableViewController: UITableViewController {

	let segmentedControl: UISegmentedControl = {
		let segmentedControl = UISegmentedControl()
		segmentedControl.insertSegment(withTitle: "Day", at: 0, animated: false)
		segmentedControl.insertSegment(withTitle: "Week", at: 1, animated: false)
		segmentedControl.insertSegment(withTitle: "Month", at: 2, animated: false)
		segmentedControl.insertSegment(withTitle: "Year", at: 3, animated: false)
		segmentedControl.addTarget(self, action: #selector(changeGraph), for: .valueChanged)
		segmentedControl.backgroundColor = .white
		return segmentedControl
	}()
	@IBOutlet weak var graph: Graph!

	var times = [String]()

	override func viewDidLoad() {
		super.viewDidLoad()

		tableView.estimatedSectionHeaderHeight = UITableViewAutomaticDimension
		graph.frame.size.width = tableView.frame.width
		graph.displayNumber = (7, 7)
		segmentedControl.selectedSegmentIndex = 0
		changeGraph()
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}

	@objc func changeGraph() {
		let now = Date()
		let dateFormatter = DateFormatter()
		times.removeAll()
		switch segmentedControl.selectedSegmentIndex {
		case 0:
			graph.displayNumber = (24, 24)
			dateFormatter.dateFormat = "h:00 a"
			dateFormatter.locale = Locale(identifier: "en_US_POSIX")
			for i in graph.relevantValues.indices {
				times.append("\(dateFormatter.string(from: now.addingTimeInterval(-TimeInterval(i) * 60 * 60)))")
			}
		case 1:
			graph.displayNumber = (7 * 24, 7)
			dateFormatter.dateFormat = "EEEE"
			for i in graph.relevantValues.indices {
				times.append(dateFormatter.string(from: now.addingTimeInterval(-TimeInterval(i) * 24 * 60 * 60)))
			}
		case 2:
			graph.displayNumber = (30 * 24, 30)
			dateFormatter.dateFormat = "MMMM d"
			for i in graph.relevantValues.indices {
				times.append(dateFormatter.string(from: now.addingTimeInterval(-TimeInterval(i) * 24 * 60 * 60)))
			}
		case 3:
			graph.displayNumber = (365 * 24, 12)
			dateFormatter.dateFormat = "MMMM"
			for i in graph.relevantValues.indices {
				times.append(dateFormatter.string(from: now.addingTimeInterval(-TimeInterval(i) * 30 * 24 * 60 * 60)))
			}
		default:
			graph.displayNumber = (0, 0)
		}
		tableView.reloadData()
	}

	override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
		return UITableViewAutomaticDimension
	}

	override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
		return segmentedControl
	}

	override func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}

	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return times.count
	}

	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
		cell.textLabel?.text = times[indexPath.row]
		cell.detailTextLabel?.text = "\(graph.relevantValues.reversed()[indexPath.row])"
		return cell
	}
}
