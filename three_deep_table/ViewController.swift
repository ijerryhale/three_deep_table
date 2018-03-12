//
//  ViewController.swift
//
//  Created by Jerry Hale on 3/11/18.
//  Copyright © 2018 jhale. All rights reserved.
//

import UIKit

extension UIColor
{
    convenience init(hex:Int, alpha:CGFloat = 1.0)
    {
        self.init(
            red:   CGFloat((hex & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((hex & 0x00FF00) >> 8)  / 255.0,
            blue:  CGFloat((hex & 0x0000FF) >> 0)  / 255.0,
            alpha: alpha
        )
    }
}

extension UIView
{
    func rotate(_ toValue: CGFloat, duration: CFTimeInterval = 0.2)
    {
        let animation = CABasicAnimation(keyPath: "transform.rotation")
		
        animation.toValue = toValue
        animation.duration = duration
        animation.isRemovedOnCompletion = false
        animation.fillMode = kCAFillModeForwards
		
        self.layer.add(animation, forKey: nil)
    }
}

public struct L_2 {
    var name: String
	var collapsed: Bool
	
    public init(name: String, collapsed: Bool = false) {
        self.name = name
        self.collapsed = collapsed
    }
}

public struct TableViewRow
{
    var name: String
    var cellID: String
	var collapsed: Bool
	
    public init(name: String, cellID: String, collapsed: Bool = false) {
        self.name = name
        self.cellID = cellID
        self.collapsed = collapsed
    }
}

public struct Section {
    var name: String
    var items: [TableViewRow]
    var collapsed: Bool
	
    public init(name: String, items: [TableViewRow], collapsed: Bool = false) {
        self.name = name
        self.items = items
        self.collapsed = collapsed
    }
	
    func cellCount() -> Int
    {
		let l1count = items.count
		
		print(l1count)

		return (items.count)
    }
}

public var sectionsData: [Section] = [
    Section(name: "Despicable Me 3", items: [
        TableViewRow(name: "Bluelight Cinema 5" , cellID: VALUE_L1_CELL),
		TableViewRow(name: "1:15 PM" , cellID: VALUE_L2_CELL),
		TableViewRow(name: "2:30 PM" , cellID: VALUE_L2_CELL),
		
        TableViewRow(name: "Downtown Cineplex" , cellID: VALUE_L1_CELL),
		TableViewRow(name: "4:15 PM" , cellID: VALUE_L2_CELL),
		TableViewRow(name: "5:30 PM" , cellID: VALUE_L2_CELL)

		
         ]),
    Section(name: "Leap!", items: [
        TableViewRow(name: "AMC 16" , cellID: VALUE_L1_CELL),
		TableViewRow(name: "12:00 PM" , cellID: VALUE_L2_CELL),
		TableViewRow(name: "1:30 PM" , cellID: VALUE_L2_CELL)
		
         ])

]
protocol L0_Delegate {
    func toggleSection(_ header: L0_Cell, section: Int)
}

//class TableViewRowCell: UITableViewCell {
//
//    let nameLabel = UILabel()
//   // let detailLabel = UILabel()
//
//    // MARK: Initalizers
//    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
//        super.init(style: style, reuseIdentifier: reuseIdentifier)
//
//        let marginGuide = contentView.layoutMarginsGuide
//
//        // configure nameLabel
//        contentView.addSubview(nameLabel)
//        nameLabel.translatesAutoresizingMaskIntoConstraints = false
//        nameLabel.leadingAnchor.constraint(equalTo: marginGuide.leadingAnchor).isActive = true
//        nameLabel.topAnchor.constraint(equalTo: marginGuide.topAnchor).isActive = true
//        nameLabel.trailingAnchor.constraint(equalTo: marginGuide.trailingAnchor).isActive = true
//        nameLabel.numberOfLines = 0
//        nameLabel.font = UIFont.systemFont(ofSize: 16)
//
//        // configure detailLabel
////        contentView.addSubview(detailLabel)
////        detailLabel.lineBreakMode = .byWordWrapping
////        detailLabel.translatesAutoresizingMaskIntoConstraints = false
////        detailLabel.leadingAnchor.constraint(equalTo: marginGuide.leadingAnchor).isActive = true
////        detailLabel.bottomAnchor.constraint(equalTo: marginGuide.bottomAnchor).isActive = true
////        detailLabel.trailingAnchor.constraint(equalTo: marginGuide.trailingAnchor).isActive = true
////        detailLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 5).isActive = true
////        detailLabel.numberOfLines = 0
////        detailLabel.font = UIFont.systemFont(ofSize: 12)
////        detailLabel.textColor = UIColor.lightGray
//    }
//
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//}


class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource
{
	//	set to true to allow only
	//	one L1_Cell to be selected
	var singleRowSelect = true
	var rowDictionary = [[String:Any]]()

	var sections = sectionsData

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

//		let t:[[String: AnyObject]] = appDelegate().theater
//		let m:[[String: AnyObject]] = appDelegate().movie
//		
//		var startRow = 0
//		var rowNum = -1
//		
//		//	loop thru all Movies
//		for i in 0...m.count - 1
//		{
//			let movie = m[i]
//			
//			startRow = rowNum + 1
//			rowNum += 1
//
//			var additionalRows = 0
//			//	L0 dictionary (Movie), one per
//			//	L0_Cell everything that is statically
//			//	defined is required to track
//			//	the state of this UITableViewCell
//			var l0_dict = [KEY_IS_EXPANDABLE : false,
//						KEY_IS_EXPANDED : true,
//						KEY_IS_VISIBLE : true,
//						KEY_CELL_IDENTIFIER : VALUE_L0_CELL,
//						KEY_ADDITIONAL_ROWS : 0 ] as [String : Any]
//
//			//	add Movie title to dictionary
//			l0_dict[KEY_TITLE] = movie[KEY_TITLE]
//			/* l0_dict["rowNum"] = rowNum for dbug */
//
//			//	loop thru all Theaters and look
//			//	at now_showing array for this Movie
//			for j in 0...t.count - 1
//			{
//				var tt = t[j] as [String : AnyObject]
//
//				for ns in tt[KEY_NOW_SHOWING] as! [AnyObject]
//				{
//					//	if the Movie is being shown at this
//					//	Theater add it to the array
//					let tms_id = ns[KEY_TMS_ID] as! String
//
//					if movie[KEY_TMS_ID] as! String == tms_id
//					{
//						rowNum += 1
//
//						//	L1 dictionary (Theater), one per
//						//	L1_Cell everything that is statically
//						//	defined is required to track
//						//	the state of this UITableViewCell
//						var l1_dict = [KEY_IS_EXPANDABLE : true,
//									KEY_IS_EXPANDED : false,
//									KEY_IS_VISIBLE : true,
//									KEY_CELL_IDENTIFIER : VALUE_L1_CELL,
//									KEY_ADDITIONAL_ROWS : 0 ] as [String : Any]
//
//						//	add Theater name to
//						//	L1_Cell  dictionary
//						l1_dict[KEY_NAME] = tt[KEY_NAME]
//						
//						//	add Movie tms_id to
//						//	L1_Cell dictionary
//						l1_dict[KEY_TMS_ID] = tms_id
//						
//						let alltimes = ns[KEY_ALL_TIMES] as! NSArray
//
//						additionalRows += alltimes.count + 1
//						
//						//	update additionalRows
//						//	in L1_Cell dictionary
//						l1_dict[KEY_ADDITIONAL_ROWS] = alltimes.count
//						
//						/*	l1_dict["rowNum"] = rowNum for dbug */
//
//						rowDictionary.append(l1_dict)
//						
//						for time in alltimes
//						{
//							rowNum += 1
//							
//							//	L2 dictionary (Movie Showtime),
//							//	one per L2_Cell everything that
//							//	is statically defined is required
//							//	to track the state of this UITableViewCell
//							
//							//	L2_Cells by definition are
//							//	by definition --
//							//	"isExpandable" : false
//							//	"isExpanded" : false,
//							//	"additionalRows" : 0
//			
//							var l2_dict = [KEY_IS_EXPANDABLE : false,
//										KEY_IS_EXPANDED : false,
//										KEY_IS_VISIBLE : false,
//										KEY_CELL_IDENTIFIER : VALUE_L2_CELL,
//										KEY_ADDITIONAL_ROWS : 0 ] as [String : Any]
//							
//							/* l2_dict["rowNum"] = rowNum for dbug */
//
//							//	update additionalRows
//							//	in L2_Cell dictionary
//							l2_dict[KEY_TIME] = (time as! [String : AnyObject])[KEY_TIME] as! String
//							
//							rowDictionary.append(l2_dict)
//						}
//						
//						break
//					}
//				}
//			}
//
//			l0_dict[KEY_ADDITIONAL_ROWS] = additionalRows
//			rowDictionary.insert(l0_dict, at: startRow)
//		}
	
		tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView(frame: CGRect.zero)
		
		tableView.separatorColor = UIColor.clear;

        tableView.register(UINib(nibName: VALUE_L1_CELL, bundle: nil), forCellReuseIdentifier: VALUE_L1_CELL)
		tableView.register(UINib(nibName: VALUE_L2_CELL, bundle: nil), forCellReuseIdentifier: VALUE_L2_CELL)
	}

	override func viewWillAppear(_ animated: Bool)
	{
		tableView.reloadData();

		super.viewWillAppear(animated)
	}
}

extension ViewController: L0_Delegate
{
    func toggleSection(_ header: L0_Cell, section: Int)
    {
        let collapsed = !sections[section].collapsed
		
        // Toggle collapse
        sections[section].collapsed = collapsed
 		header.setCollapsed(collapsed)
		
        tableView.reloadSections(NSIndexSet(index: section) as IndexSet, with: .automatic)
    }
}

extension ViewController
{
	func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat { return (44.0) }
	func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat { return (1.0) }

//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { return rowDictionary.count  }
	func numberOfSections(in tableView: UITableView) -> Int { return (sections.count) }

	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].collapsed ? 0 : sections[section].cellCount()
    }

	func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    {
       let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: VALUE_L0_CELL) as? L0_Cell ?? L0_Cell(reuseIdentifier: VALUE_L0_CELL)

		header.setCollapsed(sections[section].collapsed)
		header.addGestureRecognizer(UITapGestureRecognizer(target: header, action: #selector(L0_Cell.tapHeader(_:))))
		
        header.titleLabel.text = sections[section].name
		header.section = section
		header.delegate = self
		
        return (header)
    }

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let tableViewRow: TableViewRow = sections[indexPath.section].items[indexPath.row]
		
		if tableViewRow.cellID == VALUE_L1_CELL
		{
			let cell: L1_Cell = tableView.dequeueReusableCell(withIdentifier: VALUE_L1_CELL) as! L1_Cell
			
			cell.name.text = tableViewRow.name
			
			return (cell)
		}
		else if tableViewRow.cellID == VALUE_L2_CELL
		{
			let cell: L2_Cell = tableView.dequeueReusableCell(withIdentifier: VALUE_L2_CELL) as! L2_Cell
			
			cell.time.text = tableViewRow.name
			
			return (cell)
		}

		return (UITableViewCell())
    }

    // MARK: UITableView Delegate and Datasource Functions
