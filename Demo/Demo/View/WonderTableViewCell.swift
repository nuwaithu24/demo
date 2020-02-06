




import UIKit

class WonderTableViewCell: UITableViewCell {
    @IBOutlet weak var labelFullName: UILabel!
  

    var viewModel: WonderCellViewModel? {
        didSet {
            bindViewModel()
        }
    }

    private func bindViewModel() {
        if let viewModel = viewModel {
            if let name = viewModel.location {
                 labelFullName?.text = name
            }
           
            
        }
    }
}

