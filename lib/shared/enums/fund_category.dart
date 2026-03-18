enum FundCategory { fpv, fic }

extension FundCategoryX on FundCategory {
  String get label => this == FundCategory.fpv ? 'FPV' : 'FIC';
}
