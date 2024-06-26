import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:facturasya/services/functions/funtions.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SalaService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> getHostId(String codigoSala) async {
    final salaDoc = _firestore.collection('salas').doc(codigoSala);
    final snapshot = await salaDoc.get();

    if (snapshot.exists) {
      return snapshot.data()?['Host'] ?? "";
    } else {
      return "";
    }
  }

  Future<void> removeFromRoom(String codigoSala, String uidUser) async {
    final salaDoc = _firestore.collection('salas').doc(codigoSala);
    final snapshot = await salaDoc.get();

    if (snapshot.exists) {
      List participantes = snapshot.data()!["participantes"];
      participantes
          .removeWhere((participante) => participante["uid"] == uidUser);
      await salaDoc.update({'participantes': participantes});
    }
  }

  Future<void> crearSala(String codigo) async {
    final user = FirebaseAuth.instance.currentUser;
    final uid = user?.uid;

    // Verifica si ya existe una sala con el código
    final salaSnapshot = await _firestore.collection('salas').doc(codigo).get();
    if (salaSnapshot.exists) {
      // Si la sala ya existe, genera un nuevo código
      codigo = await generarCodigoUinco();
    }

    await _firestore.collection('salas').doc(codigo).set({
      'codigo': codigo,
      'Host': user!.uid,
      'participantes': [
        {'uid': uid, 'equipo': 'no tiene'}
        //TODO ELIMINAR TODO ESTO DE ABAJO, ERA SOLO PARA PROBAR
        /*  {'uid': '5ffWn10MXlYODkm4t2r8Xv6dAxv1', 'equipo': 'no tiene'},
        {'uid': 'HOhWjBrHsCPb2l5XHQ5UbGt4Xi42', 'equipo': 'no tiene'},
        {'uid': 'Hnl0rZ3ChKge0bJxh8x5NIMBwZz1', 'equipo': 'no tiene'},
        {'uid': 'L7vpFzEh0WPCYDhxBP6QepK0oRM2', 'equipo': 'no tiene'},
        {'uid': 'TR4yKNhXR1ccMbZlFDL6DNWqHrA2', 'equipo': 'no tiene'},
        {'uid': 'i8YzKie9ggce0XWIyat6rdkvRRf1', 'equipo': 'no tiene'}, */
      ]
    });
  }

  Future<void> actualizarEquipo(
      String codigo, String uid, String equipo) async {
    try {
      DocumentReference salaRef = _firestore.collection('salas').doc(codigo);

      DocumentSnapshot salaSnapshot = await salaRef.get();

      if (salaSnapshot.exists && salaSnapshot.data() != null) {
        Map<String, dynamic>? data =
            salaSnapshot.data() as Map<String, dynamic>?;

        if (data != null &&
            data.containsKey('participantes') &&
            data['participantes'] is List<dynamic>) {
          List<dynamic>? participantes =
              data['participantes'] as List<dynamic>?;

          int index = participantes
                  ?.indexWhere((participante) => participante['uid'] == uid) ??
              -1;
          if (index != -1) {
            participantes![index]['equipo'] = equipo;

            await salaRef.update({'participantes': participantes});
          }
        }
      }
    } catch (e) {
      print('SALA:Error al actualizar el campo "equipo": $e');
    }
  }

  Future<void> unirseASala(
    String codigoSala,
  ) async {
    final user = FirebaseAuth.instance.currentUser;
    final uid = user?.uid;

    if (uid != null) {
      final salaDoc = _firestore.collection('salas').doc(codigoSala);
      await salaDoc.update({
        'participantes': FieldValue.arrayUnion([
          {'uid': uid, 'equipo': 'no tiene'}
        ])
      });
    }
  }

  Future<List<Map<String, dynamic>>> obtenerParticipantesSala(
      String codigoSala) async {
    final salaDoc = _firestore.collection('salas').doc(codigoSala);
    final snapshot = await salaDoc.get();

    if (snapshot.exists) {
      final participantesData = snapshot.data()?['participantes'] ?? [];

      final participantes =
          participantesData.map<Map<String, dynamic>>((participante) {
        return {
          'nombreUsuario': participante['nombreUsuario'],
          'uid': participante['uid']
        };
      }).toList();

      return Future.value(participantes);
    } else {
      return Future.value([]);
    }
  }
}
