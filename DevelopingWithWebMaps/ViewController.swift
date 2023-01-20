// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// https://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.


import UIKit

import ArcGIS

class ViewController: UIViewController {
    
    // Define the UI component, the map view
    @IBOutlet weak var mapView: AGSMapView!

    private func setupMap() {

        // Define the portal of type ArcGIS Online
        let portal = AGSPortal.arcGISOnline(withLoginRequired: false)
        // Link back to preconfigured webmap unique item ID
        let itemID = "4c14f47f88854f5388351d897db4e382"
        // Create portal item from portal and item id
        let portalItem = AGSPortalItem(portal: portal, itemID: itemID)

        // Define the map from the portal item data
        let map = AGSMap(item: portalItem)
        mapView.map = map
        map.load {[weak self] _ in self?.mapDidLoad(map) }
    
    }
    
    // Check for map errors and if there are none change the web map renderer
    private func mapDidLoad(_ map: AGSMap) {
        if let error = map.loadError {
            let errorMessage = error.localizedDescription
            // Create a new alert and present it to the user
            let errorAlert = UIAlertController(title: "Attention", message: errorMessage, preferredStyle: .alert)
            self.present(errorAlert, animated: true, completion: nil)
        } else {
            changeFeatureLayerRenderers(for: map)
        }
    }
    
    // Change the web map renderer to a customised one
    private func changeFeatureLayerRenderers(for map: AGSMap) {
        
        // Get the feature layer containing the munro mountains point data
        if let munroLayer = map.operationalLayers.object(at: 1) as? AGSFeatureLayer {
            // Turn off labels
            munroLayer.labelsEnabled = false
            // Create custom renderer from mountains.png (from https://www.flaticon.com/free-icons/mountains)
            let munroSymbol = AGSPictureMarkerSymbol(image: UIImage(named: "mountains")!)
            munroSymbol.height = 40
            munroSymbol.width = 40
            munroLayer.renderer = AGSSimpleRenderer(symbol: munroSymbol)
        }
        
        // Get the feature layer containing the national park polygon data
        if let parkLayer = map.operationalLayers.object(at: 0) as? AGSFeatureLayer {
            let parkLineSymbol = AGSSimpleLineSymbol(style: .solid, color: UIColor.black, width: 1)
            let parkSymbol = AGSSimpleFillSymbol(style: .null, color: UIColor.clear, outline: parkLineSymbol)
            // Create custom renderer
            parkLayer.renderer = AGSSimpleRenderer(symbol: parkSymbol)
        }
    }

    // When the view in the view controller of Main.storyboard has loaded, set up the map

    override func viewDidLoad() {
        super.viewDidLoad()

        setupMap()

    }
}


