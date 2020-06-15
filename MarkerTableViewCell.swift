//
//  MarkerTableViewCell.swift
//  AQIMap
//
//  Created by jaewon on 2020/06/10.
//  Copyright © 2020 jaewon. All rights reserved.
//

import UIKit
import GoogleMaps
import RxSwift
import RxCocoa

class MarkerTableViewCell: UITableViewCell {
    
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var coordinateLabel: UILabel!
    @IBOutlet var removeButton: UIButton!
    
    var disposeBag = DisposeBag()
    
    var marker: GMSMarker? {
        didSet {
            guard let marker = self.marker else { return }
            
            self.nameLabel.text = marker.title
            self.coordinateLabel.text = "(\(marker.position.latitude.rounded(toPlaces: 4)), \(marker.position.longitude.rounded(toPlaces: 4)))"
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.disposeBag = DisposeBag()
    }
    
    func setRemoveButtonAction() -> ControlEvent<Void> {
        return self.removeButton.rx.tap
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
