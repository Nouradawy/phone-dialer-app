import 'package:bloc/bloc.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:dialer_app/Modules/Search/Cubit/states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SearchCubit extends Cubit<SearchStates>{
  SearchCubit() : super(SearchInitialState());
  static SearchCubit get(context)=> BlocProvider.of(context);
  List<Contact> contactsFiltered =[];

  filterContacts(){
    List<Contact> _contacts = [];
    _contacts.addAll(contacts);

  }

}
