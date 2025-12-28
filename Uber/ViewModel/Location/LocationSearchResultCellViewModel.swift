//
//  LocationSearchResultViewModel.swift
//  Uber
//
//  Created by Edwin Cardenas on 12/27/25.
//

import MapKit

struct LocationSearchResultCellViewModel {

    let completion: MKLocalSearchCompletion

    var title: String {
        completion.title
    }

    var subtitle: String {
        completion.subtitle
    }

}
