class Responsive {
  static bool isMobile(double width) => width < 600;
  static bool isTablet(double width) => width >= 600 && width < 938;
  static bool isDesktop(double width) => width >= 938;
}
