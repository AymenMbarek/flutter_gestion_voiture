import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CarDetailPage extends StatelessWidget {
  final Map<String, dynamic> carData;

  CarDetailPage(this.carData);

String formatTimestamp(dynamic timestamp) {
  if (timestamp is Timestamp) {
    var date = timestamp.toDate();
    var formattedDate = "${date.day}-${date.month}-${date.year}";
    return formattedDate;
  } else if (timestamp is String) {
    // Assuming it's already formatted as a string
    return timestamp;
  } else {
    return "Non disponible";
  }
}



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(carData['modele']),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 200, // Adjust the height as needed
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(carData['imageURL']), // Use the URL from Firestore
                  fit: BoxFit.cover,
                ),
              ),
              child: Center(
             
              ),
            ),
            Text('Assurance: ${formatTimestamp(carData['assurance'])}'),
            Text('Couleur: ${carData['couleur']}'),
            Text('Date d\'entrée: ${formatTimestamp(carData['date_entree'])}'),
            Text('Date de sortie: ${formatTimestamp(carData['date_sortie'])}'),
            Text('Date de location: ${formatTimestamp(carData['date_location'])}'),
            Text('Date de retour: ${formatTimestamp(carData['date_retour'])}'),
            Text('État: ${carData['etat']}'),
            Text('Kilométrage initial: ${carData['kilometrage_initial']}'),
            Text('Kilométrage final: ${carData['kilometrage_final']}'),
            Text('Marque: ${carData['marque']}'),
            Text('Modèle: ${carData['modele']}'),
            Text('Visite technique: ${formatTimestamp(carData['visite_technique'])}'),
          ],
        ),
      ),
    );
  }
}
