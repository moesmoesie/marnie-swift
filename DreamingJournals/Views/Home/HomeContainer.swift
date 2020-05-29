//
//  HomeView.swift
//  DreamBook
//
//  Created by moesmoesie on 29/04/2020.
//  Copyright © 2020 moesmoesie. All rights reserved.
//

import SwiftUI
import CoreData

struct HomeContainer: View {
    @EnvironmentObject var filterObserver : FilterObserver
    var body: some View {
        return NavigationView{
            HomeFetchContainer(filters: filterObserver.filters)
        }
    }
}

private struct HomeFetchContainer: View {
    @ObservedObject var fetchObserver = FetchObserver()
    let filters : [FilterViewModel]
    
    
    var body: some View {
        return
            HomeContent(filters: filters, limit: fetchObserver.fetchlimit)
                .environmentObject(fetchObserver)
        
        
    }
}

private struct HomeContent : View{
    @FetchRequest var fetchRequest : FetchedResults<Dream>
    @EnvironmentObject var fetchObserver : FetchObserver
    init(filters:[FilterViewModel], limit : Int) {
        self._fetchRequest = FetchRequest(fetchRequest: Dream.customFetchRequest(filterViewModels: filters, limit: limit))
    }
    
    var body: some View{
        fetchObserver.lastDream = fetchRequest.last
        return HomeView(dreams: fetchRequest)
    }
}

class FetchObserver: ObservableObject {
    @Published var fetchlimit : Int = 50
    var lastDream : Dream?
    func incrementLimit(amount : Int = 50){
        fetchlimit += amount
    }
}


