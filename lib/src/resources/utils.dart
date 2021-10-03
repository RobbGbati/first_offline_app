import 'package:flutter/material.dart';

import 'database_helper.dart';

class Utils {
  static final dbHelper = new DatabaseHelper();

  Widget buildAlert(String msg) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0)
      ),
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Row(
          children: [
            Icon(Icons.error_outlined, size: 50,),
            SizedBox(width: 5,),
            Expanded(child: Container(
              child: Text('$msg'),
              width: 250,
            ))
          ],
        ),
      ),
    );
  }
}
