import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart' show rootBundle;
import 'package:path_provider/path_provider.dart';
import 'package:csv/csv.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:math' show min;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Directorio Telefónico',
      locale: const Locale('es', 'ES'),
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('es', 'ES'),
      ],
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const DirectorioTelefonico(),
    );
  }
}

class DirectorioTelefonico extends StatefulWidget {
  const DirectorioTelefonico({Key? key}) : super(key: key);

  @override
  _DirectorioTelefonicoState createState() => _DirectorioTelefonicoState();
}

class _DirectorioTelefonicoState extends State<DirectorioTelefonico> {
  List<List<dynamic>> _datosCSV = [];
  List<List<dynamic>> _datosFiltrados = [];
  List<List<dynamic>> _datosMostrados = []; // Nueva lista para carga progresiva
  static const String NOMBRE_ARCHIVO = "MATERNO-2025.csv";
  bool _cargando = true;
  bool _cargandoMas = false; // Indicador de carga de más registros
  int _registrosPorCarga = 10; // Número de registros a cargar cada vez
  ScrollController _scrollController = ScrollController(); // Controlador para detectar scroll

  @override
  void initState() {
    super.initState();
    _cargarDatosCSV();
    
    // Añadir listener al controlador de scroll
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  // Método para detectar cuando el usuario llega al final de la lista
  void _scrollListener() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200 &&
        !_cargandoMas &&
        _datosMostrados.length < _datosFiltrados.length) {
      _cargarMasRegistros();
    }
  }

  // Método para cargar más registros
  void _cargarMasRegistros() {
    if (_cargandoMas) return;
    
    setState(() {
      _cargandoMas = true;
    });
    
    // Simular una pequeña demora para mostrar el indicador de carga
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) {
        setState(() {
          int registrosRestantes = _datosFiltrados.length - _datosMostrados.length;
          int registrosACargar = registrosRestantes > _registrosPorCarga ? _registrosPorCarga : registrosRestantes;
          
          _datosMostrados.addAll(
            _datosFiltrados.getRange(
              _datosMostrados.length, 
              _datosMostrados.length + registrosACargar
            )
          );
          
          _cargandoMas = false;
        });
      }
    });
  }

  Future<void> _cargarDatosCSV() async {
    try {
      // Datos de prueba para la versión web
      List<List<dynamic>> datosPrueba = [
        ["MATERNO", "EDIFICIO PRINCIPAL", "PLANTA 1", "ADMISIÓN", "5001", "922123456"],
        ["MATERNO", "EDIFICIO PRINCIPAL", "PLANTA 1", "URGENCIAS", "5002", "922123457"],
        ["MATERNO", "EDIFICIO PRINCIPAL", "PLANTA 2", "CONSULTAS EXTERNAS", "5003", "922123458"],
        ["MATERNO", "EDIFICIO PRINCIPAL", "PLANTA 2", "PEDIATRÍA", "5004", "922123459"],
        ["MATERNO", "EDIFICIO PRINCIPAL", "PLANTA 3", "GINECOLOGÍA", "5005", "922123460"],
        ["MATERNO", "EDIFICIO PRINCIPAL", "PLANTA 3", "OBSTETRICIA", "5006", "922123461"],
        ["MATERNO", "EDIFICIO PRINCIPAL", "PLANTA 4", "NEONATOLOGÍA", "5007", "922123462"],
        ["MATERNO", "EDIFICIO PRINCIPAL", "PLANTA 4", "UCI NEONATAL", "5008", "922123463"],
        ["MATERNO", "EDIFICIO ANEXO", "PLANTA BAJA", "CAFETERÍA", "5009", "922123464"],
        ["MATERNO", "EDIFICIO ANEXO", "PLANTA BAJA", "FARMACIA", "5010", "922123465"],
        ["MATERNO", "EDIFICIO ANEXO", "PLANTA 1", "ADMINISTRACIÓN", "5011", "922123466"],
        ["MATERNO", "EDIFICIO ANEXO", "PLANTA 1", "RECURSOS HUMANOS", "5012", "922123467"],
        ["MATERNO", "EDIFICIO ANEXO", "PLANTA 2", "LABORATORIO", "5013", "922123468"],
        ["MATERNO", "EDIFICIO ANEXO", "PLANTA 2", "RADIOLOGÍA", "5014", "922123469"],
        ["MATERNO", "EDIFICIO ANEXO", "PLANTA 3", "QUIRÓFANOS", "5015", "922123470"],
      ];
      
      String data;
      List<List<dynamic>> listaCSV = [];
      
      // Manejo específico para web
      if (kIsWeb) {
        print("Ejecutando en entorno web - usando datos de prueba");
        
        // Usar datos de prueba para la versión web
        listaCSV = datosPrueba;
        
        // Intentar cargar el CSV real solo como respaldo
        try {
          // En web, usamos una ruta relativa a la carpeta assets en la build
          final response = await HttpClient().getUrl(Uri.parse('/assets/MATERNO-2025.csv'));
          final httpResponse = await response.close();
          data = await httpResponse.transform(utf8.decoder).join();
          
          // Si llegamos aquí, intentamos convertir el CSV real
          try {
            List<List<dynamic>> datosReales = const CsvToListConverter().convert(data);
            if (datosReales.isNotEmpty) {
              print("CSV real cargado correctamente con ${datosReales.length} registros");
              listaCSV = datosReales; // Usar datos reales si se pudieron cargar
            }
          } catch (csvError) {
            print('Error al convertir CSV real: $csvError - usando datos de prueba');
          }
        } catch (webError) {
          print('Error al cargar CSV en web: $webError - usando datos de prueba');
        }
      } else {
        // En dispositivos móviles, usamos rootBundle normalmente
        data = await rootBundle.loadString('assets/MATERNO-2025.csv');
        
        // Convierte el CSV a una lista de listas con manejo de errores mejorado
        try {
          listaCSV = const CsvToListConverter().convert(data);
        } catch (csvError) {
          print('Error al convertir CSV: $csvError');
          // Intenta un enfoque alternativo para archivos grandes
          listaCSV = _procesarCSVManualmente(data);
        }
      }

      print("Datos cargados: ${listaCSV.length} registros");

      setState(() {
        _datosCSV = listaCSV;
        _datosFiltrados = listaCSV;
        
        // Inicializar la lista de datos mostrados con los primeros registros
        _datosMostrados = _datosFiltrados.length > _registrosPorCarga 
            ? _datosFiltrados.sublist(0, _registrosPorCarga) 
            : List.from(_datosFiltrados);
            
        _cargando = false;
      });

    } catch (e) {
      print('🔥 Error al cargar CSV: $e');
      setState(() {
        _cargando = false;
      });

      // Mostrar un mensaje de error al usuario
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al cargar los datos: $e')),
        );
      }
    }
  }

  // Método auxiliar para procesar CSV manualmente en caso de archivos grandes
  List<List<dynamic>> _procesarCSVManualmente(String csvData) {
    List<List<dynamic>> resultado = [];
    
    // Dividir por líneas
    List<String> lineas = csvData.split('\n');
    
    for (String linea in lineas) {
      if (linea.trim().isEmpty) continue;
      
      // Dividir por comas, manejando valores entre comillas
      List<dynamic> campos = [];
      bool enComillas = false;
      String campoActual = '';
      
      for (int i = 0; i < linea.length; i++) {
        String char = linea[i];
        
        if (char == '"' && (i == 0 || linea[i-1] != '\\')) {
          enComillas = !enComillas;
        } else if (char == ',' && !enComillas) {
          campos.add(campoActual);
          campoActual = '';
        } else {
          campoActual += char;
        }
      }
      
      // Añadir el último campo
      campos.add(campoActual);
      
      if (campos.isNotEmpty) {
        resultado.add(campos);
      }
    }
    
    return resultado;
  }

  // Método para construir botones compactos
  Widget _buildCompactButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        minimumSize: const Size(85, 45),
      ),
      onPressed: onPressed,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 20),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(fontSize: 12),
          ),
        ],
      ),
    );
  }

  // Método para buscar por teléfono
  void _buscarPorTelefono() {
    showDialog(
      context: context,
      builder: (context) {
        String busqueda = '';
        return AlertDialog(
          title: const Text('Buscar por Teléfono'),
          content: TextField(
            keyboardType: TextInputType.phone,
            decoration: const InputDecoration(hintText: 'Ingrese número de teléfono'),
            onChanged: (value) {
              busqueda = value;
            },
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                if (busqueda.isNotEmpty) {
                  _filtrarPorTelefono(busqueda);
                }
                Navigator.pop(context);
              },
              child: const Text('Buscar'),
            ),
          ],
        );
      },
    );
  }

  // Método para filtrar por teléfono
  void _filtrarPorTelefono(String busqueda) {
    setState(() {
      _datosFiltrados = _datosCSV.where((registro) {
        return registro.length > 5 &&
            (registro[4].toString().contains(busqueda) ||
                registro[5].toString().contains(busqueda));
      }).toList();
      
      // Reiniciar la lista de datos mostrados
      _datosMostrados = _datosFiltrados.length > _registrosPorCarga 
          ? _datosFiltrados.sublist(0, _registrosPorCarga) 
          : List.from(_datosFiltrados);
    });

    if (_datosFiltrados.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No se encontraron coincidencias')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Se encontraron ${_datosFiltrados.length} resultados')),
      );
    }
  }

  // Método para buscar por servicio
  void _buscarPorServicio() {
    showDialog(
      context: context,
      builder: (context) {
        String busqueda = '';
        return AlertDialog(
          title: const Text('Buscar por Servicio o Edificio'),
          content: TextField(
            decoration: const InputDecoration(hintText: 'Ingrese nombre del servicio o edificio'),
            onChanged: (value) {
              busqueda = value;
            },
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                if (busqueda.isNotEmpty) {
                  _filtrarPorServicio(busqueda.toLowerCase());
                }
                Navigator.pop(context);
              },
              child: const Text('Buscar'),
            ),
          ],
        );
      },
    );
  }

  // Método para filtrar por servicio
  void _filtrarPorServicio(String busqueda) {
    setState(() {
      _datosFiltrados = _datosCSV.where((registro) {
        return registro.length > 3 &&
            (registro[3].toString().toLowerCase().contains(busqueda) ||
                registro[1].toString().toLowerCase().contains(busqueda));
      }).toList();
      
      // Reiniciar la lista de datos mostrados
      _datosMostrados = _datosFiltrados.length > _registrosPorCarga 
          ? _datosFiltrados.sublist(0, _registrosPorCarga) 
          : List.from(_datosFiltrados);
    });

    if (_datosFiltrados.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No se encontraron coincidencias')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Se encontraron ${_datosFiltrados.length} resultados')),
      );
    }
  }

  // Método para añadir un nuevo registro
  void _anadirRegistro() {
    // Controladores para los campos de texto
    final TextEditingController centroController = TextEditingController();
    final TextEditingController edificioController = TextEditingController();
    final TextEditingController plantaController = TextEditingController();
    final TextEditingController servicioController = TextEditingController();
    final TextEditingController telefonoInternoController = TextEditingController();
    final TextEditingController telefonoPublicoController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Nuevo Registro'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: centroController,
                  decoration: const InputDecoration(labelText: 'Centro'),
                ),
                TextField(
                  controller: edificioController,
                  decoration: const InputDecoration(labelText: 'Edificio'),
                ),
                TextField(
                  controller: plantaController,
                  decoration: const InputDecoration(labelText: 'Planta'),
                ),
                TextField(
                  controller: servicioController,
                  decoration: const InputDecoration(labelText: 'Servicio/Local'),
                ),
                TextField(
                  controller: telefonoInternoController,
                  decoration: const InputDecoration(labelText: 'Teléfono Interno'),
                  keyboardType: TextInputType.phone,
                ),
                TextField(
                  controller: telefonoPublicoController,
                  decoration: const InputDecoration(labelText: 'Teléfono Público'),
                  keyboardType: TextInputType.phone,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                // Validar que todos los campos estén completos
                if (centroController.text.isEmpty ||
                    edificioController.text.isEmpty ||
                    plantaController.text.isEmpty ||
                    servicioController.text.isEmpty ||
                    telefonoInternoController.text.isEmpty ||
                    telefonoPublicoController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Todos los campos son obligatorios')),
                  );
                  return;
                }

                // Crear nuevo registro
                List<dynamic> nuevoRegistro = [
                  centroController.text.trim(),
                  edificioController.text.trim(),
                  plantaController.text.trim(),
                  servicioController.text.trim(),
                  telefonoInternoController.text.trim(),
                  telefonoPublicoController.text.trim(),
                ];

                setState(() {
                  _datosCSV.add(nuevoRegistro);
                  _datosFiltrados = List.from(_datosCSV);
                  _datosMostrados = _datosFiltrados.length > _registrosPorCarga 
                      ? _datosFiltrados.sublist(0, _registrosPorCarga) 
                      : List.from(_datosFiltrados);
                });

                _guardarDatosCSV();
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Registro añadido correctamente')),
                );
              },
              child: const Text('Guardar'),
            ),
          ],
        );
      },
    );
  }

  // Método para guardar los datos en el CSV
  Future<void> _guardarDatosCSV() async {
    try {
      // Convertir los datos a formato CSV
      String csv = const ListToCsvConverter().convert(_datosCSV);
      
      if (kIsWeb) {
        // En web no podemos guardar directamente en el sistema de archivos
        print('Guardado en web no implementado');
        return;
      }
      
      // En dispositivos móviles, guardar en el almacenamiento
      final directory = await getApplicationDocumentsDirectory();
      final path = '${directory.path}/$NOMBRE_ARCHIVO';
      final file = File(path);
      await file.writeAsString(csv);
      
      print('Datos guardados en: $path');
    } catch (e) {
      print('Error al guardar CSV: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al guardar los datos: $e')),
        );
      }
    }
  }

  // Método para mostrar todos los registros
  void _mostrarTodos() {
    setState(() {
      _datosFiltrados = List.from(_datosCSV);
      // Reiniciar la lista de datos mostrados
      _datosMostrados = _datosFiltrados.length > _registrosPorCarga 
          ? _datosFiltrados.sublist(0, _registrosPorCarga) 
          : List.from(_datosFiltrados);
    });
  }

  // Método para mostrar el diálogo de editar o eliminar
  void _mostrarDialogoEditarEliminar(int index) {
    final registro = _datosMostrados[index];
    
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Opciones'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Centro: ${registro[0]}'),
              Text('Edificio: ${registro[1]}'),
              Text('Planta: ${registro[2]}'),
              Text('Servicio: ${registro[3]}'),
              Text('Teléfono Interno: ${registro[4]}'),
              Text('Teléfono Público: ${registro[5]}'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _editarRegistro(index);
              },
              child: const Text('Editar'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _eliminarRegistro(index);
              },
              child: const Text('Eliminar'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancelar'),
            ),
          ],
        );
      },
    );
  }

  // Método para editar un registro
  void _editarRegistro(int index) {
    final registroMostrado = _datosMostrados[index];
    // Encontrar el índice real en la lista completa
    final indexEnDatosCompletos = _datosCSV.indexWhere((registro) => 
        registro.length == registroMostrado.length &&
        registro.asMap().entries.every((entry) => 
            entry.value.toString() == registroMostrado[entry.key].toString()));
    
    if (indexEnDatosCompletos == -1) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No se pudo encontrar el registro original')),
      );
      return;
    }
    
    // Controladores para los campos de texto
    final TextEditingController centroController = TextEditingController(text: registroMostrado[0].toString());
    final TextEditingController edificioController = TextEditingController(text: registroMostrado[1].toString());
    final TextEditingController plantaController = TextEditingController(text: registroMostrado[2].toString());
    final TextEditingController servicioController = TextEditingController(text: registroMostrado[3].toString());
    final TextEditingController telefonoInternoController = TextEditingController(text: registroMostrado[4].toString());
    final TextEditingController telefonoPublicoController = TextEditingController(text: registroMostrado[5].toString());

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Editar Registro'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: centroController,
                  decoration: const InputDecoration(labelText: 'Centro'),
                ),
                TextField(
                  controller: edificioController,
                  decoration: const InputDecoration(labelText: 'Edificio'),
                ),
                TextField(
                  controller: plantaController,
                  decoration: const InputDecoration(labelText: 'Planta'),
                ),
                TextField(
                  controller: servicioController,
                  decoration: const InputDecoration(labelText: 'Servicio/Local'),
                ),
                TextField(
                  controller: telefonoInternoController,
                  decoration: const InputDecoration(labelText: 'Teléfono Interno'),
                  keyboardType: TextInputType.phone,
                ),
                TextField(
                  controller: telefonoPublicoController,
                  decoration: const InputDecoration(labelText: 'Teléfono Público'),
                  keyboardType: TextInputType.phone,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                // Validar que todos los campos estén completos
                if (centroController.text.isEmpty ||
    edificioController.text.isEmpty ||
    plantaController.text.isEmpty ||
    servicioController.text.isEmpty ||
    telefonoInternoController.text.isEmpty ||
    telefonoPublicoController.text.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(content: Text('Todos los campos son obligatorios')),
    );
    return;
    }

    // Actualizar registro
                // Actualizar registro
                List<dynamic> registroActualizado = [
                  centroController.text.trim(),
                  edificioController.text.trim(),
                  plantaController.text.trim(),
                  servicioController.text.trim(),
                  telefonoInternoController.text.trim(),
                  telefonoPublicoController.text.trim(),
                ];

                setState(() {
                  _datosCSV[indexEnDatosCompletos] = registroActualizado;
                  _datosFiltrados = List.from(_datosCSV);
                  _datosMostrados = _datosFiltrados.length > _registrosPorCarga
                      ? _datosFiltrados.sublist(0, _registrosPorCarga)
                      : List.from(_datosFiltrados);
                });

                _guardarDatosCSV();
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Registro actualizado correctamente')),
                );
              },
              child: const Text('Guardar'),
            ),
          ],
        );
      },
    );
  }

  // Método para eliminar un registro
  void _eliminarRegistro(int index) {
    final registroMostrado = _datosMostrados[index];

    // Encontrar el índice real en la lista completa
    final indexEnDatosCompletos = _datosCSV.indexWhere((registro) =>
    registro.length == registroMostrado.length &&
        registro.asMap().entries.every((entry) =>
        entry.value.toString() == registroMostrado[entry.key].toString()));

    if (indexEnDatosCompletos == -1) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No se pudo encontrar el registro original')),
      );
      return;
    }

    // Confirmar eliminación
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Confirmar eliminación'),
          content: const Text('¿Está seguro de que desea eliminar este registro?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  _datosCSV.removeAt(indexEnDatosCompletos);
                  _datosFiltrados = List.from(_datosCSV);
                  _datosMostrados = _datosFiltrados.length > _registrosPorCarga
                      ? _datosFiltrados.sublist(0, _registrosPorCarga)
                      : List.from(_datosFiltrados);
                });

                _guardarDatosCSV();
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Registro eliminado correctamente')),
                );
              },
              child: const Text('Eliminar'),
            ),
          ],
        );
      },
    );
  }

  // Añadir el método build que falta
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Directorio Telefónico Materno/Insular'),
        centerTitle: true,
      ),
      body: _cargando
          ? const Center(child: CircularProgressIndicator())
          : _datosCSV.isEmpty && kIsWeb
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.warning, size: 48, color: Colors.orange),
            SizedBox(height: 16),
            Text(
              'No se pudieron cargar los datos en la versión web',
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 8),
            Text(
              'Intenta usar la aplicación móvil para acceder a todas las funciones',
              style: TextStyle(fontSize: 14),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      )
          : Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            // Fila de botones con tamaño ajustado
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildCompactButton(
                  icon: Icons.phone,
                  label: 'Teléfono',
                  onPressed: _buscarPorTelefono,
                ),
                _buildCompactButton(
                  icon: Icons.search,
                  label: 'Servicio',
                  onPressed: _buscarPorServicio,
                ),
                _buildCompactButton(
                  icon: Icons.add,
                  label: 'Añadir',
                  onPressed: _anadirRegistro,
                ),
                _buildCompactButton(
                  icon: Icons.list,
                  label: 'Todos',
                  onPressed: _mostrarTodos,
                ),
              ],
            ),
            const SizedBox(height: 8),
            // Mostrar contador de registros
            if (_datosFiltrados.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Text(
                  'Mostrando ${_datosMostrados.length} de ${_datosFiltrados.length} registros',
                  style: const TextStyle(fontSize: 12, fontStyle: FontStyle.italic),
                ),
              ),
            // Lista de resultados con carga progresiva
            Expanded(
              child: _datosFiltrados.isEmpty
                  ? const Center(child: Text('No hay registros para mostrar'))
                  : ListView.separated(
                controller: _scrollController,
                itemCount: _datosMostrados.length + (_datosMostrados.length < _datosFiltrados.length ? 1 : 0),
                separatorBuilder: (context, index) => const Divider(height: 1),
                itemBuilder: (context, index) {
                  // Si es el último elemento y hay más datos por cargar, mostrar indicador
                  if (index == _datosMostrados.length) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }

                  final registro = _datosMostrados[index];
                  return ListTile(
                    title: Text(
                      registro[3].toString(),
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('${registro[1]} - ${registro[2]}'),
                        Row(
                          children: [
                            const Icon(Icons.phone, size: 14),
                            const SizedBox(width: 4),
                            Text(
                              'Int: ${registro[4]} | Ext: ${registro[5]}',
                              style: const TextStyle(fontSize: 12),
                            ),
                          ],
                        ),
                      ],
                    ),
                    onTap: () => _mostrarDialogoEditarEliminar(index),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}