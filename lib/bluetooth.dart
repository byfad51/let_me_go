import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:let_me_go/map.dart';
import 'package:permission_handler/permission_handler.dart';

class BleHomePage extends StatefulWidget {
  @override
  _BleHomePageState createState() => _BleHomePageState();
}

class _BleHomePageState extends State<BleHomePage> {
  @override
  void initState() {
    super.initState();
    startScanning();
  }


/*  Future<void> _checkAndRequestPermission() async {
    PermissionStatus status = await Permission.location.status;
    if (status.isDenied) {
      PermissionStatus newStatus = await Permission.location.request();

    }
  }
*/
  Future<void> _checkAndRequestPermission() async {
    // Bluetooth izni kontrol ve talep
    if (Platform.isMacOS) {
      print("MacOS'ta belirli izinler desteklenmiyor.");
      return;
    }
    if (await Permission.bluetooth.status.isDenied) {
      var bluetoothStatus = await Permission.bluetooth.request();
      if (bluetoothStatus.isGranted) {
        print("Bluetooth izni verildi.");
      } else {
        print("Bluetooth izni reddedildi.");
      }
    }

    // Konum izni kontrol ve talep
    if (await Permission.location.status.isDenied) {
      var locationStatus = await Permission.location.request();
      if (locationStatus.isGranted) {
        print("Konum izni verildi.");
      } else {
        print("Konum izni reddedildi.");
      }
    }
  }

  List<BluetoothDevice> devicesList = [];
  BluetoothDevice? connectedDevice;
  BluetoothCharacteristic? targetCharacteristic;

  Future<void> startScanning() async {
    await _checkAndRequestPermission();
    FlutterBluePlus.startScan(); // Statik çağrı
    FlutterBluePlus.scanResults.listen((results) async { // Statik çağrı
      await Future.delayed(Duration(milliseconds: 300));
      for (ScanResult result in results) {
        setState(() {
          if(!devicesList.contains(result.device) && result.device.platformName!="")
          devicesList.add(result.device);
        });
      }
    });
  }

  Future<void> connectToDevice(BluetoothDevice device) async {
    await device.connect();
    setState(() {
      connectedDevice = device;
    });

    List<BluetoothService> services = await device.discoverServices();
    for (var service in services) {
      for (var characteristic in service.characteristics) {
        if (characteristic.properties.write) {
          setState(() {
            targetCharacteristic = characteristic;
          });
        }
      }
    }

  }


  Future<void> sendData(String data) async {
    if (targetCharacteristic != null) {
      await targetCharacteristic!.write(data.codeUnits);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Veri gönderildi: $data")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('BLE Demo')),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: devicesList.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(devicesList[index].platformName.isNotEmpty
                      ? devicesList[index].platformName
                      : 'Bilinmeyen Cihaz'),
                  subtitle: Text(devicesList[index].id.toString()),
                  onTap: () async {
                   await connectToDevice(devicesList[index]);
                    if(connectedDevice!=null){
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => HomePage(function: sendData,)),
                      );
                    }
                  },
                );
              },
            ),
          ),
          if (connectedDevice != null) ...[
            //Text('Bağlı cihaz: ${connectedDevice!.platformName}'),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () => sendData("1"),
                  child: Text('Veri 1'),
                ),
                ElevatedButton(
                  onPressed: () => sendData("2"),
                  child: Text('Veri 2'),
                ),
                ElevatedButton(
                  onPressed: () => sendData("3"),
                  child: Text('Veri 3'),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
