import 'package:facturasya/services/functions/funtions.dart';
import 'package:facturasya/services/sala.dart';
import 'package:flutter/material.dart';

class ParticipantesSala extends StatefulWidget {
  final String codigoSala;

  const ParticipantesSala({Key? key, required this.codigoSala})
      : super(key: key);

  @override
  _ParticipantesSalaState createState() => _ParticipantesSalaState();
}

class _ParticipantesSalaState extends State<ParticipantesSala> {
  List<dynamic> participantes = [];
  List<Map<String, dynamic>> userDataList =
      []; 

  @override
  void initState() {
    super.initState();
    _fetchParticipantes();
  }

  Future<void> _fetchParticipantes() async {
    participantes =
        await SalaService().obtenerParticipantesSala(widget.codigoSala);

    
    final futures = participantes
        .map((participante) => getUserFromFirebase(participante['uid']));
    userDataList = await Future.wait(futures);

    setState(() {}); 
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ver Participantes'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: participantes.length,
              itemBuilder: (context, index) {
                final participante = participantes[index];
                final userData = userDataList[index];
                final nombreUsuario = userData['username'];

                final photoURL = userData['photoURL'];
                print(photoURL);

                return ListTile(
                  leading: Image.network(photoURL),
                  title: Text(nombreUsuario),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
