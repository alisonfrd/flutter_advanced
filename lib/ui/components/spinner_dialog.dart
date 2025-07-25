import 'package:flutter/material.dart';

void showLoading(BuildContext context) {
  showDialog(
      context: context,
      builder: (_) {
        return const SimpleDialog(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
                SizedBox(
                  height: 16,
                ),
                Text(
                  "Aguarde...",
                  textAlign: TextAlign.center,
                )
              ],
            )
          ],
        );
      },
      barrierDismissible: false);
}

void hideLoading(BuildContext context) {
  if (Navigator.canPop(context)) {
    Navigator.of(context).pop();
  }
}
