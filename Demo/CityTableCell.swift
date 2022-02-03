//
//  CityTableCell.swift
//  Demo
//
//  Created by inficare on 02/02/2022.
//

import UIKit
import SnapKit

class CityTableCell: UITableViewCell {
    
    private lazy var mainView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white.withAlphaComponent(1)
        view.layer.cornerRadius = 8
        view.layer.shadowColor = UIColor.gray.cgColor
        view.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        view.layer.shadowRadius = 8.0
        view.layer.shadowOpacity = 0.15
        return view
    }()

    private lazy var cityImageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleToFill
        view.layer.cornerRadius = 8
        view.layer.masksToBounds = true
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
        view.snp.makeConstraints({ (make) in
            make.width.equalTo(100)
        })
        return view
    }()
    
    private lazy var cityNameLabel: UILabel = {
        let view = UILabel()
        view.text = ""
        view.textAlignment = .left
        view.font = UIFont.boldSystemFont(ofSize: 16)
        return view
    }()
    
    private lazy var cityDescLabel: UILabel = {
        let view = UILabel()
        view.text = ""
        view.textAlignment = .left
        view.numberOfLines = 2
        view.font = UIFont.systemFont(ofSize: 14)
        return view
    }()
    
    private lazy var cityDetailStackView: UIStackView = {
        let subViews = [cityNameLabel, cityDescLabel]
        let view = UIStackView(arrangedSubviews: subViews)
        view.axis = NSLayoutConstraint.Axis.vertical
        view.spacing = 0
        view.layoutMargins = UIEdgeInsets(top: 12, left: 0, bottom: 16, right: 16)
        view.isLayoutMarginsRelativeArrangement = true
        view.alignment = UIStackView.Alignment.fill
        view.distribution = UIStackView.Distribution.fillEqually
        return view
    }()
    
    private lazy var cityStackView: UIStackView = {
        let subViews = [cityImageView, cityDetailStackView]
        let view = UIStackView(arrangedSubviews: subViews)
        view.axis = NSLayoutConstraint.Axis.horizontal
        view.spacing = 12
        view.alignment = UIStackView.Alignment.fill
        view.distribution = UIStackView.Distribution.fill
        return view
    }()
    
    
    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.contentView.addSubview(mainView)
        self.selectionStyle = .none
        mainView.snp.makeConstraints({ (make) in
            make.top.equalToSuperview().inset(4)
            make.leading.trailing.equalToSuperview().inset(16)
            make.bottom.equalToSuperview().inset(16)
//            make.height.equalTo(100)
        })
        self.mainView.addSubview(cityStackView)
        cityStackView.snp.makeConstraints({ (make) in
            make.top.equalToSuperview()
            make.leading.trailing.bottom.equalToSuperview()
        })
    }
    
    override func prepareForReuse() {
        cityImageView.image = nil
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func bind(viewModel: CityCellViewModel) {
        self.cityNameLabel.text = viewModel.name
        self.cityDescLabel.text = viewModel.description
        guard let imageURL = URL(string: viewModel.image ?? "") else { return }
            DispatchQueue.global().async {
                guard let imageData = try? Data(contentsOf: imageURL) else { return }
                let image = UIImage(data: imageData)
                DispatchQueue.main.async {
                    self.cityImageView.image = image
                }
            }
    }
}

