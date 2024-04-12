import 'package:flutter/material.dart';

void myWdgDialogLoading({required BuildContext context}) {
  showDialog(
    context: context,
    useSafeArea: false,
    useRootNavigator: false,
    barrierColor: Colors.blue.withAlpha(40),
    barrierDismissible: false, // Impide que se pueda cerrar tocando fuera del diálogo
    builder: (BuildContext context) {
      return Dialog.fullscreen(
        backgroundColor: const Color.fromARGB(255, 54, 114, 244),
        child:SizedBox.expand(
          child: Stack(
            children: [
              SizedBox.expand(
                child: Opacity(
                  opacity: 0.2,
                  child: Image.asset(
                    "assets/images/background.png",
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Center(
                child: Image.asset(
                  "assets/gifs/loading.gif",
                  width: 150,
                )
              ),
            ],
          ),
        ) 
      )
      ;
    },
  );
  
}