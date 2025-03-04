import 'package:bloc/bloc.dart';
import 'package:flutter_bloc_template/data/model/details_screen/item_details_model.dart';
import 'package:flutter_bloc_template/data/repositories/details_screen_repository.dart';
part 'details_event.dart';
part 'details_state.dart';

class DetailsBloc extends Bloc<DetailsEvent, DetailsState> {
  final DetailsScreenRepository repository = DetailsScreenRepository();

  DetailsBloc() : super(DetailsInitial()) {
    on<DetailsEvent>((event, emit) async {});
  }
}
