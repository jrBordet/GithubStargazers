//
//  StargazerCell.swift
//  GithubStargazers
//
//  Created by Jean Raphael Bordet on 25/05/21.
//

import UIKit

class StargazerCell: UITableViewCell {
	
	@IBOutlet var nameLabel: UILabel!
	@IBOutlet var avatarImage: UIImageView!
	
	public var avatarUrl: URL?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}

extension UIImageView {
	func load(url: URL) {
		DispatchQueue.global().async { [weak self] in
			if let data = try? Data(contentsOf: url) {
				if let image = UIImage(data: data) {
					DispatchQueue.main.async {
						self?.image = image
					}
				}
			}
		}
	}
}
