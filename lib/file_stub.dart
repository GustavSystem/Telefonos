// Stub para File en entorno web
class File {
  final String path;
  
  File(this.path);
  
  Future<File> writeAsBytes(List<int> bytes) async {
    print('Escritura de archivo simulada en web: $path');
    return this;
  }
  
  Future<bool> exists() async {
    return false;
  }
}

// Stub para Directory en entorno web
class Directory {
  final String path;
  
  Directory(this.path);
  
  static Future<Directory> getApplicationDocumentsDirectory() async {
    return Directory('/virtual/path');
  }
}