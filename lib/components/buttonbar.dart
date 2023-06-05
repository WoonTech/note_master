import 'package:flutter/material.dart';
import 'package:note_master/models/layout.dart';

import '../models/styling.dart';

class ButtonBarFieldWidget extends StatelessWidget {
  const ButtonBarFieldWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return ButtonBar(  
      alignment: MainAxisAlignment.spaceEvenly,
      mainAxisSize: MainAxisSize.max,
      layoutBehavior: ButtonBarLayoutBehavior.constrained,
      children: <Widget>[
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(
            'CANCEL',
            style: TextStyle(
              fontFamily: Font_Family_LATO,
              fontSize: Font_Size_DIALOG,
              color: Theme_Color_SYSTEM,
            ),
          ),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(
            'DONE',
            style: TextStyle(
              fontFamily: Font_Family_LATO,
              fontSize: Font_Size_DIALOG,
              color: Theme_Color_SYSTEM,
            ),
          ),
        ),         
      ],
    );
  }
}
