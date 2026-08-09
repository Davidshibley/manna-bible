// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'main.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetBibleVerseCollection on Isar {
  IsarCollection<BibleVerse> get bibleVerses => this.collection();
}

const BibleVerseSchema = CollectionSchema(
  name: r'BibleVerse',
  id: 7966111860672727516,
  properties: {
    r'bookName': PropertySchema(
      id: 0,
      name: r'bookName',
      type: IsarType.string,
    ),
    r'chapter': PropertySchema(
      id: 1,
      name: r'chapter',
      type: IsarType.long,
    ),
    r'textEnglish': PropertySchema(
      id: 2,
      name: r'textEnglish',
      type: IsarType.string,
    ),
    r'textTelugu': PropertySchema(
      id: 3,
      name: r'textTelugu',
      type: IsarType.string,
    ),
    r'verseNumber': PropertySchema(
      id: 4,
      name: r'verseNumber',
      type: IsarType.long,
    )
  },
  estimateSize: _bibleVerseEstimateSize,
  serialize: _bibleVerseSerialize,
  deserialize: _bibleVerseDeserialize,
  deserializeProp: _bibleVerseDeserializeProp,
  idName: r'id',
  indexes: {
    r'bookName': IndexSchema(
      id: -1933582217000277918,
      name: r'bookName',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'bookName',
          type: IndexType.value,
          caseSensitive: true,
        )
      ],
    ),
    r'chapter': IndexSchema(
      id: 3334647619021962063,
      name: r'chapter',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'chapter',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _bibleVerseGetId,
  getLinks: _bibleVerseGetLinks,
  attach: _bibleVerseAttach,
  version: '3.3.2',
);

int _bibleVerseEstimateSize(
  BibleVerse object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.bookName.length * 3;
  bytesCount += 3 + object.textEnglish.length * 3;
  {
    final value = object.textTelugu;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  return bytesCount;
}

void _bibleVerseSerialize(
  BibleVerse object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.bookName);
  writer.writeLong(offsets[1], object.chapter);
  writer.writeString(offsets[2], object.textEnglish);
  writer.writeString(offsets[3], object.textTelugu);
  writer.writeLong(offsets[4], object.verseNumber);
}

BibleVerse _bibleVerseDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = BibleVerse();
  object.bookName = reader.readString(offsets[0]);
  object.chapter = reader.readLong(offsets[1]);
  object.id = id;
  object.textEnglish = reader.readString(offsets[2]);
  object.textTelugu = reader.readStringOrNull(offsets[3]);
  object.verseNumber = reader.readLong(offsets[4]);
  return object;
}

P _bibleVerseDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readString(offset)) as P;
    case 1:
      return (reader.readLong(offset)) as P;
    case 2:
      return (reader.readString(offset)) as P;
    case 3:
      return (reader.readStringOrNull(offset)) as P;
    case 4:
      return (reader.readLong(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _bibleVerseGetId(BibleVerse object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _bibleVerseGetLinks(BibleVerse object) {
  return [];
}

void _bibleVerseAttach(IsarCollection<dynamic> col, Id id, BibleVerse object) {
  object.id = id;
}

extension BibleVerseQueryWhereSort
    on QueryBuilder<BibleVerse, BibleVerse, QWhere> {
  QueryBuilder<BibleVerse, BibleVerse, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<BibleVerse, BibleVerse, QAfterWhere> anyBookName() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'bookName'),
      );
    });
  }

  QueryBuilder<BibleVerse, BibleVerse, QAfterWhere> anyChapter() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'chapter'),
      );
    });
  }
}

