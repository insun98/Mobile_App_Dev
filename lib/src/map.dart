import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import '../Provider/PostProvider.dart';

class MyMap extends StatefulWidget {
  const MyMap({Key? key}) : super(key: key);

  @override
  _MyMapState createState() => _MyMapState();
}

class _MyMapState extends State<MyMap> {
  late GoogleMapController mapController;
  List<Post> marker = [];
  final LatLng _center = const LatLng(37.421998333333335, -122.084);

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    PostProvider postProvider = Provider.of<PostProvider>(context);
    marker = postProvider.allPosts;
    return  Mark(
        marker: marker);
  }
}

class Mark extends StatefulWidget {
  const Mark({required this.marker});
  final List<Post> marker;
  @override
  _MarkState createState() => _MarkState();
}

class _MarkState extends State<Mark> {
  List<Marker> _markers = [];
  late GoogleMapController mapController;
  final LatLng _center = LatLng(36.105456, 129.389287);

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    PostProvider postProvider = Provider.of<PostProvider>(context);
    void _showDialog(BuildContext context, String title, String image, String id){
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text(title),
              content: Image.network(
                image,
              ),
              actions: [
                FlatButton(
                  child: Text('게시물 보기'),
                  onPressed: () async {
                    await postProvider.getSinglePost(id);
                    Navigator.pushNamed(context, '/postDetail');
                  },
                ),
                FlatButton(
                  child: Text('아니오'),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            );
          }
      );
    }

    for(var pst in widget.marker) {
      double lat = pst.lat;
      double lng = pst.lng;
      String id = pst.docId;
      String title = pst.title;
      String image = pst.image;
      _markers.add(
          Marker(
              markerId: MarkerId("${id}"),
              draggable: true,
              onTap: () => _showDialog(context, title, image, id),
              position: LatLng(lat, lng))
      );
      print(_markers);
    }

    return Container(
      child: GoogleMap(
        mapType: MapType.normal,
        markers: Set.from(_markers),
        initialCameraPosition: CameraPosition(
          zoom: 14.0,
          target: _center,
        ),

        onCameraMove: (_) {},
        myLocationButtonEnabled: true,
        myLocationEnabled: true,
      ),
    );
  }
}


