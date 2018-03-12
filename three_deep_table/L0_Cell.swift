//
//  L0Cell_movie.swift
//  movies
//
//  Created by Jerry Hale on 5/26/17.
//  Copyright © 2017 jhale. All rights reserved.
//

import UIKit

class L0_Cell: UITableViewHeaderFooterView
{
	let titleLabel = UILabel()
	let disclosureButton = UIButton()

	var delegate: L0_Delegate?
    var section: Int = 0
	
    override init(reuseIdentifier: String?)
    {
        super.init(reuseIdentifier: reuseIdentifier)

        // Content View
       //	 contentView.backgroundColor = UIColor(hex: 0x2E3944)
		
       contentView.backgroundColor = UIColor(hex: 0xEEEEEE)

        let marginGuide = contentView.layoutMarginsGuide

        // Title label
        contentView.addSubview(titleLabel)
        titleLabel.textColor = UIColor.black
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.topAnchor.constraint(equalTo: marginGuide.topAnchor).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: marginGuide.trailingAnchor).isActive = true
        titleLabel.bottomAnchor.constraint(equalTo: marginGuide.bottomAnchor).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: marginGuide.leadingAnchor).isActive = true

        // Arrow label
        disclosureButton.setImage(UIImage(named: "carat.png"), for: UIControlState.normal)
		disclosureButton.setImage(UIImage(named: "carat-open.png"), for: UIControlState.selected)

		disclosureButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(L0_Cell.tapHeader(_:))))

        contentView.addSubview(disclosureButton)
       // arrowLabel.textColor = UIColor.white
        disclosureButton.translatesAutoresizingMaskIntoConstraints = false
        disclosureButton.widthAnchor.constraint(equalToConstant: 24).isActive = true
        disclosureButton.topAnchor.constraint(equalTo: marginGuide.topAnchor).isActive = true
        disclosureButton.trailingAnchor.constraint(equalTo: marginGuide.trailingAnchor).isActive = true
		disclosureButton.bottomAnchor.constraint(equalTo: marginGuide.bottomAnchor).isActive = true

         addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(L0_Cell.tapHeader(_:))))
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

	@objc func tapHeader(_ gestureRecognizer: UITapGestureRecognizer)
	{
        guard let cell = gestureRecognizer.view as? L0_Cell else {
			let cell = gestureRecognizer.view as? UIButton

			delegate?.toggleSection(self, section: (cell?.superview?.superview as! L0_Cell).section)
			
			return
        }

        delegate?.toggleSection(self, section: cell.section)
    }
	
    func setCollapsed(_ collapsed: Bool) {
        //
        // Animate the arrow rotation (see Extensions.swf)
        //
		disclosureButton.isSelected = !collapsed
       // arrowLabel.rotate(collapsed ? 0.0 : .pi / 2)
    }

}
