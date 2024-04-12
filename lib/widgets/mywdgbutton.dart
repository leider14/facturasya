import 'package:bounce/bounce.dart';
import 'package:flutter/material.dart';

class MyWdgButton extends StatefulWidget {
  final String text;
  final VoidCallback? onPressed;
  final Color? color;
  const MyWdgButton({super.key, required this.text, this.onPressed, this.color});

  @override
  State<MyWdgButton> createState() => _MyWdgButtonState();
}

class _MyWdgButtonState extends State<MyWdgButton> {
  @override
  Widget build(BuildContext context) {

    return Bounce(
      child: GestureDetector(
        onTap: () {
          if(widget.onPressed != null){
            widget.onPressed!();
          }
          
        },
        child: Row(
          children: [
            Expanded(
              child: Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: 30
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: widget.color ?? const Color.fromARGB(255, 78, 78, 78),
                    boxShadow: [
                      BoxShadow(
                        blurStyle: BlurStyle.outer,
                        color:widget.color != null ? widget.color!.withAlpha(90) : const Color.fromARGB(255, 52, 52, 52),
                        offset:const Offset(0, 5)
                      )
                    ]
                  ),
                  child: Center(
                    child: Text(
                      widget.text,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
    
  }
}