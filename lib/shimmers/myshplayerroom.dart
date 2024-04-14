import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class MyShPlayerRoom extends StatelessWidget {
  const MyShPlayerRoom({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: 15,
        vertical: 5
      ),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.white,
      ),
      child: Row(
        children: [
          Shimmer.fromColors(
            baseColor: const Color.fromARGB(255, 244, 244, 244),
            highlightColor: const Color.fromARGB(255, 230, 230, 230),
            child:const CircleAvatar(
              radius: 30,
            )
          ),
          const SizedBox(width: 10,),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Shimmer.fromColors(
                highlightColor: const Color.fromARGB(255, 230, 230, 230),
                baseColor: const Color.fromARGB(255, 244, 244, 244),
                child: Container(
                  height: 20,
                  width: 100,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 10,),
              Shimmer.fromColors(
               highlightColor: const Color.fromARGB(255, 230, 230, 230),
               baseColor: const Color.fromARGB(255, 244, 244, 244),
                child: Container(
                  height: 20,
                  width: 150,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}