enum TypeSizeScreen {
  extraSmall,
  small,
  medium,
  large,
  extraLarge,
}

extension TypeSizeScreenExtension on TypeSizeScreen {
  double get maxWidth {
    switch (this) {
      case TypeSizeScreen.extraSmall:
        return 320.0;
      case TypeSizeScreen.small:
        return 576.0;
      case TypeSizeScreen.medium:
        return 768.0;
      case TypeSizeScreen.large:
        return 992.0;
      case TypeSizeScreen.extraLarge:
        return double.infinity;
    }
  }
  
  bool isActive(double width) {
    switch (this) {
      case TypeSizeScreen.extraSmall:
        return width < 320.0;
      case TypeSizeScreen.small:
        return width >= 320.0 && width < 576.0;
      case TypeSizeScreen.medium:
        return width >= 576.0 && width < 768.0;
      case TypeSizeScreen.large:
        return width >= 768.0 && width < 992.0;
      case TypeSizeScreen.extraLarge:
        return width >= 992.0;
    }
  }

  static TypeSizeScreen getSizeScreen(double width) {
    if (width < 620.0) {
      return TypeSizeScreen.extraSmall;
    } else if (width >= 620.0 && width < 820.0) {
      return TypeSizeScreen.small;
    } else if (width >= 820.0 && width < 1020.0) {
      return TypeSizeScreen.medium;
    } else if (width >= 1020.0 && width < 1280.0) {
      return TypeSizeScreen.large;
    } else {
      return TypeSizeScreen.extraLarge;
    }
  }
}
