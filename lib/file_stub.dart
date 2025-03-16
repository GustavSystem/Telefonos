// Este archivo proporciona una implementación vacía de File para web
class File {
  final String path;
  
  File(this.path);
  
  // Métodos comunes que podrías necesitar
  Future<bool> exists() async {
    return false;
  }
  
  Future<List<int>> readAsBytes() async {
    return [];
  }
  
  Future<String> readAsString() async {
    return '';
  }
  
  Future<File> writeAsBytes(List<int> bytes) async {
    return this;
  }
  
  Future<File> writeAsString(String contents) async {
    return this;
  }
  
  // Agrega aquí otros métodos que necesites
}