import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Google Maps Demo',
      home: MapSample(),
    );
  }
}

class MapSample extends StatefulWidget {
  @override
  State<MapSample> createState() => MapSampleState();
}

class MapSampleState extends State<MapSample> {
  Completer<GoogleMapController> _controller = Completer();
  PanelController _panelController;
  bool _isBrowsed = false;

  @override
  void initState() {
    super.initState();
    _panelController = PanelController();
  }

  @override
  void dispose() {
    super.dispose();
  }

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  static final CameraPosition _kLake = CameraPosition(
      bearing: 192.8334901395799,
      target: LatLng(37.43296265331129, -122.08832357078792),
      tilt: 59.440717697143555,
      zoom: 19.151926040649414);

  List<Shop> _shops = [
    Shop(
      id: "id001",
      shopLocation: LatLng(37.433, -122.088),
      shopName: "珈琲屋",
      imagePath: "images/coffee.jpg",
      description: "素敵な珈琲屋さん",
    ),
    Shop(
      id: "id002",
      shopLocation: LatLng(37.434, -122.088),
      shopName: "マクドナルド",
      imagePath: "images/mac.jpg",
      description: "らんらんるー",
    ),
    Shop(
      id: "id003",
      shopLocation: LatLng(37.435, -122.088),
      shopName: "珈琲屋",
      imagePath: "images/coffee.jpg",
      description: "素敵な珈琲屋さん",
    ),
    Shop(
      id: "id004",
      shopLocation: LatLng(37.436, -122.088),
      shopName: "マクドナルド",
      imagePath: "images/mac.jpg",
      description: "らんらんるー",
    ),
    Shop(
      id: "id005",
      shopLocation: LatLng(37.437, -122.088),
      shopName: "珈琲屋",
      imagePath: "images/coffee.jpg",
      description: "素敵な珈琲屋さん",
    ),
    Shop(
      id: "id006",
      shopLocation: LatLng(37.438, -122.088),
      shopName: "マクドナルド",
      imagePath: "images/mac.jpg",
      description: "らんらんるー",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    BorderRadiusGeometry radius = BorderRadius.only(
      topLeft: Radius.circular(10.0),
      topRight: Radius.circular(10.0),
    );
    return new Scaffold(
      body: SlidingUpPanel(
        minHeight: 50.0,
        collapsed: Column(
          children: <Widget>[
            SizedBox(
              height: 10.0,
            ),
            Center(
              child: Container(
                width: 30.0,
                height: 4.0,
                decoration: BoxDecoration(
                  color: Colors.grey.shade400,
                  borderRadius: BorderRadius.all(
                    Radius.circular(2.5),
                  ),
                ),
              ),
            ),
            Container(
              decoration:
                  BoxDecoration(color: Colors.white, borderRadius: radius),
              child: Center(
                child: Text(
                  "This is the collapsed Widget",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
        panel: Column(
          children: <Widget>[
            SizedBox(
              height: 10.0,
            ),
            Center(
              child: Container(
                width: 30.0,
                height: 4.0,
                decoration: BoxDecoration(
                  color: Colors.grey.shade400,
                  borderRadius: BorderRadius.all(
                    Radius.circular(2.5),
                  ),
                ),
              ),
            ),
            Flexible(
              child: ListView.builder(
                itemBuilder: (context, index) => Container(
                  height: 150,
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: Colors.grey, width: 0.3),
                    ),
                  ),
                  child: ListTile(
                    leading: Image.asset(_shops[index].imagePath),
                    title: Text(
                      _shops[index].shopName,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      _shops[index].description,
                      style: TextStyle(
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ),
                ),
                itemCount: _shops.length,
              ),
            ),
          ],
        ),
        body: GoogleMap(
          mapType: MapType.normal,
          initialCameraPosition: _kGooglePlex,
          onMapCreated: (GoogleMapController controller) {
            _controller.complete(controller);
          },
          markers: createMarker(),
        ),
        //maxHeight: MediaQuery.of(context).size.height * 3 / 4,
        controller: _panelController,
        borderRadius: radius,
      ),
    );
  }

  Set<Marker> createMarker() {
    List<Marker> markers = [];
    _shops.forEach(
      (s) => markers.add(
        Marker(
          markerId: MarkerId(s.id),
          position: s.shopLocation,
          infoWindow: InfoWindow(
            title: s.shopName,
            snippet: s.description,
          ),
        ),
      ),
    );
    return markers.toSet();
  }

  Future<void> _goToTheLake() async {
    setState(() {
      _isBrowsed = true;
    });
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(_kLake));
  }
}

class Shop {
  String id;
  String shopName;
  LatLng shopLocation;
  String imagePath;
  String description;
  Shop({
    this.id,
    this.shopLocation,
    this.shopName,
    this.imagePath,
    this.description,
  });
}

Widget _scrollingList(ScrollController sc) {
  return ListView.builder(
    controller: sc,
    itemCount: 50,
    itemBuilder: (BuildContext context, int i) {
      return Center(
        child: Container(
          padding: const EdgeInsets.all(12.0),
          child: Text("$i"),
        ),
      );
    },
  );
}
