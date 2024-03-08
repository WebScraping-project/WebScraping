import 'package:flutter/material.dart';
import 'liste_attractions.dart';
import 'attraction.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late List<Attraction> attractions;
  List<Attraction> filteredAttractions = [];
  String selectedView = 'Toutes les attractions';

  @override
  void initState() {
    super.initState();
    _loadAttractions();
  }

  Future<void> _loadAttractions() async {
    attractions = await parseAttractions();
    filteredAttractions = List.from(attractions);
    setState(() {});
  }

  void _onViewChanged(String? view) {
    setState(() {
      selectedView = view ?? 'Toutes les attractions';
      if (view == 'Toutes les attractions') {
        filteredAttractions = List.from(attractions);
      } else {
        filteredAttractions =
            attractions.where((attraction) => attraction.secteur == view).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: ShaderMask(
          shaderCallback: (Rect bounds) {
            return const LinearGradient(
              colors: [Colors.blue, Colors.green],
            ).createShader(bounds);
          },
          child: const Text(
            'Disneyline Tracker',
            style: TextStyle(
              fontSize: 50.0,
              fontWeight: FontWeight.bold,
              color: Colors.white, // Couleur du texte
            ),
          ),
        ),
      ),
      body: Center(
        child: attractions == null
            ? CircularProgressIndicator()
            : Container(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20.0),
                        gradient: const LinearGradient(
                          colors: [Colors.blue, Colors.green],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ),
                      ),
                      child: DropdownButton<String>(
                        value: selectedView,
                        onChanged: _onViewChanged,
                        isExpanded: true,
                        elevation: 5,
                        items: [
                          'Toutes les attractions',
                          'Main Street',
                          'Frontierland',
                          'Adventureland',
                          'Fantasyland',
                          'Discoveryland',
                          'Disneyland Studio',
                        ].map((String view) {
                          return DropdownMenuItem<String>(
                            value: view,
                            child: Center(
                              child: Text(
                                view,
                                style: const TextStyle(
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                        // Utilisez icon pour appliquer un style personnalisé
                        underline: Container(), // Ajoutez cette ligne pour éviter l'erreur
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    Expanded(
                      child: ListView.builder(
                        itemCount: filteredAttractions.length,
                        itemBuilder: (context, index) {
                          var attraction = filteredAttractions[index];
                          return Container(
                            margin: const EdgeInsets.only(bottom: 16.0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20.0),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color.fromARGB(255, 158, 158, 158).withOpacity(0.2),
                                  spreadRadius: 0.1,
                                  blurRadius: 0,
                                  offset: const Offset(0, 0),
                                ),
                              ],
                            ),
                            child: ListTile(
                              leading: ClipRRect(
                                borderRadius: BorderRadius.circular(10.0),
                                child: Image.asset(
                                  attraction.photoUrl,
                                  width: 56,
                                  height: 56,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              title: Text(attraction.name),
                              subtitle: Text(
                                'Temps d\'attente: ${attraction.waitTime} minutes',
                              ),
                              trailing: Icon(
                                attraction.isAvailable ? Icons.check_circle : Icons.cancel,
                                color: attraction.isAvailable ? Colors.green : Colors.red,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
