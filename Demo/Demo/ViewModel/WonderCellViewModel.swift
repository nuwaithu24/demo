//

//  Demo
//
//  Created by COMQUAS on 2/6/20.
//  Copyright © 2020 COMQUAS. All rights reserved.
//


struct WonderCellViewModel {
   let location : String?
    let description : String?
    let image : String?
    let lat : String?
    let long : String?
}

extension WonderCellViewModel {
    init(wonder: Wonders) {
        self.location = wonder.location
        self.description = wonder.description
        self.image = wonder.image
        self.lat = wonder.lat
        self.long = wonder.long
    }
}
