import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:universal_html/js.dart' as js;
class MaestroTestUtil{

  List<K>? jsonToList<K>(Map<String, dynamic>? json,
      K Function(Map<String, dynamic> model) fromJson, String key) {

    if(json == null) return [];

    if (json.isEmpty || !json.containsKey(key)) return [];

    return List<K>.from(json[key].map((model) => fromJson(model)));
  }
}

extension WidgetExtension on Widget {
  Widget get toSemanticExplicit => Semantics(
    explicitChildNodes: true,
    child: this,
  );

  Widget toSemantic({required String id,bool? enabled,bool? checked,String? label}){
    return Semantics(
      identifier: id,
      enabled: enabled,
      checked: checked,
      label: label,
      child: Tooltip(
        message: id,
        child: Listener(
          onPointerDown: (event) async{
            // Check if right mouse button clicked
            if (event.kind == PointerDeviceKind.mouse && event.buttons == kSecondaryMouseButton) {

              js.context.callMethod('mouseRightClick', ['text']);



              // print('right mouse click');
              // await Clipboard.setData(const ClipboardData(text: "Text to be copied"));
            }
          },
          child: this,
        ),
      ),
    );
  }
}