extension BibleVerseQueryWhere
    on QueryBuilder<BibleVerse, BibleVerse, QWhereClause> {
  QueryBuilder<BibleVerse, BibleVerse, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<BibleVerse, BibleVerse, QAfterWhereClause> idNotEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<BibleVerse, BibleVerse, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<BibleVerse, BibleVerse, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<BibleVerse, BibleVerse, QAfterWhereClause> idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerId,
        includeLower: includeLower,
        upper: upperId,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<BibleVerse, BibleVerse, QAfterWhereClause> bookNameEqualTo(
      String bookName) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'bookName',
        value: [bookName],
      ));
    });
  }

  QueryBuilder<BibleVerse, BibleVerse, QAfterWhereClause> bookNameNotEqualTo(
      String bookName) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'bookName',
              lower: [],
              upper: [bookName],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'bookName',
              lower: [bookName],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'bookName',
              lower: [bookName],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'bookName',
              lower: [],
              upper: [bookName],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<BibleVerse, BibleVerse, QAfterWhereClause> bookNameGreaterThan(
    String bookName, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'bookName',
        lower: [bookName],
        includeLower: include,
        upper: [],
      ));
    });
  }

  QueryBuilder<BibleVerse, BibleVerse, QAfterWhereClause> bookNameLessThan(
    String bookName, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'bookName',
        lower: [],
        upper: [bookName],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<BibleVerse, BibleVerse, QAfterWhereClause> bookNameBetween(
    String lowerBookName,
    String upperBookName, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'bookName',
        lower: [lowerBookName],
        includeLower: includeLower,
        upper: [upperBookName],
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<BibleVerse, BibleVerse, QAfterWhereClause> bookNameStartsWith(
      String BookNamePrefix) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'bookName',
        lower: [BookNamePrefix],
        upper: ['$BookNamePrefix\u{FFFFF}'],
      ));
    });
  }

  QueryBuilder<BibleVerse, BibleVerse, QAfterWhereClause> bookNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'bookName',
        value: [''],
      ));
    });
  }

  QueryBuilder<BibleVerse, BibleVerse, QAfterWhereClause> bookNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.lessThan(
              indexName: r'bookName',
              upper: [''],
            ))
            .addWhereClause(IndexWhereClause.greaterThan(
              indexName: r'bookName',
              lower: [''],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.greaterThan(
              indexName: r'bookName',
              lower: [''],
            ))
            .addWhereClause(IndexWhereClause.lessThan(
              indexName: r'bookName',
              upper: [''],
            ));
      }
    });
  }

  QueryBuilder<BibleVerse, BibleVerse, QAfterWhereClause> chapterEqualTo(
      int chapter) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'chapter',
        value: [chapter],
      ));
    });
  }

  QueryBuilder<BibleVerse, BibleVerse, QAfterWhereClause> chapterNotEqualTo(
      int chapter) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'chapter',
              lower: [],
              upper: [chapter],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'chapter',
              lower: [chapter],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'chapter',
              lower: [chapter],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'chapter',
              lower: [],
              upper: [chapter],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<BibleVerse, BibleVerse, QAfterWhereClause> chapterGreaterThan(
    int chapter, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'chapter',
        lower: [chapter],
        includeLower: include,
        upper: [],
      ));
    });
  }

  QueryBuilder<BibleVerse, BibleVerse, QAfterWhereClause> chapterLessThan(
    int chapter, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'chapter',
        lower: [],
        upper: [chapter],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<BibleVerse, BibleVerse, QAfterWhereClause> chapterBetween(
    int lowerChapter,
    int upperChapter, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'chapter',
        lower: [lowerChapter],
        includeLower: includeLower,
        upper: [upperChapter],
        includeUpper: includeUpper,
      ));
    });
  }
}

