//
//  FoodTableCell.swift
//  Demo
//
//  Created by inficare on 02/02/2022.
//

import UIKit
import SnapKit

class FoodTableCell: UITableViewCell {
    
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

    private lazy var foodImageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleToFill
        view.layer.cornerRadius = 8
        view.layer.masksToBounds = true
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
        view.snp.makeConstraints({ (make) in
            make.height.width.equalTo(80)
        })
        return view
    }()
    
    private lazy var foodNameLabel: UILabel = {
        let view = UILabel()
        view.text = ""
        view.textAlignment = .left
        view.font = UIFont.boldSystemFont(ofSize: 16)
        return view
    }()
    
    private lazy var foodDetailStackView: UIStackView = {
        let subViews = [foodNameLabel]
        let view = UIStackView(arrangedSubviews: subViews)
        view.axis = NSLayoutConstraint.Axis.vertical
        view.spacing = 0
        view.layoutMargins = UIEdgeInsets(top: 16, left: 0, bottom: 16, right: 16)
        view.isLayoutMarginsRelativeArrangement = true
        view.alignment = UIStackView.Alignment.fill
        view.distribution = UIStackView.Distribution.fillEqually
        return view
    }()
    
    private lazy var foodStackView: UIStackView = {
        let subViews = [foodImageView, foodDetailStackView]
        let view = UIStackView(arrangedSubviews: subViews)
        view.axis = NSLayoutConstraint.Axis.horizontal
        view.spacing = 12
        view.alignment = UIStackView.Alignment.fill
        view.distribution = UIStackView.Distribution.fill
        return view
    }()
    
    override func prepareForReuse() {
        foodImageView.image = nil
    }
    
    
    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        self.contentView.addSubview(mainView)
        mainView.snp.makeConstraints({ (make) in
            make.top.equalToSuperview().inset(4)
            make.leading.trailing.equalToSuperview().inset(16)
            make.bottom.equalToSuperview().inset(16)
        })
        self.mainView.addSubview(foodStackView)
        foodStackView.snp.makeConstraints({ (make) in
            make.top.equalToSuperview()
            make.leading.trailing.bottom.equalToSuperview()
        })
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func bind(viewModel: FoodCellViewModel) {
        self.foodNameLabel.text = viewModel.name
        guard let imageURL = URL(string: viewModel.image ?? "") else { return }
            DispatchQueue.global().async {
                guard let imageData = try? Data(contentsOf: imageURL) else { return }
                let image = UIImage(data: imageData)
                DispatchQueue.main.async {
                    self.foodImageView.image = image
                }
            }
    }
}

