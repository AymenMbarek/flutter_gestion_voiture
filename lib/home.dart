import 'package:flutter/material.dart';
import 'car_detail.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:math';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start, // Alignez le contenu à gauche
          children: [
            // Ajoutez le logo ici
            Image.asset(
              'assets/carental_logo.png',
              width: 60, // Ajustez la largeur selon vos besoins
              height: 60, // Ajustez la hauteur selon vos besoins
            ),
            // Ajoutez un espace entre le logo et le texte
            SizedBox(width: 8),
            // Ajoutez le texte ici
            Text(
              'Helmi Rent A Car',
              style: TextStyle(
                fontSize: 18, // Ajustez la taille du texte selon vos besoins
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        toolbarHeight: 80, // Ajustez la hauteur de la barre d'applications selon vos besoins
      ),
      body: CarList(),
    );
  }
}


class CarList extends StatelessWidget {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Color generateRandomColor() {
    Random random = Random();
    return Color.fromARGB(
      255,
      random.nextInt(256),
      random.nextInt(256),
      random.nextInt(256),
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore
          .collection('voitures')
          .orderBy('date_entree', descending: true)
          .limit(10)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return CircularProgressIndicator();
        }

        var cars = snapshot.data!.docs;
        return GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: MediaQuery.of(context).size.width > 600 ? 4 : 2,
            crossAxisSpacing: 8.0,
            mainAxisSpacing: 8.0,
          ),
          itemCount: cars.length,
          itemBuilder: (context, index) {
            var carData = cars[index].data() as Map<String, dynamic>;
            var carID = cars[index].id;

            var randomColor = generateRandomColor();

            return Card(
              color: randomColor,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ListTile(
                    title: Text(
                      carData['modele'],
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CarDetailPage(carData),
                        ),
                      );
                    },
                  ),
                  ButtonBar(
                    alignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  ModifyCarPage(carData, carID, _firestore),
                            ),
                          );
                        },
                        child: Text('Modifier'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          _firestore.collection('voitures').doc(carID).delete();
                        },
                        child: Text('Supprimer'),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

class ModifyCarPage extends StatefulWidget {
  final Map<String, dynamic> carData;
  final String carID;
  final FirebaseFirestore firestore;

  ModifyCarPage(this.carData, this.carID, this.firestore);

  @override
  _ModifyCarPageState createState() => _ModifyCarPageState();
}

class _ModifyCarPageState extends State<ModifyCarPage> {
  late TextEditingController modeleController;
  late TextEditingController couleurController;
  late TextEditingController assuranceController;
  late TextEditingController kilometrageInitialController;
  late TextEditingController kilometrageFinalController;
  late TextEditingController marqueController;
  late TextEditingController etatController;
  late TextEditingController imageURLController;
  late TextEditingController dateEntreeController;
  late TextEditingController dateLocationController;
  late TextEditingController dateRetourController;
  late TextEditingController dateSortieController;
  late TextEditingController visiteTechniqueController;