//	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
//	{
//		let rowDict = rowDictionary[indexPath.row] as AnyObject
//		
//		let	cell = tableView.dequeueReusableCell(withIdentifier:rowDict[KEY_CELL_IDENTIFIER] as! String, for: indexPath) as! SelectableCell
//
//		if rowDict[KEY_IS_VISIBLE] as! Bool == true { cell.isHidden = false }
//		else { cell.isHidden = true }
//		
//		if rowDict[KEY_CELL_IDENTIFIER] as! String == VALUE_L0_CELL
//		{
//			cell.textLabel?.text = (rowDict[KEY_TITLE] as! String)
//		}
//		else if rowDict[KEY_CELL_IDENTIFIER] as! String == VALUE_L1_CELL
//		{
//			cell.detailTextLabel?.text = (rowDict[KEY_NAME] as! String)
//		}
//		else if rowDict[KEY_CELL_IDENTIFIER] as! String == VALUE_L2_CELL
//		{
//			cell.textLabel?.text = (rowDict[KEY_TIME] as! String)
//		}
//
//		return cell
//    }
	
//	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
//	{
//		var rowDict = rowDictionary[indexPath.row] as [String:Any]
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

//		tableView.reloadSections(NSIndexSet(index: indexPath.section) as IndexSet, with: UITableViewRowAnimation.fade)
//	}
	
//	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
//    {
//        return UITableViewAutomaticDimension
//    }

	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
	{
		let tableViewRow: TableViewRow = sections[indexPath.section].items[indexPath.row]
		
		switch tableViewRow.cellID
		{
			case VALUE_L1_CELL:
				return 30.0

			default:
				return 14.0
		}

//		let rowDict = rowDictionary[indexPath.row] as [String:Any]
//
//		if rowDict[KEY_IS_VISIBLE] as! Bool == false
//		{
//			return 0
//		}
//
//		switch rowDict[KEY_CELL_IDENTIFIER] as! String
//		{
//			case VALUE_L0_CELL:
//				return 30.0
//
//			case VALUE_L1_CELL:
//				return 30.0
//
//			default:
//				return 20.0
//		}
    }
}
