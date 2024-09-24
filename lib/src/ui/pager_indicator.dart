import 'package:flutter/material.dart';
import 'package:intro_views_flutter/src/helpers/constants.dart';
import 'package:intro_views_flutter/src/helpers/extensions.dart';
import 'package:intro_views_flutter/src/models/page_bubble_view_model.dart';
import 'package:intro_views_flutter/src/models/pager_indicator_view_model.dart';
import 'package:intro_views_flutter/src/ui/page_bubble.dart';

/// This class contains the UI elements associated with bottom page indicator.
class PagerIndicator extends StatelessWidget {
  const PagerIndicator({
    Key? key,
    required this.viewModel,
    this.bubbleWidth = BUBBLE_WIDTH,
  }) : super(key: key);

  final PagerIndicatorViewModel viewModel;
  final double bubbleWidth;

  @override
  Widget build(BuildContext context) {
    // extracting page bubble information from page view model
    final bubbles = <PageBubble>[];
    final numOfPages = viewModel.pages.length;

    // calculates the width of the bubble to avoid the overflowing render issue #96
    final _bubbleWidth = bubbleWidth * numOfPages > context.screenWidth
        ? (context.screenWidth / numOfPages)
        : bubbleWidth;

    for (var i = 0; i < numOfPages; i++) {
      final page = viewModel.pages[i];

      // calculating percent active
      double percentActive;
      if (i == viewModel.activeIndex) {
        percentActive = 1.0 - viewModel.slidePercent;
      } else if (i == viewModel.activeIndex - 1 &&
          viewModel.slideDirection == SlideDirection.leftToRight) {
        percentActive = viewModel.slidePercent;
      } else if (i == viewModel.activeIndex + 1 &&
          viewModel.slideDirection == SlideDirection.rightToLeft) {
        percentActive = viewModel.slidePercent;
      } else {
        percentActive = 0.0;
      }

      // checking is that bubble hollow
      final isHollow = i > viewModel.activeIndex ||
          (i == viewModel.activeIndex &&
              viewModel.slideDirection == SlideDirection.leftToRight);

      // adding to the list
      bubbles.add(PageBubble(
        width: _bubbleWidth,
        viewModel: PageBubbleViewModel(
          iconAssetPath: page.iconImageAssetPath,
          iconColor: page.iconColor,
          isHollow: isHollow,
          activePercent: percentActive,
          bubbleBackgroundColor: page.bubbleBackgroundColor,
          bubbleInner: page.bubble,
        ),
      ));
    }

    // calculating the translation value of pager indicator while sliding
    final baseTranslation =
        ((viewModel.pages.length * bubbleWidth) / 2) - (bubbleWidth / 2);
    var translation = baseTranslation - (viewModel.activeIndex * bubbleWidth);

    if (viewModel.slideDirection == SlideDirection.leftToRight) {
      translation += bubbleWidth * viewModel.slidePercent;
    } else if (viewModel.slideDirection == SlideDirection.rightToLeft) {
      translation -= bubbleWidth * viewModel.slidePercent;
    }
    // UI
    return Column(
      children: <Widget>[
        const Expanded(child: SizedBox()),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Transform(
              // used for horizontal transformation
              transform: Matrix4.translationValues(translation, 0.0, 0.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: bubbles,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
