import 'package:facturasya/widgets/mywdgbutton.dart';
import 'package:flutter/material.dart';

void myWdgDialogConfirm({
  required BuildContext context,
  required String title,
  required String content,
  required VoidCallback onConfirmPressed,
}) {
  showDialog(
    barrierColor: const Color.fromARGB(110, 0, 0, 0),
    context: context,
    barrierDismissible: false, // Impide que se pueda cerrar tocando fuera del diálogo
    builder: (BuildContext context) {
      return AlertDialog(
        surfaceTintColor: Colors.transparent,
        backgroundColor: Colors.white,
        title: Text(
          title,
          textScaler: const TextScaler.linear(01.1),
          style: const TextStyle(
            color: Color.fromARGB(255, 35, 35, 35),
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(
          content,
          textScaler: const TextScaler.linear(1.1),
          style: const TextStyle(
            fontWeight: FontWeight.normal,
            color: Color.fromARGB(255, 35, 35, 35),
          ),
        ),
        actions: [
          
          MyWdgButton(
            text: "Aceptar",
            color: Colors.blue,
            onPressed: () {
              onConfirmPressed();
              //Navigator.of(context).pop();
            },
          ),
          const SizedBox(height: 15,),
          MyWdgButton(
            text: "Cancelar",
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          
        ],
      );
    },
  );
  
}