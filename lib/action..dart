import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:ffi';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:nfc_manager/nfc_manager.dart';

const String CMD_ACTIVE = "0";
const String CMD_DEACTIVE = "4";
const String CMD_RESET = "2";

ValueNotifier<dynamic> result = ValueNotifier(null);

class Activation extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => ActivationState();
}

class ActivationState extends State<Activation> {

  bool isActive = false;
  bool isReady = false;
  bool isDeactivating = false;
  bool isActivating = false;
  bool isWriting = false;

  Color bgColor = Colors.white;

  @override
  Widget build(BuildContext context) {
    return
      Scaffold(
            appBar: AppBar(title: Text('Alesea TAG handler')),
            body: SafeArea(
            child:FutureBuilder<bool>(
        future: NfcManager.instance.isAvailable(),
        builder: (context, ss) =>
        ss.data != true
            ? Center(child: Text('NfcManager.isAvailable(): ${ss.data}'))
            : Flex(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          direction: Axis.vertical,
          children: [
/*Flexible(
                  flex: 2,
                  child: Container(
                    margin: EdgeInsets.all(4),
                    constraints: BoxConstraints.expand(),
                    decoration: BoxDecoration(border: Border.all()),
                    child: SingleChildScrollView(
                      child: ValueListenableBuilder<dynamic>(
                        valueListenable: result,
                        builder: (context, value, _) =>
                            Text('${value ?? ''}'),
                      ),
                    ),
                  ),
                ),*/
            Flexible(
              flex: 3,
              child: GridView.count(
                padding: EdgeInsets.all(4),
                crossAxisCount: 3,
                childAspectRatio: 1.5,
                crossAxisSpacing: 4,
                mainAxisSpacing: 4,
                children: [
                  Container(),
                  ElevatedButton(
                      child: listening
                          ? Text("listening")
                          : Text(' Start reading '),
                      onPressed: listening ? null : _tagRead),
                  Container(),

                  ElevatedButton(
                      child: Text('Active'),
                      onPressed: (isWriting) || (isActive)
                          ? null : () => _ndefWrite(CMD_ACTIVE)
                  ),
                  ElevatedButton(
                      child: Text('Reset'),
                      onPressed: (isWriting)
                          ? null : () => _ndefWrite(CMD_RESET)
                  ),
                  ElevatedButton(
                      child: Text('Deactive'),
                      onPressed: (isWriting) || (isReady)
                          ? null : () => _ndefWrite(CMD_DEACTIVE)
                  ),
                  Text("ICCI: "),
                  Text("PIN: "),
                  Text("vals:"),
                  Text(icci),
                  Text(pin),
                  Text(vals),
                  Container(),
                  Text("Status: "),
                  Text("Command:"),
                  Container(),
                  Text(status),
                  Text(command),
                  Container(),
                  ValueListenableBuilder<dynamic>(
                    valueListenable: result,
                    builder: (context, value, _) =>
                        Text('${value ?? ''}'),
                  ),
                  Container(),
                ],
              ),
            ),
          ],
        ),
              )
              )
    );
  }

  String opRes = "";
  bool listening = false;

  void _tagRead() {
    setState(() {
      listening = true;
    });
    NfcManager.instance.startSession(onDiscovered: (NfcTag tag) async {
      result.value = tag.data;

      Map tagData = tag.data;
      Map tagNdef = tagData['ndef'];
      Map cachedMessage = tagNdef['cachedMessage'];
      Map records = cachedMessage['records'][0];
      Uint8List payload = records['payload'];
      String payloadAsString = String.fromCharCodes(payload);
// or with the dart:convert library String payloadAsString = utf8.decode(payload)
      setState(() {
        icci = utf8.decode(cachedMessage['records'][0]['payload']).substring(3);
        pin = getPin(icci);
        status =
            utf8.decode(cachedMessage['records'][1]['payload']).substring(3);
        vals = utf8.decode(cachedMessage['records'][2]['payload']).substring(3);
        command =
            utf8.decode(cachedMessage['records'][3]['payload']).substring(3);
      });

      NfcManager.instance.stopSession();
      log("session stopped: " + icci + " " + pin + " " + status + " " + vals);
      setState(() {
        isReady = (status.compareTo("READY") == 0);
        isActive = (status.compareTo("ACTIVE") == 0);
        isActivating = (command.compareTo("0") == 0);
        isDeactivating = (command.compareTo("4") == 0);
        bgColor = (isReady ? Colors.grey : bgColor);
        bgColor = (isActive ? Colors.green : bgColor);
        bgColor = (isActivating ? Colors.yellowAccent : bgColor);
        bgColor = (isDeactivating ? Colors.blueGrey : bgColor);

        listening = false;
      });
    });
  }

  Timer? _timer;

  String getPin(String nfc_iccid) {
    String r = "";
    if (nfc_iccid.length < 20) {
      return r;
    }
    String p1 = nfc_iccid.substring(0, 1);
    String p2 = nfc_iccid.substring(3, 4);
    String p3 = nfc_iccid.substring(7, 8);
    String p4 = nfc_iccid.substring(11, 12);
    String p5 = nfc_iccid.substring(15, 16);
    String p6 = nfc_iccid.substring(19, 20);
    return p1 + p2 + p3 + p4 + p5 + p6;
  }

  String icci = "";
  String pin = "";
  String status = "";
  String vals = "";
  String command = "";

  void _ndefWrite(String cmd) {
    setState(() {
      isWriting = true;
    });
    NfcManager.instance.startSession(onDiscovered: (NfcTag tag) async {
      var ndef = Ndef.from(tag);
      if (ndef == null || !ndef.isWritable) {
        result.value = 'Tag is not ndef writable';
        NfcManager.instance.stopSession(errorMessage: result.value);
        setState(() {
          isWriting = false;
        });
        return;
      }

      NdefMessage message = NdefMessage([
        NdefRecord.createText(""),
        NdefRecord.createText(pin),
        NdefRecord.createText(""),
        NdefRecord.createText(cmd),
      ]);

      try {
        await ndef.write(message);

        result.value = 'Success to "Ndef Write"';
        NfcManager.instance.stopSession(alertMessage: result.value.toString());
      } catch (e) {
        result.value = e;
        NfcManager.instance.stopSession(errorMessage: result.value.toString());
        setState(() {
          isWriting = false;
        });
        return;
      }

      _timer = new Timer(const Duration(milliseconds: 3000), () {
        _tagRead();
      });
      setState(() {
        isWriting = false;
      });
    }).whenComplete(() {
      log("ocmpleted");
    });
  }

  void _ndefWriteLock() {
    NfcManager.instance.startSession(onDiscovered: (NfcTag tag) async {
      var ndef = Ndef.from(tag);
      if (ndef == null) {
        result.value = 'Tag is not ndef';
        NfcManager.instance.stopSession(errorMessage: result.value.toString());
        return;
      }

      try {
        await ndef.writeLock();
        result.value = 'Success to "Ndef Write Lock"';
        NfcManager.instance.stopSession();
      } catch (e) {
        result.value = e;
        NfcManager.instance.stopSession(errorMessage: result.value.toString());
        return;
      }
    });
  }
}