import 'package:flutter_dotenv/flutter_dotenv.dart';

class Environment{
  static String movieDbKey = dotenv.env['MOVIEDB_KEY'] ?? 'Falta una Movie Db Key';
}