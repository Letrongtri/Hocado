import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hocado/data/models/deck.dart';

class EditDeckViewModel extends Notifier<Deck> {
  final String? did;

  EditDeckViewModel(this.did);

  @override
  Deck build() {
    // TODO: implement build
    throw UnimplementedError();
  }
}
