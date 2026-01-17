import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MenuEntry {
  final String id;
  final String? title;
  final List<String> itemIds;
  final bool isGroup;

  MenuEntry({
    required this.id,
    this.title,
    this.itemIds = const [],
    this.isGroup = false,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'itemIds': itemIds,
    'isGroup': isGroup,
  };

  factory MenuEntry.fromJson(Map<String, dynamic> json) => MenuEntry(
    id: json['id'],
    title: json['title'],
    itemIds: List<String>.from(json['itemIds'] ?? []),
    isGroup: json['isGroup'] ?? false,
  );
}

final initialMenuOrder = [
  MenuEntry(id: 'energy'),
  MenuEntry(id: 'ev'),
  MenuEntry(id: 'parcel'),
  MenuEntry(id: 'community'),
  MenuEntry(id: 'laundry'),
  MenuEntry(id: 'homecare'),
  MenuEntry(id: 'garden'),
  MenuEntry(id: 'share'),
  MenuEntry(id: 'visitor'),
  MenuEntry(id: 'vote'),
];

class MenuOrderNotifier extends StateNotifier<List<MenuEntry>> {
  MenuOrderNotifier() : super(initialMenuOrder) {
    _loadOrder();
  }

  Future<void> _loadOrder() async {
    final prefs = await SharedPreferences.getInstance();
    final savedJson = prefs.getString('resident_menu_order_v2');
    if (savedJson != null) {
      try {
        final List<dynamic> decoded = jsonDecode(savedJson);
        state = decoded.map((item) => MenuEntry.fromJson(item)).toList();
      } catch (e) {
        state = initialMenuOrder;
      }
    }
  }

  Future<void> _saveOrder() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonStr = jsonEncode(state.map((e) => e.toJson()).toList());
    await prefs.setString('resident_menu_order_v2', jsonStr);
  }

  void reorder(int oldIndex, int newIndex) {
    final newState = List<MenuEntry>.from(state);
    final item = newState.removeAt(oldIndex);
    newState.insert(newIndex, item);
    state = newState;
    _saveOrder();
  }

  void merge(int sourceIndex, int targetIndex) {
    if (sourceIndex == targetIndex) return;
    
    final newState = List<MenuEntry>.from(state);
    final source = newState[sourceIndex];
    final target = newState[targetIndex];

    if (source.isGroup) return; // For now don't merge groups into items

    if (target.isGroup) {
      // Add source item to existing group
      final updatedItemIds = List<String>.from(target.itemIds)..add(source.id);
      newState[targetIndex] = MenuEntry(
        id: target.id,
        title: target.title,
        itemIds: updatedItemIds,
        isGroup: true,
      );
      newState.removeAt(sourceIndex);
    } else {
      // Create new group from two items
      final newGroupId = 'group_${DateTime.now().millisecondsSinceEpoch}';
      newState[targetIndex] = MenuEntry(
        id: newGroupId,
        title: 'New Group',
        itemIds: [target.id, source.id],
        isGroup: true,
      );
      newState.removeAt(sourceIndex);
    }
    
    state = newState;
    _saveOrder();
  }

  void ungroup(String groupId) {
    final newState = List<MenuEntry>.from(state);
    final groupIndex = newState.indexWhere((e) => e.id == groupId);
    if (groupIndex == -1) return;

    final group = newState[groupIndex];
    newState.removeAt(groupIndex);
    
    // Add items back as single entries
    for (final itemId in group.itemIds) {
      newState.add(MenuEntry(id: itemId));
    }
    
    state = newState;
    _saveOrder();
  }
}

final menuOrderProvider = StateNotifierProvider<MenuOrderNotifier, List<MenuEntry>>((ref) {
  return MenuOrderNotifier();
});
