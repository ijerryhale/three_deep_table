//
//  ViewController.swift
//
//  Created by Jerry Hale on 4/11/17.
//  Copyright © 2017 jhale. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource
{
	var rowDictionary = [[String:Any]]()

	@IBOutlet weak var tableView: UITableView!
	
	func appDelegate() -> AppDelegate { return UIApplication.shared.delegate as! AppDelegate }

	override func viewDidLoad()
	{
        super.viewDidLoad()

		//	loop thru Movies and list all
		//	Theaters for a given Movie
		
		//	create a UITableView which
		//	has a non-collapsable L0_Cell
		//	that is initially expanded

		let t:[[String: AnyObject]] = appDelegate().theater
		let m:[[String: AnyObject]] = appDelegate().movie
		
		var startRow = 0
		var rowNum = -1
		
		//	loop thru all Movies
		for i in 0...m.count - 1
		{
			let movie = m[i]
			
			startRow = rowNum + 1
			rowNum += 1

			var additionalRows = 0
			//	L0 dictionary (Movie), one per
			//	L0_Cell everything that is statically
			//	defined is required to track
			//	the state of this UITableViewCell
			var l0_dict = [KEY_IS_EXPANDABLE : false,
						KEY_IS_EXPANDED : true,
						KEY_IS_VISIBLE : true,
						KEY_CELL_IDENTIFIER : VALUE_L0_CELL,
						KEY_ADDITIONAL_ROWS : 0 ] as [String : Any]

			//	add Movie title to dictionary
			l0_dict[KEY_TITLE] = movie[KEY_TITLE]
			/* l0_dict["rowNum"] = rowNum for dbug */

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
									KEY_IS_EXPANDED : false,
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

						rowDictionary.append(l1_dict)
						
						for time in alltimes
						{
							rowNum += 1
							
							//	L2 dictionary (Movie Showtime),
							//	one per L2_Cell everything that
							//	is statically defined is required
							//	to track the state of this UITableViewCell
							
							//	L2_Cells by definition are
							//	by definition --
							//	"isExpandable" : false
							//	"isExpanded" : false,
							//	"additionalRows" : 0
			
							var l2_dict = [KEY_IS_EXPANDABLE : false,
										KEY_IS_EXPANDED : false,
										KEY_IS_VISIBLE : false,
										KEY_CELL_IDENTIFIER : VALUE_L2_CELL,
										KEY_ADDITIONAL_ROWS : 0 ] as [String : Any]
							
							/* l2_dict["rowNum"] = rowNum for dbug */

							//	update additionalRows
							//	in L2_Cell dictionary
							l2_dict[KEY_TIME] = (time as! [String : AnyObject])[KEY_TIME] as! String
							
							rowDictionary.append(l2_dict)
						}
						
						break
					}
				}
			}

			l0_dict[KEY_ADDITIONAL_ROWS] = additionalRows
			rowDictionary.insert(l0_dict, at: startRow)
		}
	
		tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView(frame: CGRect.zero)
		
		tableView.separatorColor = UIColor.clear;

		tableView.register(UINib(nibName: VALUE_L0_CELL, bundle: nil), forCellReuseIdentifier: VALUE_L0_CELL)
        tableView.register(UINib(nibName: VALUE_L1_CELL, bundle: nil), forCellReuseIdentifier: VALUE_L1_CELL)
		tableView.register(UINib(nibName: VALUE_L2_CELL, bundle: nil), forCellReuseIdentifier: VALUE_L2_CELL)
	}

	override func viewWillAppear(_ animated: Bool)
	{
		tableView.reloadData();

		super.viewWillAppear(animated)
	}

    // MARK: UITableView Delegate and Datasource Functions
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
	{
		let rowDict = rowDictionary[indexPath.row] as AnyObject
		
		let	cell = tableView.dequeueReusableCell(withIdentifier:rowDict[KEY_CELL_IDENTIFIER] as! String, for: indexPath) as! SelectableCell

		if rowDict[KEY_IS_VISIBLE] as! Bool == true { cell.isHidden = false }
		else { cell.isHidden = true }
		
		if rowDict[KEY_CELL_IDENTIFIER] as! String == VALUE_L0_CELL
		{
			cell.textLabel?.text = (rowDict[KEY_TITLE] as! String)
		}
		else if rowDict[KEY_CELL_IDENTIFIER] as! String == VALUE_L1_CELL
		{
			cell.detailTextLabel?.text = (rowDict[KEY_NAME] as! String)
		}
		else if rowDict[KEY_CELL_IDENTIFIER] as! String == VALUE_L2_CELL
		{
			cell.textLabel?.text = (rowDict[KEY_TIME] as! String)
		}

		return cell
    }
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
	{
		var rowDict = rowDictionary[indexPath.row] as [String:Any]
	
//		var index = 0
//		for var rd in rowDictionary
//		{
//			if rd["additionalRows"] as! Int == 0
//			{
//				if rd["isVisible"] as! Bool == true
//				{
//					rd["isVisible"] = false
//				}
//			}
//			
//			rowDictionary[index] = rd
//			
//			index += 1
//		}
		
		if rowDict[KEY_IS_EXPANDABLE] as! Bool == true
		{
            var shouldExpandAndShowSubRows = false
			
            if rowDict[KEY_IS_EXPANDED] as! Bool == false
			{
                shouldExpandAndShowSubRows = true
            }

            rowDict[KEY_IS_EXPANDED] = shouldExpandAndShowSubRows
			
			for i in (indexPath.row + 1)...(indexPath.row + (rowDict[KEY_ADDITIONAL_ROWS] as! Int))
			{
				var d = rowDictionary[i] as [String:Any]

				d[KEY_IS_VISIBLE] = shouldExpandAndShowSubRows
				
				rowDictionary[i] = d
           }
		}

		rowDictionary[indexPath.row] = rowDict

		tableView.reloadSections(NSIndexSet(index: indexPath.section) as IndexSet, with: UITableViewRowAnimation.fade)
	}
	
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { return rowDictionary.count  }
	
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
	{
		let rowDict = rowDictionary[indexPath.row] as [String:Any]

		if rowDict[KEY_IS_VISIBLE] as! Bool == false
		{
			return 0
		}

		switch rowDict[KEY_CELL_IDENTIFIER] as! String
		{
			case "L0_Cell":
				return 30.0

			case "L1_Cell":
				return 30.0

			default:
				return 20.0
		}
    }
}
