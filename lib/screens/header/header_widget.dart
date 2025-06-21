import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HeaderNavBar extends StatefulWidget {
  const HeaderNavBar({super.key});

  @override
  State<HeaderNavBar> createState() => _HeaderNavBarState();
}

class _HeaderNavBarState extends State<HeaderNavBar> {
  final GlobalKey _solutionsKey = GlobalKey();
  OverlayEntry? _dropdownOverlay;

  bool isHoveringSolutions = false;
  bool isHoveringDropdown = false;

  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _focusNode.addListener(() {
      if (!_focusNode.hasFocus) {
        _hideDropdown();
      }
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _dropdownOverlay?.remove();
    super.dispose();
  }

  void _showDropdown() {
    final RenderBox? renderBox =
        _solutionsKey.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox == null) return;

    final Offset offset = renderBox.localToGlobal(Offset.zero);
    final Size size = renderBox.size;

    _dropdownOverlay = OverlayEntry(
      builder: (context) {
        return Positioned(
          left: offset.dx - 150 + size.width / 2,
          top: offset.dy + size.height + 10,
          child: MouseRegion(
            onEnter: (_) => isHoveringDropdown = true,
            onExit: (_) {
              isHoveringDropdown = false;
              _hideDropdown();
            },
            child: Material(
              elevation: 4,
              child: Container(
                width: 320,
                padding: const EdgeInsets.all(16),
                color: Colors.white,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildDropdownItem('Whatsapp AI Appointment Center',
                        'Reach 3 Billion Users.'),
                    _buildDropdownItem('Facebook Appointment Integration',
                        'Connect to Facebook Pages.'),
                    _buildDropdownItem(
                        'Google Business Booking', 'Appear on Google Search.'),
                    _buildDropdownItem('Website Booking Widget',
                        'Integrate on your own site.'),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );

    Overlay.of(context).insert(_dropdownOverlay!);
    _focusNode.requestFocus();
  }

  void _hideDropdown() {
    _dropdownOverlay?.remove();
    _dropdownOverlay = null;
  }

  Widget _buildDropdownItem(String title, String subtitle) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w400)),
        Text(subtitle, style: const TextStyle(color: Colors.black45)),
        const SizedBox(height: 15),
      ],
    );
  }

  Widget _buildDesktopNavBar() {
    return Focus(
      focusNode: _focusNode,
      autofocus: true,
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () => _focusNode.requestFocus(),
        child: Container(
          padding:
              const EdgeInsets.only(left: 40, right: 40, top: 0, bottom: 8),
          color: Colors.white,
          child: Row(
            children: [
              Image.asset('assets/images/logo_image.png',
                  width: 168, height: 56),
              const Spacer(),
              MouseRegion(
                onEnter: (_) {
                  _showDropdown();
                  setState(() => isHoveringSolutions = true);
                },
                onExit: (_) {
                  Future.delayed(const Duration(milliseconds: 100), () {
                    if (!isHoveringDropdown) _hideDropdown();
                  });
                  setState(() => isHoveringSolutions = false);
                },
                child: Container(
                  key: _solutionsKey,
                  child: Row(
                    children: [
                      Text(
                        'Solutions',
                        style: GoogleFonts.inter(
                          color: isHoveringSolutions
                              ? Color(0xff8c54ff)
                              : Color(0xFF1D2130),
                          fontSize: 16,
                          height: 1.5,
                          decoration: TextDecoration.none,
                        ),
                      ),
                      const Icon(Icons.keyboard_arrow_down,
                          size: 18, color: Colors.black87),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Text('Enterprise',
                  style: GoogleFonts.inter(
                      color: Color(0xFF1D2130),
                      height: 1.5,
                      fontSize: 16,
                      decoration: TextDecoration.none)),
              const SizedBox(width: 26),
              Text('Login',
                  style: GoogleFonts.inter(
                      color: Color(0xFF1D2130),
                      fontSize: 16,
                      height: 1.5,
                      decoration: TextDecoration.none)),
              const SizedBox(width: 16),
              Container(
                height: 48,
                width: 159.28,
                decoration: BoxDecoration(
                  color: const Color(0xFF6F2EFF),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Center(
                        child: Text("Get Started",
                            style: GoogleFonts.inter(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                decoration: TextDecoration.none)),
                      ),
                      SizedBox(width: 5),
                      Icon(Icons.arrow_forward,
                          color: Colors.white, size: 20.8),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTabletNavBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      title: Image.asset('assets/images/logo_image.png', width: 120),
      actions: [
        TextButton(onPressed: () {}, child: const Text('Solutions')),
        TextButton(onPressed: () {}, child: const Text('Enterprise')),
        TextButton(onPressed: () {}, child: const Text('Login')),
        TextButton(
          onPressed: () {},
          child: const Text('Get Started'),
          style: TextButton.styleFrom(
              backgroundColor: const Color(0xFF6f2eff),
              foregroundColor: Colors.white),
        ),
      ],
    );
  }

  Widget _buildMobileNavBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      title: Image.asset('assets/images/logo_image.png', width: 100),
      actions: [
        Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu, color: Colors.black),
            onPressed: () => Scaffold.of(context).openEndDrawer(),
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth >= 1024) {
          return _buildDesktopNavBar();
        } else if (constraints.maxWidth >= 600) {
          return _buildTabletNavBar();
        } else {
          return _buildMobileNavBar();
        }
      },
    );
  }
}
