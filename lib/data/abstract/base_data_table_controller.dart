import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../utils/constants/sizes.dart';
import '../../utils/popups/full_screen_loader.dart';
import '../../utils/popups/loaders.dart';

abstract class BaseController<T> extends GetxController {
  RxBool isLoading = false.obs;
  RxList<T> allItems = <T>[].obs;
  RxList<T> filteredItems = <T>[].obs;
  RxList<bool> selectedRows = <bool>[].obs;

  //SORTING
  RxInt sortColumnIndex = 1.obs;
  RxBool sortAscending = true.obs;

  final searchTextController = TextEditingController();

  @override
  void onInit() {
    fetchdata();
    super.onInit();
  }

  //Abstract method to be implemented bu subclasses for fetching items
  Future<List<T>> fetchItems();

  //Abstract method to be implemented bu subclasses for deleting an items
  Future<void> deleteItem(T item);

  //Abstract method to be implemented bu subclasses for searching items
  bool containsSearchQuery(T item, String query);

  //Common Method for Fetching the Data
  Future<void> fetchdata() async {
    try {
      isLoading.value = true;
      List<T> fetchedItems = [];
      if (allItems.isEmpty) {
        fetchedItems = await fetchItems();
      }
      allItems.assignAll(fetchedItems);
      filteredItems.assignAll(allItems);
      selectedRows.assignAll(List.generate(allItems.length, (_) => false));

      isLoading.value = false;
    } catch (e) {
      isLoading.value = false;
      TLoaders.errorSnackBar(title: 'Oh Snap!', message: e.toString());
    }
  }

  //Common method for searching based on query
  void searchQuery(String query) {
    filteredItems.assignAll(
      allItems.where((item) => containsSearchQuery(item, query)),
    );
  }

  //Common method for sorting items
  void sortByProperty(
      int sortColumnIndex, bool ascending, Function(T) property) {
    sortAscending.value = ascending;
    this.sortColumnIndex.value = sortColumnIndex;

    filteredItems.sort(
      (a, b) {
        if (ascending) {
          return property(a).compareTo(property(b));
        } else {
          return property(b).compareTo(property(a));
        }
      },
    );
  }

  //Method for adding an item to the lists
  void addItemToLists(T item) {
    allItems.add(item);
    filteredItems.add(item);
    selectedRows.assignAll(List.generate(allItems.length, (index) => false));
  }

  //Method for updating an item to the lists
  void updateItemFromLists(T item) {
    final itemIndex = allItems.indexWhere((i) => i == item);
    final filteredItemIndex = filteredItems.indexWhere((i) => i == item);

    if (itemIndex != -1) allItems[itemIndex] = item;
    if (filteredItemIndex != -1) filteredItems[filteredItemIndex] = item;
  }

  //Method for removing an item to the lists
  void removeItemFromList(T item) {
    allItems.remove(item);
    filteredItems.remove(item);
    selectedRows.assignAll(List.generate(allItems.length, (index) => false));
  }

  //Common method for confirming deletion and performing thr deletion
  Future<void> confirmAndDeleteItem(T item) async {
    Get.defaultDialog(
      title: 'Delete Item',
      content: const Text('Are you sure you want to delete this Item?'),
      confirm: SizedBox(
        width: 60,
        child: ElevatedButton(
            onPressed: () async => await deleteOnConfirm(item),
            style: OutlinedButton.styleFrom(
              padding:
                  const EdgeInsets.symmetric(vertical: TSizes.buttonHeight / 2),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(TSizes.buttonRadius * 5)),
            ),
            child: const Text('Ok')),
      ),
      cancel: SizedBox(
        width: 60,
        child: OutlinedButton(
            onPressed: () => Get.back(),
            style: OutlinedButton.styleFrom(
              padding:
                  const EdgeInsets.symmetric(vertical: TSizes.buttonHeight / 2),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(TSizes.buttonRadius * 5)),
            ),
            child: const Text('Cancle')),
      ),
    );
  }

  //Common method to be implemented by subclass for handling confirmation before deleting an item
  Future<void> deleteOnConfirm(T item) async {
    try {
      //Remove the popup
      TFullScreenLoader.stopLoading();

      //Start the loader
      TFullScreenLoader.popUpCircular();

      await deleteItem(item);

      removeItemFromList(item);

      TFullScreenLoader.stopLoading();
      TLoaders.successSnackBar(
          title: 'Item Deleted',
          message: 'Item has been deleted successfully');
    } catch (e) {
      TFullScreenLoader.stopLoading();
      TLoaders.errorSnackBar(title: 'Oh Snap!', message: e.toString());
    }
  }
}
