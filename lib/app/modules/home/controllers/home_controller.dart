import 'package:campus_crush_app/app/data/models/post_model.dart';
import 'package:campus_crush_app/app/modules/navbar/controllers/user_controller.dart';
import 'package:campus_crush_app/app/services/logger_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  final count = 0.obs;
  final selectedTab = 0.obs;
  final selectedFilter = ''.obs;

  final UserController _userController = Get.put(UserController());

  final List<String> filterOptions = ['Most Liked', 'Most Commented'];

  // New Tab Posts
  RxList<PostModel> posts = <PostModel>[].obs;
  RxBool isLoading = false.obs;
  RxBool isLoadingMore = false.obs;
  RxBool hasError = false.obs;
  RxString errorMessage = ''.obs;
  RxBool hasMorePosts = true.obs;

  DocumentSnapshot<Map<String, dynamic>>? _lastDocument;

  // Hot Tab Posts
  RxList<PostModel> hotPosts = <PostModel>[].obs;
  RxBool isLoadingHot = false.obs;
  RxBool isLoadingMoreHot = false.obs;
  RxBool hasErrorHot = false.obs;
  RxString errorMessageHot = ''.obs;
  RxBool hasMoreHotPosts = true.obs;

  DocumentSnapshot<Map<String, dynamic>>? _lastHotDocument;

  static const int _pageSize = 10;

  @override
  void onInit() {
    getInitData();
    super.onInit();
  }

  Future<void> getInitData() async {
    try {
      isLoading.value = true;
      hasError.value = false;
      errorMessage.value = '';
      _lastDocument = null;
      hasMorePosts.value = true;

      await _userController.fetchUser();

      Query<Map<String, dynamic>> query = FirebaseFirestore.instance
          .collection("posts")
          .where(
            "college.id",
            isEqualTo: _userController.user.value?.college.id,
          );

      query = _applyFirebaseFilter(query);
      query = query.limit(_pageSize);

      final data = await query.get();

      if (data.docs.isNotEmpty) {
        List<PostModel> allPosts = data.docs
            .map((e) => PostModel.fromFirestoreSnapshot(e))
            .toList();

        posts.value = allPosts;
        _lastDocument = data.docs.last;
        hasMorePosts.value = data.docs.length == _pageSize;
      } else {
        posts.value = [];
        hasMorePosts.value = false;
      }

      isLoading.value = false;
    } catch (e) {
      isLoading.value = false;
      hasError.value = true;
      errorMessage.value = 'Error while getting posts: ${e.toString()}';

      Get.snackbar(
        'Error',
        'Error while getting posts!',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.white,
        colorText: Colors.red,
      );
    }
  }

  Future<void> getHotPosts() async {
    try {
      isLoadingHot.value = true;
      hasErrorHot.value = false;
      errorMessageHot.value = '';
      _lastHotDocument = null;
      hasMoreHotPosts.value = true;

      Query<Map<String, dynamic>> query = FirebaseFirestore.instance
          .collection("posts")
          .where(
            "college.id",
            isEqualTo: _userController.user.value?.college.id,
          )
          .where("isHot", isEqualTo: true);

      query = _applyFirebaseFilter(query);
      query = query.limit(_pageSize);

      final data = await query.get();

      LoggerService.logInfo("Hot Post count ${data.docs.length}");
      if (data.docs.isNotEmpty) {
        List<PostModel> allHotPosts = data.docs
            .map((e) => PostModel.fromFirestoreSnapshot(e))
            .toList();

        hotPosts.value = allHotPosts;
        _lastHotDocument = data.docs.last;
        hasMoreHotPosts.value = data.docs.length == _pageSize;
      } else {
        hotPosts.value = [];
        hasMoreHotPosts.value = false;
      }

      isLoadingHot.value = false;
    } catch (e) {
      isLoadingHot.value = false;
      hasErrorHot.value = true;
      errorMessageHot.value = 'Error while getting hot posts: ${e.toString()}';

      Get.snackbar(
        'Error',
        'Error while getting hot posts!',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.white,
        colorText: Colors.red,
      );
    }
  }

  Future<void> loadMorePosts() async {
    if (isLoadingMore.value || !hasMorePosts.value || _lastDocument == null) {
      return;
    }

    try {
      isLoadingMore.value = true;

      Query<Map<String, dynamic>> query = FirebaseFirestore.instance
          .collection("posts")
          .where(
            "college.id",
            isEqualTo: _userController.user.value?.college.id,
          );

      query = _applyFirebaseFilter(query);
      query = query.startAfterDocument(_lastDocument!).limit(_pageSize);

      final data = await query.get();

      if (data.docs.isNotEmpty) {
        List<PostModel> newPosts = data.docs
            .map((e) => PostModel.fromFirestoreSnapshot(e))
            .toList();

        posts.addAll(newPosts);
        _lastDocument = data.docs.last;
        hasMorePosts.value = data.docs.length == _pageSize;
      } else {
        hasMorePosts.value = false;
      }

      isLoadingMore.value = false;
    } catch (e) {
      isLoadingMore.value = false;
      Get.snackbar(
        'Error',
        'Error while loading more posts!',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.white,
        colorText: Colors.red,
      );
    }
  }

  Future<void> loadMoreHotPosts() async {
    if (isLoadingMoreHot.value ||
        !hasMoreHotPosts.value ||
        _lastHotDocument == null) {
      return;
    }

    try {
      isLoadingMoreHot.value = true;

      Query<Map<String, dynamic>> query = FirebaseFirestore.instance
          .collection("posts")
          .where(
            "college.id",
            isEqualTo: _userController.user.value?.college.id,
          )
          .where("isHot", isEqualTo: true);

      query = _applyFirebaseFilter(query);
      query = query.startAfterDocument(_lastHotDocument!).limit(_pageSize);

      final data = await query.get();

      if (data.docs.isNotEmpty) {
        List<PostModel> newHotPosts = data.docs
            .map((e) => PostModel.fromFirestoreSnapshot(e))
            .toList();

        hotPosts.addAll(newHotPosts);
        _lastHotDocument = data.docs.last;
        hasMoreHotPosts.value = data.docs.length == _pageSize;
      } else {
        hasMoreHotPosts.value = false;
      }

      isLoadingMoreHot.value = false;
    } catch (e) {
      isLoadingMoreHot.value = false;
      Get.snackbar(
        'Error',
        'Error while loading more hot posts!',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.white,
        colorText: Colors.red,
      );
    }
  }

  Query<Map<String, dynamic>> _applyFirebaseFilter(
    Query<Map<String, dynamic>> query,
  ) {
    switch (selectedFilter.value) {
      case 'Most Liked':
        return query.orderBy('likes', descending: true);
      case 'Most Commented':
        return query.orderBy('comments', descending: true);
      case 'Most Viewed':
        return query.orderBy('poops', descending: true);
      default:
        return query.orderBy('createdAt', descending: true);
    }
  }

  Future<void> applyFilter(String filter) async {
    selectedFilter.value = filter;
    await getInitData();
    await getHotPosts();
  }

  Future<void> clearFilter() async {
    selectedFilter.value = '';
    await getInitData();
    await getHotPosts();
  }

  Future<void> refreshPosts() async {
    await getInitData();
  }

  Future<void> refreshHotPosts() async {
    await getHotPosts();
  }

  // ==================== LIKE FEATURE (Mutually Exclusive with Poop) ====================
  Future<void> toggleLike(int postIndex) async {
    if (_userController.user.value == null) {
      Get.snackbar(
        'Error',
        'User not found!',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.white,
        colorText: Colors.red,
      );
      return;
    }

    try {
      // Determine which list to use based on selected tab
      final isHotTab = selectedTab.value == 1;
      final post = isHotTab ? hotPosts[postIndex] : posts[postIndex];
      final userId = _userController.user.value!.userId;
      final isLiked = post.likedBy.contains(userId);
      final isPooped = post.poopBy.contains(userId);

      // Optimistic update
      final updatedLikedBy = List<String>.from(post.likedBy);
      final updatedPoopBy = List<String>.from(post.poopBy);
      final updatedLikes = post.likes;
      final updatedPoops = post.poops;

      if (isLiked) {
        // Unlike
        updatedLikedBy.remove(userId);
        final updatedPost = post.copyWith(
          likedBy: updatedLikedBy,
          likes: updatedLikes - 1,
        );

        if (isHotTab) {
          hotPosts[postIndex] = updatedPost;
        } else {
          posts[postIndex] = updatedPost;
        }
      } else {
        // Like - and remove poop if exists
        updatedLikedBy.add(userId);
        int likesChange = 1;
        int poopsChange = 0;

        if (isPooped) {
          updatedPoopBy.remove(userId);
          poopsChange = -1;
        }

        final updatedPost = post.copyWith(
          likedBy: updatedLikedBy,
          likes: updatedLikes + likesChange,
          poopBy: updatedPoopBy,
          poops: updatedPoops + poopsChange,
        );

        if (isHotTab) {
          hotPosts[postIndex] = updatedPost;
        } else {
          posts[postIndex] = updatedPost;
        }
      }

      // Update Firestore
      final postRef = FirebaseFirestore.instance
          .collection('posts')
          .where('userId', isEqualTo: post.userId)
          .where('createdAt', isEqualTo: Timestamp.fromDate(post.createdAt))
          .limit(1);

      final snapshot = await postRef.get();

      if (snapshot.docs.isNotEmpty) {
        final docId = snapshot.docs.first.id;

        if (isLiked) {
          // Unlike
          await FirebaseFirestore.instance
              .collection('posts')
              .doc(docId)
              .update({
                'likedBy': FieldValue.arrayRemove([userId]),
                'likes': FieldValue.increment(-1),
              });
        } else {
          // Like
          Map<String, dynamic> updates = {
            'likedBy': FieldValue.arrayUnion([userId]),
            'likes': FieldValue.increment(1),
          };

          // Remove poop if exists
          if (isPooped) {
            updates['poopBy'] = FieldValue.arrayRemove([userId]);
            updates['poops'] = FieldValue.increment(-1);
          }

          await FirebaseFirestore.instance
              .collection('posts')
              .doc(docId)
              .update(updates);
        }
      }
    } catch (e) {
      // Revert on error
      if (selectedTab.value == 1) {
        await refreshHotPosts();
      } else {
        await refreshPosts();
      }

      Get.snackbar(
        'Error',
        'Failed to update like',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.white,
        colorText: Colors.red,
      );
    }
  }

  // ==================== POOP FEATURE (Mutually Exclusive with Like) ====================
  Future<void> togglePoop(int postIndex) async {
    if (_userController.user.value == null) {
      Get.snackbar(
        'Error',
        'User not found!',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.white,
        colorText: Colors.red,
      );
      return;
    }

    try {
      // Determine which list to use based on selected tab
      final isHotTab = selectedTab.value == 1;
      final post = isHotTab ? hotPosts[postIndex] : posts[postIndex];
      final userId = _userController.user.value!.userId;
      final isPooped = post.poopBy.contains(userId);
      final isLiked = post.likedBy.contains(userId);

      // Optimistic update
      final updatedPoopBy = List<String>.from(post.poopBy);
      final updatedLikedBy = List<String>.from(post.likedBy);
      final updatedPoops = post.poops;
      final updatedLikes = post.likes;

      if (isPooped) {
        // Unpoop
        updatedPoopBy.remove(userId);
        final updatedPost = post.copyWith(
          poopBy: updatedPoopBy,
          poops: updatedPoops - 1,
        );

        if (isHotTab) {
          hotPosts[postIndex] = updatedPost;
        } else {
          posts[postIndex] = updatedPost;
        }
      } else {
        // Poop - and remove like if exists
        updatedPoopBy.add(userId);
        int poopsChange = 1;
        int likesChange = 0;

        if (isLiked) {
          updatedLikedBy.remove(userId);
          likesChange = -1;
        }

        final updatedPost = post.copyWith(
          poopBy: updatedPoopBy,
          poops: updatedPoops + poopsChange,
          likedBy: updatedLikedBy,
          likes: updatedLikes + likesChange,
        );

        if (isHotTab) {
          hotPosts[postIndex] = updatedPost;
        } else {
          posts[postIndex] = updatedPost;
        }
      }

      // Update Firestore
      final postRef = FirebaseFirestore.instance
          .collection('posts')
          .where('userId', isEqualTo: post.userId)
          .where('createdAt', isEqualTo: Timestamp.fromDate(post.createdAt))
          .limit(1);

      final snapshot = await postRef.get();

      if (snapshot.docs.isNotEmpty) {
        final docId = snapshot.docs.first.id;

        if (isPooped) {
          // Unpoop
          await FirebaseFirestore.instance
              .collection('posts')
              .doc(docId)
              .update({
                'poopBy': FieldValue.arrayRemove([userId]),
                'poops': FieldValue.increment(-1),
              });
        } else {
          // Poop
          Map<String, dynamic> updates = {
            'poopBy': FieldValue.arrayUnion([userId]),
            'poops': FieldValue.increment(1),
          };

          // Remove like if exists
          if (isLiked) {
            updates['likedBy'] = FieldValue.arrayRemove([userId]);
            updates['likes'] = FieldValue.increment(-1);
          }

          await FirebaseFirestore.instance
              .collection('posts')
              .doc(docId)
              .update(updates);
        }
      }
    } catch (e) {
      // Revert on error
      if (selectedTab.value == 1) {
        await refreshHotPosts();
      } else {
        await refreshPosts();
      }

      Get.snackbar(
        'Error',
        'Failed to update poop',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.white,
        colorText: Colors.red,
      );
    }
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void increment() => count.value++;

  void selectTab(int index) async {
    selectedTab.value = index;
    if (index == 1) {
      await getHotPosts();
    }
  }

  void updatePostCommentCount(int postIndex, int change) {
    // Determine which list to use based on selected tab
    final isHotTab = selectedTab.value == 1;

    if (isHotTab) {
      if (postIndex >= 0 && postIndex < hotPosts.length) {
        hotPosts[postIndex] = hotPosts[postIndex].copyWith(
          comments: hotPosts[postIndex].comments + change,
        );
      }
    } else {
      if (postIndex >= 0 && postIndex < posts.length) {
        posts[postIndex] = posts[postIndex].copyWith(
          comments: posts[postIndex].comments + change,
        );
      }
    }
  }

  void selectFilter(String filter) {
    if (selectedFilter.value == filter) {
      clearFilter();
    } else {
      applyFilter(filter);
    }
  }
}
