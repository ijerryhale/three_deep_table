//
//  L0_Cell.swift
//
//  Created by Jerry Hale on 3/18/18.
//  Copyright © 2019 jhale. All rights reserved.
//

import UIKit

protocol SectionHeaderDelegate {
    func toggleSectionIsExpanded(_ header: L0_Cell, section: Int)
}

class L0_Cell: UITableViewHeaderFooterView
{
	let titleLabel = UILabel()
	let disclosureButton = UIButton()

	var delegate: SectionHeaderDelegate?
    var section: Int = 0

    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    override init(reuseIdentifier: String?)
    { super.init(reuseIdentifier: reuseIdentifier)

		let red = CGFloat((0xEEEEEE & 0xFF0000) >> 16) / 255.0
		let green = CGFloat((0xEEEEEE & 0x00FF00) >> 8) / 255.0
		let blue = CGFloat(0xEEEEEE & 0x00FF) / 255.0

		contentView.backgroundColor = UIColor(red: red,
											green: green,
											blue: blue,
											alpha: 0.2)

        let marginGuide = contentView.layoutMarginsGuide
		
        disclosureButton.setImage(UIImage(named: "carat.png"), for: UIControl.State.normal)
		disclosureButton.setImage(UIImage(named: "carat-open.png"), for: UIControl.State.selected)

        contentView.addSubview(disclosureButton)

        disclosureButton.translatesAutoresizingMaskIntoConstraints = false
        disclosureButton.widthAnchor.constraint(equalToConstant: 24).isActive = true
        disclosureButton.topAnchor.constraint(equalTo: marginGuide.topAnchor).isActive = true
        disclosureButton.leadingAnchor.constraint(equalTo: marginGuide.leadingAnchor).isActive = true

		disclosureButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(L0_Cell.tapHeader(_:))))

        contentView.addSubview(titleLabel)

        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.trailingAnchor.constraint(equalTo: marginGuide.trailingAnchor).isActive = true

        titleLabel.topAnchor.constraint(equalTo: marginGuide.topAnchor).isActive = true
 
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(L0_Cell.tapHeader(_:))))
    }

	@objc func tapHeader(_ gestureRecognizer: UITapGestureRecognizer)
	{
        guard let cell = gestureRecognizer.view as? L0_Cell else {
			let cell = gestureRecognizer.view as? UIButton

			delegate?.toggleSectionIsExpanded(self, section: (cell?.superview?.superview as! L0_Cell).section)
			
			return
        }

        delegate?.toggleSectionIsExpanded(self, section: cell.section)
    }
	
    func setIsExpanded(_ isExpanded: Bool) { disclosureButton.isSelected = isExpanded }
}
