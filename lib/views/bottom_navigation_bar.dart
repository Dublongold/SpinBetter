import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:spin_better/res/strings.dart';
import 'package:spin_better/selected_page.dart';
import 'package:provider/provider.dart';

class BottomNavigationIcons extends StatefulWidget {
  const BottomNavigationIcons({
    super.key,
  });

  @override
  State<BottomNavigationIcons> createState() => _BottomNavigationIconsState();

}

class _BottomNavigationIconsState extends State<BottomNavigationIcons> {
  int _selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    SelectedPage state = context.watch();
    return Theme(
      data: Theme.of(context).copyWith(
        canvasColor: Colors.black,
      ),
      child: BottomNavigationBar(
        selectedItemColor: const Color(0xBBFFFFFF),
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
          state.selectPage(index);
        },
        currentIndex: _selectedIndex,
        unselectedItemColor: Colors.white38,
        items: [
          BottomNavigationBarItem(
              icon: getIcon("live", false),
              label: liveTitleText,
              activeIcon: getIcon("live", true)
          ),
          BottomNavigationBarItem(
            icon: getIcon("pre_match", false),
            label: preMatchTitleText,
            activeIcon: getIcon("pre_match", true)
          ),
          BottomNavigationBarItem(
            icon: getIcon("the_last", false),
            label: theLastTitleText,
            activeIcon: getIcon("the_last", true)
          ),
          BottomNavigationBarItem(
            icon: getIcon("news", false),
            label: newsTitleText,
            activeIcon: getIcon("news", true),
          ),
        ],
      ),
    );
  }

  SvgPicture getIcon(String iconType, bool isActive) {
    String isActivePrefix = isActive ? "" : "in";
    return SvgPicture.asset("images/icons/${isActivePrefix}active/"
        "${iconType}_${isActivePrefix}active.svg", width: 38, height: 38);
  }
}