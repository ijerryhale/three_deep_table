//
//  ViewController.swift
//
//  Created by Jerry Hale on 3/11/18.
//  Copyright © 2018 jhale. All rights reserved.
//

import UIKit

public struct Section {

    var dict = [String : Any]()
    var isExpanded: Bool
	var cell = [[String : Any]]()
	
	public init(name: String, isExpanded: Bool = false) {
        self.dict[KEY_NAME] = name
        self.isExpanded = isExpanded
    }
}

class ViewController: UIViewController
{
	//	set to true to allow only
	//	one L1_Cell to be selected
	var singleRowSelect = true
	var rowDictionary = [Section]()

	@IBOutlet weak var tableView: UITableView!
	
	func appDelegate() -> AppDelegate { return UIApplication.shared.delegate as! AppDelegate }

	override func viewDidLoad()
	{ super.viewDidLoad()

		//	loop thru Movies and list all
		//	Theaters for a given Movie
		
		//	create a UITableView which
		//	has a expandable Section
		//	that is initially collapsed

		let t:[[String: AnyObject]] = appDelegate().theater
		let m:[[String: AnyObject]] = appDelegate().movie

		var rowNum = -1
		
		//	loop thru all Movies
		for i in 0...m.count - 1
		{
			let movie = m[i]
			var additionalRows = 0
			var section = Section(name: movie[KEY_TITLE] as! String)

			rowNum += 1
			//	loop thru all Theaters and look
			//	at now_showing array for this Movie
			for j in 0...t.count - 1
			{
				var tt = t[j] as [String : AnyObject]

				for ns in tt[KEY_NOW_SHOWING] as! [AnyObject]
				{
					//	if the Movie is being shown at this
					//	Theater add it to the array
					let tms_id = ns[KEY_TMS_ID] as! String

					if movie[KEY_TMS_ID] as! String == tms_id
					{
						rowNum += 1

						//	L1 dictionary (Theater), one per
						//	L1_Cell everything that is statically
						//	defined is required to track
						//	the state of this UITableViewCell
						var l1_dict = [KEY_IS_EXPANDABLE : true,
									KEY_IS_EXPANDED : true,
									KEY_IS_VISIBLE : true,
									KEY_CELL_IDENTIFIER : VALUE_L1_CELL,
									KEY_ADDITIONAL_ROWS : 0 ] as [String : Any]

						//	add Theater name to
						//	L1_Cell  dictionary
						l1_dict[KEY_NAME] = tt[KEY_NAME]

						//	add Movie tms_id to
						//	L1_Cell dictionary
						l1_dict[KEY_TMS_ID] = tms_id
						
						let alltimes = ns[KEY_ALL_TIMES] as! NSArray

						additionalRows += alltimes.count + 1
						
						//	update additionalRows
						//	in L1_Cell dictionary
						l1_dict[KEY_ADDITIONAL_ROWS] = alltimes.count
						
						/*	l1_dict["rowNum"] = rowNum for dbug */
						section.cell.append(l1_dict)
						
						for time in alltimes
						{
							rowNum += 1
							//	L2 dictionary (Movie Showtime),
							//	one per L2_Cell everything that
							//	is statically defined is required
							//	to track the state of this UITableViewCell
							
							//	L2_Cells by definition are
							//	"isExpandable" : false
							//	"isExpanded" : false,
							//	"additionalRows" : 0
							var l2_dict = [KEY_IS_EXPANDABLE : false,
										KEY_IS_EXPANDED : false,
										KEY_IS_VISIBLE : true,
										KEY_CELL_IDENTIFIER : VALUE_L2_CELL,
										KEY_ADDITIONAL_ROWS : 0 ] as [String : Any]
							
							/* l2_dict["rowNum"] = rowNum for dbug */
							l2_dict[KEY_TIME] = (time as! [String : AnyObject])[KEY_TIME] as! String
							
							section.cell.append(l2_dict)
						}
						
						break
					}
				}
			}

			rowDictionary.append(section)
		}
		
		print(rowDictionary.count)

		tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView(frame: CGRect.zero)
		tableView.separatorColor = UIColor.clear;

        tableView.register(UINib(nibName: VALUE_L1_CELL, bundle: nil), forCellReuseIdentifier: VALUE_L1_CELL)
		tableView.register(UINib(nibName: VALUE_L2_CELL, bundle: nil), forCellReuseIdentifier: VALUE_L2_CELL)
	}

