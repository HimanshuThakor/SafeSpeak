import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:safespeak/Providers/ApiServiceProvider.dart';
import 'package:safespeak/Services/SessionManagement.dart';
import 'package:safespeak/Services/api_service.dart';
import 'package:safespeak/models/ApiJsonBodyRequest.dart';
import 'package:safespeak/models/FamilyMemberModel.dart';

import '../models/ResponseModel.dart';

class FamilyState {
  final FamilyMember? familyMembers;
  final bool isLoading;

  FamilyState({
    this.familyMembers,
    this.isLoading = false,
  });

  FamilyState copyWith({
    FamilyMember? familyMembers,
    bool? isLoading,
  }) {
    return FamilyState(
      familyMembers: familyMembers ?? this.familyMembers,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class FamilyMembersNotifier extends StateNotifier<FamilyState> {
  FamilyMembersNotifier(this.ref)
      : _api = ref.read(apiServiceProvider),
        _session = ref.read(sessionMgmtProvider),
        super(FamilyState());

  final Ref ref;
  final ApiService _api;
  final SessionManagement _session;

  // Get all family members
  Future<void> getFamilyMembers() async {
    try {
      state = state.copyWith(isLoading: true);

      var loginResponse = await _session.getModel("MAP");
      String id = loginResponse!.user!.id;

      // Call API to get family members
      ResponseModel? response =
          await _api.getFamilyMembers(ApiBodyJson(id: id));

      if (response != null && response.success == true) {
        FamilyMember member = FamilyMember.fromJson(response.data);
        state = state.copyWith(familyMembers: member, isLoading: false);
      } else {
        state = state.copyWith(isLoading: false);
      }
    } catch (e) {
      state = state.copyWith(isLoading: false);
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  // Add family member
  Future<bool> addFamilyMember(
      String name, String relationship, String email, String phone) async {
    try {
      state = state.copyWith(isLoading: true);

      var loginResponse = await _session.getModel("MAP");
      String id = loginResponse!.user!.id;

      ResponseModel? response = await _api.addFamilyMember(ApiBodyJson(
        id: id,
        relationship: relationship,
        name: name,
        phone: phone,
        email: email,
      ));

      if (response != null && response.success == true) {
        // Refresh the family members list after adding
        await getFamilyMembers();
        return true;
      } else {
        state = state.copyWith(isLoading: false);
        return false;
      }
    } catch (e) {
      state = state.copyWith(isLoading: false);
      return false;
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  // Remove family member
  Future<bool> removeFamilyMember(String id) async {
    try {
      state = state.copyWith(isLoading: true);

      var loginResponse = await _session.getModel("MAP");
      String userId = loginResponse!.user!.id;

      ResponseModel? response = await _api.removeFamilyMember(id, userId);

      if (response != null && response.success == true) {
        // Refresh the family members list after removing
        await getFamilyMembers();
        return true;
      } else {
        state = state.copyWith(isLoading: false);
        return false;
      }
    } catch (e) {
      state = state.copyWith(isLoading: false);
      return false;
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  // Update family member
  Future<bool> updateFamilyMember(String name, String email, String phone,
      String relationship, String id) async {
    try {
      state = state.copyWith(isLoading: true);

      ResponseModel? response = await _api.updateFamilyMember(ApiBodyJson(
        name: name,
        phone: phone,
        email: email,
        relationship: relationship,
        id: id,
      ));

      if (response != null && response.success == true) {
        // Refresh the family members list after updating
        await getFamilyMembers();
        return true;
      } else {
        state = state.copyWith(isLoading: false);
        return false;
      }
    } catch (e) {
      state = state.copyWith(isLoading: false);
      return false;
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }
}

// Providers
final familyMembersProvider =
    StateNotifierProvider<FamilyMembersNotifier, FamilyState>((ref) {
  return FamilyMembersNotifier(ref);
});

// Form State Provider
final formKeyProvider = Provider<GlobalKey<FormState>>((ref) {
  return GlobalKey<FormState>();
});

// Loading State Provider (This might be redundant now since we have isLoading in FamilyState)
final isLoadingProvider = StateProvider<bool>((ref) => false);
