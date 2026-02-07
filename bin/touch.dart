import 'dart:io';

import 'package:args/args.dart';

const String version = '0.0.1';

ArgParser buildParser() {
  return ArgParser()
    ..addFlag(
      'help',
      abbr: 'h',
      negatable: false,
      help: 'Print this usage information.',
    )
    ..addFlag('version', negatable: false, help: 'Print the tool version.');
}

void printUsage(ArgParser argParser) {
  print('Usage: dart touch.dart <flags> [arguments]');
  print(argParser.usage);
  print("Specify the name of the file to create as A positional argument");
}

void main(List<String> arguments) {
  final ArgParser argParser = buildParser();
  try {
    final ArgResults results = argParser.parse(arguments);

    // Process the parsed arguments.
    if (results.flag('help')) {
      printUsage(argParser);
      return;
    }
    if (results.flag('version')) {
      print('touch version: $version');
      return;
    }
    if (results.rest.isEmpty) {
      print("No file name provided");
      return;
    }
    if (results.rest.length>1) {
      print("Only 1 argument expected, but got ${results.rest.length}");
      return;
    }

    //Create the file with the provided name from the 1 arg only
    final String fileName=results.rest[0];
    final File f=File(fileName);
    if (f.existsSync()) {
      print ("A file with the name $fileName already exists");
      return;
    }
    f.createSync(recursive: true);
    print("Created ${fileName} ");
  } on FormatException catch (e) {
    // Print usage information if an invalid argument was provided.
    print(e.message);
    print('');
    printUsage(argParser);
  }
}