extension BibleVerseQueryFilter
    on QueryBuilder<BibleVerse, BibleVerse, QFilterCondition> {
  QueryBuilder<BibleVerse, BibleVerse, QAfterFilterCondition> bookNameEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'bookName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BibleVerse, BibleVerse, QAfterFilterCondition>
      bookNameGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'bookName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BibleVerse, BibleVerse, QAfterFilterCondition> bookNameLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'bookName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BibleVerse, BibleVerse, QAfterFilterCondition> bookNameBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'bookName',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BibleVerse, BibleVerse, QAfterFilterCondition>
      bookNameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'bookName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BibleVerse, BibleVerse, QAfterFilterCondition> bookNameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'bookName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BibleVerse, BibleVerse, QAfterFilterCondition> bookNameContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'bookName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BibleVerse, BibleVerse, QAfterFilterCondition> bookNameMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'bookName',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BibleVerse, BibleVerse, QAfterFilterCondition>
      bookNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'bookName',
        value: '',
      ));
    });
  }

  QueryBuilder<BibleVerse, BibleVerse, QAfterFilterCondition>
      bookNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'bookName',
        value: '',
      ));
    });
  }

  QueryBuilder<BibleVerse, BibleVerse, QAfterFilterCondition> chapterEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'chapter',
        value: value,
      ));
    });
  }

  QueryBuilder<BibleVerse, BibleVerse, QAfterFilterCondition>
      chapterGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'chapter',
        value: value,
      ));
    });
  }

  QueryBuilder<BibleVerse, BibleVerse, QAfterFilterCondition> chapterLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'chapter',
        value: value,
      ));
    });
  }

  QueryBuilder<BibleVerse, BibleVerse, QAfterFilterCondition> chapterBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'chapter',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<BibleVerse, BibleVerse, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<BibleVerse, BibleVerse, QAfterFilterCondition> idGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<BibleVerse, BibleVerse, QAfterFilterCondition> idLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<BibleVerse, BibleVerse, QAfterFilterCondition> idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<BibleVerse, BibleVerse, QAfterFilterCondition>
      textEnglishEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'textEnglish',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BibleVerse, BibleVerse, QAfterFilterCondition>
      textEnglishGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'textEnglish',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BibleVerse, BibleVerse, QAfterFilterCondition>
      textEnglishLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'textEnglish',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BibleVerse, BibleVerse, QAfterFilterCondition>
      textEnglishBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'textEnglish',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BibleVerse, BibleVerse, QAfterFilterCondition>
      textEnglishStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'textEnglish',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BibleVerse, BibleVerse, QAfterFilterCondition>
      textEnglishEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'textEnglish',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BibleVerse, BibleVerse, QAfterFilterCondition>
      textEnglishContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'textEnglish',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BibleVerse, BibleVerse, QAfterFilterCondition>
      textEnglishMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'textEnglish',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BibleVerse, BibleVerse, QAfterFilterCondition>
      textEnglishIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'textEnglish',
        value: '',
      ));
    });
  }

  QueryBuilder<BibleVerse, BibleVerse, QAfterFilterCondition>
      textEnglishIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'textEnglish',
        value: '',
      ));
    });
  }

  QueryBuilder<BibleVerse, BibleVerse, QAfterFilterCondition>
      textTeluguIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'textTelugu',
      ));
    });
  }

  QueryBuilder<BibleVerse, BibleVerse, QAfterFilterCondition>
      textTeluguIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'textTelugu',
      ));
    });
  }

  QueryBuilder<BibleVerse, BibleVerse, QAfterFilterCondition> textTeluguEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'textTelugu',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BibleVerse, BibleVerse, QAfterFilterCondition>
      textTeluguGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'textTelugu',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BibleVerse, BibleVerse, QAfterFilterCondition>
      textTeluguLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'textTelugu',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BibleVerse, BibleVerse, QAfterFilterCondition> textTeluguBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'textTelugu',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BibleVerse, BibleVerse, QAfterFilterCondition>
      textTeluguStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'textTelugu',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BibleVerse, BibleVerse, QAfterFilterCondition>
      textTeluguEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'textTelugu',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BibleVerse, BibleVerse, QAfterFilterCondition>
      textTeluguContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'textTelugu',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BibleVerse, BibleVerse, QAfterFilterCondition> textTeluguMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'textTelugu',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BibleVerse, BibleVerse, QAfterFilterCondition>
      textTeluguIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'textTelugu',
        value: '',
      ));
    });
  }

  QueryBuilder<BibleVerse, BibleVerse, QAfterFilterCondition>
      textTeluguIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'textTelugu',
        value: '',
      ));
    });
  }

  QueryBuilder<BibleVerse, BibleVerse, QAfterFilterCondition>
      verseNumberEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'verseNumber',
        value: value,
      ));
    });
  }

  QueryBuilder<BibleVerse, BibleVerse, QAfterFilterCondition>
      verseNumberGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'verseNumber',
        value: value,
      ));
    });
  }

  QueryBuilder<BibleVerse, BibleVerse, QAfterFilterCondition>
      verseNumberLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'verseNumber',
        value: value,
      ));
    });
  }

  QueryBuilder<BibleVerse, BibleVerse, QAfterFilterCondition>
      verseNumberBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'verseNumber',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension BibleVerseQueryObject
    on QueryBuilder<BibleVerse, BibleVerse, QFilterCondition> {}

extension BibleVerseQueryLinks
    on QueryBuilder<BibleVerse, BibleVerse, QFilterCondition> {}

