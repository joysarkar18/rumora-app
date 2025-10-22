import 'package:avatar_plus/avatar_plus.dart';
import 'package:campus_crush_app/app/common/widgets/common_image_view.dart';
import 'package:campus_crush_app/app/utils/app_colors.dart';
import 'package:campus_crush_app/app/utils/text_styles.dart';
import 'package:campus_crush_app/constants/assets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class PostCard extends StatefulWidget {
  final String username;
  final String university;
  final String timeAgo;
  final String postContent;
  final int likes;
  final int comments;
  final int poops;
  final List<String> imageUrls;

  const PostCard({
    super.key,
    this.username = "GubbyDubbys23",
    this.university = "Maulana Abul Kalam Azad University of Technology",
    this.timeAgo = "2 min ago",
    this.postContent =
        "This is something I wanna post on this community. Let's connect and make friends!",
    this.likes = 65,
    this.comments = 5,
    this.poops = 15,
    this.imageUrls = const [
      "https://images.pexels.com/photos/4017827/pexels-photo-4017827.jpeg?cs=srgb&dl=pexels-muaz-aj-1782491-4017827.jpg&fm=jpg",
      "https://images.unsplash.com/photo-1529778873920-4da4926a72c2?ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Mnx8Y3V0ZSUyMGNhdHxlbnwwfHwwfHx8MA%3D%3D&fm=jpg&q=60&w=3000",
    ],
  });

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  late PageController _pageController;
  int _currentImageIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 8,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(12),
              child: Column(
                children: [
                  // Header with avatar and user info
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AvatarPlus("adsddsafsdeaasdSfe", height: 40, width: 40),
                      SizedBox(width: 4),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(height: 4),
                            Text(
                              widget.username,
                              style: AppTextStyles.style14w500(
                                color: AppColors.grayBlue,
                              ),
                            ),
                            SizedBox(height: 2),
                            Text(
                              widget.university,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: AppTextStyles.style12w400(
                                color: AppColors.grayBlue,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 10.w),
                      Text(
                        widget.timeAgo,
                        style: AppTextStyles.style12w600(
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),

                  // Post content with images carousel
                  Container(
                    margin: EdgeInsets.only(top: 10),
                    decoration: BoxDecoration(
                      color: AppColors.lightPink.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Text content
                        Padding(
                          padding: EdgeInsets.all(12),
                          child: Text(
                            widget.postContent,
                            style: AppTextStyles.style14w500(
                              color: AppColors.grayBlue,
                            ),
                          ),
                        ),
                        // Images carousel
                        if (widget.imageUrls.isNotEmpty)
                          _buildImagesCarousel(widget.imageUrls),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Engagement stats
            Padding(
              padding: EdgeInsets.all(12),
              child: Row(
                children: [
                  SizedBox(width: 4),
                  Icon(Icons.favorite_border_rounded),
                  SizedBox(width: 4),
                  Text(
                    "${widget.likes}",
                    style: AppTextStyles.style15w700(color: AppColors.primary),
                  ),
                  SizedBox(width: 16),
                  SvgPicture.asset(Assets.iconsComment, height: 21),
                  SizedBox(width: 4),
                  Text(
                    "${widget.comments}",
                    style: AppTextStyles.style15w700(color: AppColors.primary),
                  ),
                  SizedBox(width: 16),
                  SvgPicture.asset(
                    Assets.iconsPoopFilled,
                    height: 22,
                    color: AppColors.orangePrimary,
                  ),
                  SizedBox(width: 4),
                  Text(
                    "${widget.poops}",
                    style: AppTextStyles.style15w700(
                      color: AppColors.orangePrimary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImagesCarousel(List<String> urls) {
    if (urls.isEmpty) return SizedBox.shrink();

    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: AspectRatio(
        aspectRatio: 1,
        child: Stack(
          children: [
            // Carousel
            PageView.builder(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _currentImageIndex = index;
                });
              },
              itemCount: urls.length,
              itemBuilder: (context, index) {
                return CommonImageView(
                  url: urls[index],
                  height: double.infinity,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  borderRadius: BorderRadius.zero,
                );
              },
            ),
            // Indicator dots overlay
            if (urls.length > 1)
              Positioned(
                bottom: 12,
                left: 0,
                right: 0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    urls.length,
                    (index) => GestureDetector(
                      onTap: () {
                        _pageController.animateToPage(
                          index,
                          duration: Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      },
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 4),
                        height: 6,
                        width: _currentImageIndex == index ? 20 : 6,
                        decoration: BoxDecoration(
                          color: _currentImageIndex == index
                              ? AppColors.primary.withAlpha(140)
                              : Colors.white.withValues(alpha: 0.6),
                          borderRadius: BorderRadius.circular(3),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
