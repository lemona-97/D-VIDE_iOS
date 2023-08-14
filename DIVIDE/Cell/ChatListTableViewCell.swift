//
//  ChatListTableViewCell.swift
//  DIVIDE
//
//  Created by 임우섭 on 2022/08/05.
//

import UIKit
import Then
import SnapKit

final class ChatListTableViewCell: UITableViewCell {    
    private let cellView = UIView()
    
    private let menuImg = UIImageView()
    private let titleLabel = MainLabel(type: .Point4)
    private let lastTextLabel = MainLabel(type: .Basics1)
    private let timeLabel = MainLabel(type: .small1)
    private let msgNumView = UIView()
    private let msgNumLabel = MainLabel(type: .Basics3)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setAttribute()
        addView()
        setLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setAttribute() {
        contentView.backgroundColor = .clear
        self.backgroundColor = .clear
        
        cellView.do {
            $0.backgroundColor = .white
            $0.roundCorners(cornerRadius: 26, maskedCorners: [.layerMinXMaxYCorner, .layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMaxXMaxYCorner])
            $0.layer.addShadow(location: .all)
        }
        
        menuImg.do {
            $0.image = UIImage(named: "pizzaImage")
            $0.roundCorners(cornerRadius: 15, maskedCorners: [.layerMinXMaxYCorner, .layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMaxXMaxYCorner])

        }
        titleLabel.do {
            $0.text = "삼첩분식 드실 분 ~"
            $0.textColor = .black
        }
        
        lastTextLabel.do {
            $0.text = "넹 좋아요"
            $0.textColor = .gray2
        }
        
        timeLabel.do {
            $0.text = "오후 2:32"
            $0.textColor = .gray1
        }
        msgNumView.do {
            $0.backgroundColor = .mainYellow
            $0.cornerRadius = 10
        }
        msgNumLabel.do {
            $0.text = "5"
            $0.textColor = .white
        }
    }
    
    private func addView() {
        contentView.addSubview(cellView)
        cellView.addSubviews([menuImg, titleLabel, lastTextLabel, timeLabel, msgNumView])
        msgNumView.addSubview(msgNumLabel)
    }
    
    private func setLayout() {
        cellView.snp.makeConstraints {
            $0.trailing.equalToSuperview().offset(-20)
            $0.leading.equalToSuperview().offset(20)
            $0.top.equalToSuperview().offset(5)
            $0.bottom.equalToSuperview().offset(-5)
        }
        
        menuImg.snp.makeConstraints {
            $0.height.equalTo(52)
            $0.width.equalTo(52)
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(20)
        }
        
        titleLabel.snp.makeConstraints {
            $0.width.equalTo(160)
            $0.top.equalTo(menuImg.snp.top)
            $0.leading.equalTo(menuImg.snp.trailing).offset(20)
        }
        
        lastTextLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(10)
            $0.leading.equalTo(titleLabel.snp.leading)
        }
        timeLabel.snp.makeConstraints {
            $0.trailing.equalToSuperview().offset(-20)
            $0.centerY.equalTo(titleLabel.snp.centerY)
        }
        msgNumView.snp.makeConstraints {
            $0.height.equalTo(20)
            $0.width.equalTo(20)
            $0.trailing.equalTo(timeLabel.snp.trailing)
            $0.bottom.equalTo(menuImg.snp.bottom)
        }
        msgNumLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
    }


    open func setData(channel : Channel) {
        self.titleLabel.text = channel.id
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