extension BibleVerseQuerySortBy
    on QueryBuilder<BibleVerse, BibleVerse, QSortBy> {
  QueryBuilder<BibleVerse, BibleVerse, QAfterSortBy> sortByBookName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bookName', Sort.asc);
    });
  }

  QueryBuilder<BibleVerse, BibleVerse, QAfterSortBy> sortByBookNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bookName', Sort.desc);
    });
  }

  QueryBuilder<BibleVerse, BibleVerse, QAfterSortBy> sortByChapter() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'chapter', Sort.asc);
    });
  }

  QueryBuilder<BibleVerse, BibleVerse, QAfterSortBy> sortByChapterDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'chapter', Sort.desc);
    });
  }

  QueryBuilder<BibleVerse, BibleVerse, QAfterSortBy> sortByTextEnglish() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'textEnglish', Sort.asc);
    });
  }

  QueryBuilder<BibleVerse, BibleVerse, QAfterSortBy> sortByTextEnglishDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'textEnglish', Sort.desc);
    });
  }

  QueryBuilder<BibleVerse, BibleVerse, QAfterSortBy> sortByTextTelugu() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'textTelugu', Sort.asc);
    });
  }

  QueryBuilder<BibleVerse, BibleVerse, QAfterSortBy> sortByTextTeluguDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'textTelugu', Sort.desc);
    });
  }

  QueryBuilder<BibleVerse, BibleVerse, QAfterSortBy> sortByVerseNumber() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'verseNumber', Sort.asc);
    });
  }

  QueryBuilder<BibleVerse, BibleVerse, QAfterSortBy> sortByVerseNumberDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'verseNumber', Sort.desc);
    });
  }
}

extension BibleVerseQuerySortThenBy
    on QueryBuilder<BibleVerse, BibleVerse, QSortThenBy> {
  QueryBuilder<BibleVerse, BibleVerse, QAfterSortBy> thenByBookName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bookName', Sort.asc);
    });
  }

  QueryBuilder<BibleVerse, BibleVerse, QAfterSortBy> thenByBookNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bookName', Sort.desc);
    });
  }

  QueryBuilder<BibleVerse, BibleVerse, QAfterSortBy> thenByChapter() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'chapter', Sort.asc);
    });
  }

  QueryBuilder<BibleVerse, BibleVerse, QAfterSortBy> thenByChapterDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'chapter', Sort.desc);
    });
  }

  QueryBuilder<BibleVerse, BibleVerse, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<BibleVerse, BibleVerse, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<BibleVerse, BibleVerse, QAfterSortBy> thenByTextEnglish() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'textEnglish', Sort.asc);
    });
  }

  QueryBuilder<BibleVerse, BibleVerse, QAfterSortBy> thenByTextEnglishDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'textEnglish', Sort.desc);
    });
  }

  QueryBuilder<BibleVerse, BibleVerse, QAfterSortBy> thenByTextTelugu() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'textTelugu', Sort.asc);
    });
  }

  QueryBuilder<BibleVerse, BibleVerse, QAfterSortBy> thenByTextTeluguDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'textTelugu', Sort.desc);
    });
  }

  QueryBuilder<BibleVerse, BibleVerse, QAfterSortBy> thenByVerseNumber() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'verseNumber', Sort.asc);
    });
  }

  QueryBuilder<BibleVerse, BibleVerse, QAfterSortBy> thenByVerseNumberDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'verseNumber', Sort.desc);
    });
  }
}

extension BibleVerseQueryWhereDistinct
    on QueryBuilder<BibleVerse, BibleVerse, QDistinct> {
  QueryBuilder<BibleVerse, BibleVerse, QDistinct> distinctByBookName(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'bookName', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<BibleVerse, BibleVerse, QDistinct> distinctByChapter() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'chapter');
    });
  }

  QueryBuilder<BibleVerse, BibleVerse, QDistinct> distinctByTextEnglish(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'textEnglish', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<BibleVerse, BibleVerse, QDistinct> distinctByTextTelugu(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'textTelugu', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<BibleVerse, BibleVerse, QDistinct> distinctByVerseNumber() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'verseNumber');
    });
  }
}

extension BibleVerseQueryProperty
    on QueryBuilder<BibleVerse, BibleVerse, QQueryProperty> {
  QueryBuilder<BibleVerse, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<BibleVerse, String, QQueryOperations> bookNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'bookName');
    });
  }

  QueryBuilder<BibleVerse, int, QQueryOperations> chapterProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'chapter');
    });
  }

  QueryBuilder<BibleVerse, String, QQueryOperations> textEnglishProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'textEnglish');
    });
  }

  QueryBuilder<BibleVerse, String?, QQueryOperations> textTeluguProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'textTelugu');
    });
  }

  QueryBuilder<BibleVerse, int, QQueryOperations> verseNumberProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'verseNumber');
    });
  }
}
