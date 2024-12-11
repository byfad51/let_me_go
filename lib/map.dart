import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.function});
  final Function function;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int? tappedPosition1;
  int? tappedPosition2;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('LET ME GO'), centerTitle: true,
      ),
      body: Stack(
        children: [
          FlutterMap(
            options: MapOptions(
              center: LatLng(38.722153, 35.48911), // Başlangıç konumu
              zoom: 17.8, // Başlangıç yakınlaştırma seviyesi
              interactiveFlags: InteractiveFlag.none, // Etkileşimleri kapatır
              onTap: (tapPosition, point) {
                int loc = 0;
                if(point.latitude < 38.722 && point.longitude > 35.489){
                  loc=1;//"seyid burhanettin";
                }else if(point.latitude > 38.722 && point.longitude > 35.4894){
                  loc=2;//"sivas bulvarı sağ";
                }else if(point.latitude > 38.722 && point.longitude < 35.4888){
                  loc=3;//"sivas bulvarı sol";
                }else{
                  loc=0;
                }
                if(loc !=0){
                  if(tappedPosition1==loc){
                    tappedPosition1=null;
                  }else if(tappedPosition2==loc){
                    tappedPosition2=null;
                  }else if(tappedPosition1==null){
                    tappedPosition1=loc;
                  }else if(tappedPosition2==null){
                    tappedPosition2=loc;
                  }else{
                    if(tappedPosition1==loc){
                      tappedPosition1==null;
                    }else if(tappedPosition2==loc){
                      tappedPosition2==null;
                    }
                  }
                }
                setState(() {
                  print(point);
                  print("tappedPosition1:");
                  print(tappedPosition1);
                  print("tappedPosition2:");
                  print(tappedPosition2);
                });
              },
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                subdomains: const ['a', 'b', 'c'], // Alt alanlar
                userAgentPackageName: 'com.example.app',
              ),
            ],
          ),
          Positioned(
            top: MediaQuery.of(context).size.height/4,
            left: 20,
            child: Card(
              color: tappedPosition1==3 || tappedPosition2==3? Colors.green: Colors.black,
              child: Container(
                margin: EdgeInsets.all(10),
                child: Text(tappedPosition1==3?"Buradan":tappedPosition2==3?"Buraya":"YOL 3",style: TextStyle(color: Colors.white)),
              ),
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).size.height/4,
            right: 20,
            child: Card(
              color: tappedPosition1==2 || tappedPosition2==2? Colors.green: Colors.black,
              child: Container(
                margin: EdgeInsets.all(10),
                child: Text(tappedPosition1==2?"Buradan":tappedPosition2==2?"Buraya":"YOL 2",style: TextStyle(color: Colors.white),),
              ),
            ),
          ),
          Positioned(
            bottom: MediaQuery.of(context).size.height/8,
            right: 30,
            child: Card(
              color: tappedPosition1==1 || tappedPosition2==1? Colors.green: Colors.black,
              child: Container(
                margin: EdgeInsets.all(10),
                child: Text(tappedPosition1==1?"Buradan":tappedPosition2==1?"Buraya":"YOL 1",style: TextStyle(color: Colors.white)),
              ),
            ),
          ),
          Positioned(
            top: 15,
            right: 50,
            left: 50,
            child:   ElevatedButton(onPressed: (){
              widget.function("0");
            }, child: Text("NORMALE DÖN")),
          ),
          if (tappedPosition1 != null || tappedPosition2 != null)
            Positioned(
              bottom: 20,
              left: 20,
              right: 20, // Ekranın tamamına yayılmasını sağlamak için sağda boşluk ekliyoruz
              child: Card(
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 10), // Sağ ve soldan biraz boşluk bırak
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly, // Yatayda yayılmasını sağlar
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "Nereden",
                            style: const TextStyle(fontSize: 16),
                          ),
                          Text(
                            "Nereye",
                            style: const TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 10), // Sağ ve soldan biraz boşluk bırak
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly, // Yatayda yayılmasını sağlar
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "Yol " + ((tappedPosition1!=null)? tappedPosition1.toString():"Seçiniz"),
                            style: const TextStyle(fontSize: 16),
                          ),
                          Text(
                            "Yol " +( (tappedPosition2!=null)?tappedPosition2.toString():"Seçiniz"),
                            style: const TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                    if (tappedPosition1 != null && tappedPosition2 != null)
                      ElevatedButton(onPressed: (){
                      widget.function(tappedPosition1.toString());
                    }, child: Text("LET ME GO"))
                  ],
                ),
              ),
            )

          ,
        ],
      ),
    );
  }
}
