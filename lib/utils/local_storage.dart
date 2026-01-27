// Conditional import: web implementation when dart:html is available
// import 'local_storage_nonweb.dart'
//     if (dart.library.html) 'local_storage_web.dart';

export 'local_storage_nonweb.dart'
    if (dart.library.html) 'local_storage_web.dart';
