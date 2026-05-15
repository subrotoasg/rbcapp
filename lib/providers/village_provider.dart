import 'package:flutter/material.dart';
import '../models/person_model.dart';
import '../models/family_tree_model.dart';
import '../services/village_api.dart';
import '../core/services/api_client.dart';

class VillageProvider with ChangeNotifier {
  final VillageApi _api = VillageApi(ApiClient.instance);
  
  List<Person> _people = [];
  bool _isLoading = false;

  List<Person> get people => _people;
  bool get isLoading => _isLoading;

  Future<void> fetchAllPeople() async {
    _isLoading = true;
    notifyListeners();
    try {
      final data = await _api.getAllPeople();
      _people = data.map((e) => Person.fromJson(e)).toList();
    } catch (e) {
      debugPrint("Fetch Error: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<FamilyTree?> fetchFamilyTree(String id) async {
    try {
      final data = await _api.getFamilyTree(id);
      return FamilyTree.fromJson(data);
    } catch (e) {
      return null;
    }
  }

  Future<bool> addPerson(Map<String, dynamic> data, String token) async {
    _isLoading = true;
    notifyListeners();
    try {
      await _api.createPerson(data, token);
      await fetchAllPeople();
      return true;
    } catch (e) {
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> updatePerson(String id, Map<String, dynamic> data, String token) async {
    _isLoading = true;
    notifyListeners();
    try {
      await _api.updatePerson(id, data, token);
      await fetchAllPeople();
      return true;
    } catch (e) {
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> deletePerson(String id, String token) async {
    try {
      await _api.deletePerson(id, token);
      _people.removeWhere((p) => p.id == id);
      notifyListeners();
      return true;
    } catch (e) {
      return false;
    }
  }
}