	override func viewWillAppear(_ animated: Bool)
	{ super.viewWillAppear(animated)
		
		tableView.reloadData();
	}
}

extension ViewController: SectionHeaderDelegate
{
    func toggleSectionIsExpanded(_ header: L0_Cell, section: Int)
    {
        let isExpanded = !rowDictionary[section].isExpanded
		
        //	toggle collapse
 		header.setIsExpanded(isExpanded)
 		rowDictionary[section].isExpanded = isExpanded
		
        tableView.reloadSections(NSIndexSet(index: section) as IndexSet, with: .automatic)
    }
}

extension ViewController : UITableViewDelegate
{
	func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat { return (44.0) }
	func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat { return (1.0) }

	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
	{
		let cell: [String : Any] = rowDictionary[indexPath.section].cell[indexPath.row]

		if cell[KEY_IS_VISIBLE] as! Bool == true
		{
			switch cell[KEY_CELL_IDENTIFIER] as! String
			{
				case VALUE_L1_CELL:
					return (30.0)

				default:
					return (16.0)
			}
		}
	
		return (0)
    }
}

extension ViewController : UITableViewDataSource
{
	func numberOfSections(in tableView: UITableView) -> Int { return (rowDictionary.count) }

	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
	{
        return rowDictionary[section].isExpanded ? rowDictionary[section].cell.count : 0
    }

	func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    {
       let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: VALUE_L0_CELL) as? L0_Cell ?? L0_Cell(reuseIdentifier: VALUE_L0_CELL)

		header.setIsExpanded(rowDictionary[section].isExpanded)
		header.titleLabel.text = rowDictionary[section].dict[KEY_NAME] as? String
		header.section = section
		header.delegate = self
		
        return (header)
    }

    // MARK: UITableView Delegate and Datasource Functions
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
	{
		let rowDict = rowDictionary[indexPath.section].cell[indexPath.row]
		let	cell = tableView.dequeueReusableCell(withIdentifier:rowDict[KEY_CELL_IDENTIFIER] as! String, for: indexPath)

		if rowDict[KEY_IS_VISIBLE] as! Bool == true { cell.isHidden = false }
		else { cell.isHidden = true }
		
		if rowDict[KEY_CELL_IDENTIFIER] as! String == VALUE_L1_CELL
		{
			let c = cell as! L1_Cell
			c.name.text = (rowDict[KEY_NAME] as! String)
		}
		else if rowDict[KEY_CELL_IDENTIFIER] as! String == VALUE_L2_CELL
		{
			let c = cell as! L2_Cell
			c.time.text = (rowDict[KEY_TIME] as! String)
		}

		return cell
    }
	
//	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
//	{
//		let rowDict = rowDictionary[indexPath.section].cell[indexPath.row]
//
//		if singleRowSelect == true
//		&& rowDict[KEY_CELL_IDENTIFIER] as! String == VALUE_L1_CELL
//		{
//			var index = 0
//			for var rd in rowDictionary
//			{
//				if rd[KEY_CELL_IDENTIFIER] as! String == VALUE_L1_CELL
//				{
//					if rd[KEY_IS_EXPANDED] as! Bool == true
//					{
//						rd[KEY_IS_EXPANDED] = false
//					}
//				}
//				else if rd["additionalRows"] as! Int == 0
//				{
//					if rd["isVisible"] as! Bool == true
//					{
//						rd["isVisible"] = false
//					}
//				}
//
//				rowDictionary[index] = rd
//
//				index += 1
//			}
//		}
//
//		if rowDict[KEY_IS_EXPANDABLE] as! Bool == true
//		{
//            var shouldExpandAndShowSubRows = false
//
//            if rowDict[KEY_IS_EXPANDED] as! Bool == false
//			{
//                shouldExpandAndShowSubRows = true
//            }
//
//            rowDict[KEY_IS_EXPANDED] = shouldExpandAndShowSubRows
//
//			for i in (indexPath.row + 1)...(indexPath.row + (rowDict[KEY_ADDITIONAL_ROWS] as! Int))
//			{
//				var d = rowDictionary[i] as [String:Any]
//
//				d[KEY_IS_VISIBLE] = shouldExpandAndShowSubRows
//
//				rowDictionary[i] = d
//           }
//		}
//
//		rowDictionary[indexPath.row] = rowDict
//
//		tableView.reloadSections(NSIndexSet(index: indexPath.section) as IndexSet, with: UITableViewRowAnimation.fade)
//	}
}