  @override
  void initState() {
    super.initState();
    modeleController = TextEditingController(text: widget.carData['modele']);
    couleurController = TextEditingController(text: widget.carData['couleur']);
   
    
        assuranceController = TextEditingController(
        text: widget.carData['assurance'].toDate().toString());

    kilometrageInitialController =
        TextEditingController(text: widget.carData['kilometrage_initial'].toString());
    kilometrageFinalController =
        TextEditingController(text: widget.carData['kilometrage_final'].toString());
    marqueController = TextEditingController(text: widget.carData['marque']);
    etatController = TextEditingController(text: widget.carData['etat']);
    imageURLController = TextEditingController(text: widget.carData['imageURL']);
    dateEntreeController = TextEditingController(
        text: widget.carData['date_entree'].toDate().toString());
    dateLocationController = TextEditingController(
        text: widget.carData['date_location'].toDate().toString());
    dateRetourController = TextEditingController(
        text: widget.carData['date_retour'].toDate().toString());
    dateSortieController = TextEditingController(
        text: widget.carData['date_sortie'].toDate().toString());
    visiteTechniqueController = TextEditingController(
        text: widget.carData['visite_technique'].toDate().toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Modifier la Voiture'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: modeleController,
                decoration: InputDecoration(labelText: 'Modèle de voiture'),
              ),
              TextField(
                controller: couleurController,
                decoration: InputDecoration(labelText: 'Couleur de voiture'),
              ),
              TextField(
                controller: assuranceController,
                decoration: InputDecoration(labelText: 'Assurance'),
              ),
              TextField(
                controller: kilometrageInitialController,
                decoration: InputDecoration(labelText: 'Kilométrage initial'),
              ),
              TextField(
                controller: kilometrageFinalController,
                decoration: InputDecoration(labelText: 'Kilométrage final'),
              ),
              TextField(
                controller: marqueController,
                decoration: InputDecoration(labelText: 'Marque'),
              ),
              TextField(
                controller: etatController,
                decoration: InputDecoration(labelText: 'État'),
              ),
              TextField(
                controller: imageURLController,
                decoration: InputDecoration(labelText: 'URL de l\'image'),
              ),
              TextField(
                controller: dateEntreeController,
                decoration: InputDecoration(labelText: 'Date d\'entrée'),
              ),
              TextField(
                controller: dateLocationController,
                decoration: InputDecoration(labelText: 'Date de location'),
              ),
              TextField(
                controller: dateRetourController,
                decoration: InputDecoration(labelText: 'Date de retour'),
              ),
              TextField(
                controller: dateSortieController,
                decoration: InputDecoration(labelText: 'Date de sortie'),
              ),
              TextField(
                controller: visiteTechniqueController,
                decoration: InputDecoration(labelText: 'Date de visite technique'),
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () async {
                  await updateCarData();
                },
                child: Text('Enregistrer'),
              ),
              ElevatedButton(
                onPressed: () async {
                  await createCar();
                },
                child: Text('Créer Voiture'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> updateCarData() async {
    try {
      Timestamp dateEntreeTimestamp =
          Timestamp.fromDate(DateTime.parse(dateEntreeController.text));
      Timestamp dateLocationTimestamp = Timestamp.fromDate(
          DateTime.parse(dateLocationController.text));
      Timestamp dateRetourTimestamp =
          Timestamp.fromDate(DateTime.parse(dateRetourController.text));
      Timestamp dateSortieTimestamp =
          Timestamp.fromDate(DateTime.parse(dateSortieController.text));
      Timestamp visiteTechniqueTimestamp =
          Timestamp.fromDate(DateTime.parse(visiteTechniqueController.text));

      Map<String, dynamic> updatedCarData = {
        'modele': modeleController.text,
        'couleur': couleurController.text,
        'assurance': assuranceController.text,
        'kilometrage_initial': int.parse(kilometrageInitialController.text),
        'kilometrage_final': int.parse(kilometrageFinalController.text),
        'marque': marqueController.text,
        'etat': etatController.text,
        'imageURL': imageURLController.text,
        'date_entree': dateEntreeTimestamp,
        'date_location': dateLocationTimestamp,
        'date_retour': dateRetourTimestamp,
        'date_sortie': dateSortieTimestamp,
        'visite_technique': visiteTechniqueTimestamp,
      };

      await widget.firestore
          .collection('voitures')
          .doc(widget.carID)
          .update(updatedCarData);

      Navigator.pop(context);
    } catch (e) {
      print("Error updating car data: $e");
    }
  }

  Future<void> createCar() async {
    try {
      Map<String, dynamic> newCarData = {
        'modele': modeleController.text,
        'couleur': couleurController.text,
        
         'assurance':
            Timestamp.fromDate(DateTime.parse(assuranceController.text)),
        'kilometrage_initial': int.parse(kilometrageInitialController.text),
        'kilometrage_final': int.parse(kilometrageFinalController.text),
        'marque': marqueController.text,
        'etat': etatController.text,
        'imageURL': imageURLController.text,
        'date_entree':
            Timestamp.fromDate(DateTime.parse(dateEntreeController.text)),
        'date_location':
            Timestamp.fromDate(DateTime.parse(dateLocationController.text)),
        'date_retour':
            Timestamp.fromDate(DateTime.parse(dateRetourController.text)),
        'date_sortie':
            Timestamp.fromDate(DateTime.parse(dateSortieController.text)),
        'visite_technique':
            Timestamp.fromDate(DateTime.parse(visiteTechniqueController.text)),
      };

      await widget.firestore.collection('voitures').add(newCarData);

      Navigator.pop(context);
    } catch (e) {
      print("Error creating car data: $e");
    }
  }
}
