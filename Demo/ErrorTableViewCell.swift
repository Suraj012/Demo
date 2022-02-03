//
//  ErrorTableViewCell.swift
//  Demo
//
//  Created by inficare on 03/02/2022.
//

import UIKit

public class ErrorTableViewCell: UITableViewCell {
    
    lazy var titleLabel: UILabel = {
        let view = UILabel()
        view.text = ""
        view.font = UIFont.boldSystemFont(ofSize: 16)
        view.textAlignment = .center
        view.numberOfLines = 0
        return view
    }()
    lazy var descriptionLabel: UILabel = {
        let view = UILabel()
        view.text = ""
        view.font = UIFont.systemFont(ofSize: 14)
        view.textAlignment = .center
        view.numberOfLines = 0
        return view
    }()
    lazy var contentStackView: UIStackView = {
        let subViews = [titleLabel, descriptionLabel]
        let view = UIStackView(arrangedSubviews: subViews)
        view.axis = NSLayoutConstraint.Axis.vertical
        view.spacing = 0
        view.alignment = UIStackView.Alignment.fill
        view.distribution = UIStackView.Distribution.fill
        return view
    }()
    
    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.contentView.addSubview(contentStackView)
        self.selectionStyle = .none
        
        contentStackView.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().inset(15)
            make.left.greaterThanOrEqualToSuperview().inset(16)
            make.right.lessThanOrEqualToSuperview().inset(16)
            make.bottom.equalToSuperview().inset(16)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func bind(title: String?, description: String?) {
        titleLabel.text = title
        descriptionLabel.text = description
    }
    
}

