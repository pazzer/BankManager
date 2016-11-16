### Bank Manager


### Next Steps

1. ``NewShiftViewController`` has three computed properties whose value is dependent on ``startDate`` and ``stopDate``. As it stands three separate ``keyPathsForValuesAffecting...`` functions describe this relationship; does the KVO-KVC API provide a way to specify this relationship in a single class-level function?

2. Sites can have a mixture of numbered wards (e.g. 201, 106) and named wards (e.g. Day Surgery, AMU); because of this when wards are sorted by ``name`` the ordering can be unexpected. Set about remedying this so sorting is both intuitive and predictable.

3. When shifts are chunked into blocks according to the pay structure for a given date, no account is taken of unworked hours. Instead, this is deduced and deducted in the ``Shift`` class once it has received the shift components. It makes more sense for the ``PayStructure`` class to encode the breaks policy and make the necessary ammendments to the shift components during the chunking process. Refactor to reflect this.