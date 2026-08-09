// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'isar_models.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetSavedVerseCollection on Isar {
  IsarCollection<SavedVerse> get savedVerses => this.collection();
}

const SavedVerseSchema = CollectionSchema(
  name: r'SavedVerse',
  id: 5965722565964875244,
  properties: {
    r'book': PropertySchema(
      id: 0,
      name: r'book',
      type: IsarType.string,
    ),
    r'chapter': PropertySchema(
      id: 1,
      name: r'chapter',
      type: IsarType.long,
    ),
    r'isBookmark': PropertySchema(
      id: 2,
      name: r'isBookmark',
      type: IsarType.bool,
    ),
    r'noteText': PropertySchema(
      id: 3,
      name: r'noteText',
      type: IsarType.string,
    ),
    r'verseIndex': PropertySchema(
      id: 4,
      name: r'verseIndex',
      type: IsarType.long,
    )
  },
  estimateSize: _savedVerseEstimateSize,
  serialize: _savedVerseSerialize,
  deserialize: _savedVerseDeserialize,
  deserializeProp: _savedVerseDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _savedVerseGetId,
  getLinks: _savedVerseGetLinks,
  attach: _savedVerseAttach,
  version: '3.3.2',
);

int _savedVerseEstimateSize(
  SavedVerse object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.book.length * 3;
  {
    final value = object.noteText;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  return bytesCount;
}

void _savedVerseSerialize(
  SavedVerse object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.book);
  writer.writeLong(offsets[1], object.chapter);
  writer.writeBool(offsets[2], object.isBookmark);
  writer.writeString(offsets[3], object.noteText);
  writer.writeLong(offsets[4], object.verseIndex);
}

SavedVerse _savedVerseDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = SavedVerse();
  object.book = reader.readString(offsets[0]);
  object.chapter = reader.readLong(offsets[1]);
  object.id = id;
  object.isBookmark = reader.readBool(offsets[2]);
  object.noteText = reader.readStringOrNull(offsets[3]);
  object.verseIndex = reader.readLong(offsets[4]);
  return object;
}

P _savedVerseDeserializeProp<P>(
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
      return (reader.readBool(offset)) as P;
    case 3:
      return (reader.readStringOrNull(offset)) as P;
    case 4:
      return (reader.readLong(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _savedVerseGetId(SavedVerse object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _savedVerseGetLinks(SavedVerse object) {
  return [];
}

void _savedVerseAttach(IsarCollection<dynamic> col, Id id, SavedVerse object) {
  object.id = id;
}

extension SavedVerseQueryWhereSort
    on QueryBuilder<SavedVerse, SavedVerse, QWhere> {
  QueryBuilder<SavedVerse, SavedVerse, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension SavedVerseQueryWhere
    on QueryBuilder<SavedVerse, SavedVerse, QWhereClause> {
  QueryBuilder<SavedVerse, SavedVerse, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<SavedVerse, SavedVerse, QAfterWhereClause> idNotEqualTo(Id id) {
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

  QueryBuilder<SavedVerse, SavedVerse, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<SavedVerse, SavedVerse, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<SavedVerse, SavedVerse, QAfterWhereClause> idBetween(
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
}

extension SavedVerseQueryFilter
    on QueryBuilder<SavedVerse, SavedVerse, QFilterCondition> {
  QueryBuilder<SavedVerse, SavedVerse, QAfterFilterCondition> bookEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'book',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SavedVerse, SavedVerse, QAfterFilterCondition> bookGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'book',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SavedVerse, SavedVerse, QAfterFilterCondition> bookLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'book',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SavedVerse, SavedVerse, QAfterFilterCondition> bookBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'book',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SavedVerse, SavedVerse, QAfterFilterCondition> bookStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'book',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SavedVerse, SavedVerse, QAfterFilterCondition> bookEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'book',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SavedVerse, SavedVerse, QAfterFilterCondition> bookContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'book',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SavedVerse, SavedVerse, QAfterFilterCondition> bookMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'book',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SavedVerse, SavedVerse, QAfterFilterCondition> bookIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'book',
        value: '',
      ));
    });
  }

  QueryBuilder<SavedVerse, SavedVerse, QAfterFilterCondition> bookIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'book',
        value: '',
      ));
    });
  }

  QueryBuilder<SavedVerse, SavedVerse, QAfterFilterCondition> chapterEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'chapter',
        value: value,
      ));
    });
  }

  QueryBuilder<SavedVerse, SavedVerse, QAfterFilterCondition>
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

  QueryBuilder<SavedVerse, SavedVerse, QAfterFilterCondition> chapterLessThan(
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

  QueryBuilder<SavedVerse, SavedVerse, QAfterFilterCondition> chapterBetween(
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

  QueryBuilder<SavedVerse, SavedVerse, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<SavedVerse, SavedVerse, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<SavedVerse, SavedVerse, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<SavedVerse, SavedVerse, QAfterFilterCondition> idBetween(
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

  QueryBuilder<SavedVerse, SavedVerse, QAfterFilterCondition> isBookmarkEqualTo(
      bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isBookmark',
        value: value,
      ));
    });
  }

  QueryBuilder<SavedVerse, SavedVerse, QAfterFilterCondition> noteTextIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'noteText',
      ));
    });
  }

  QueryBuilder<SavedVerse, SavedVerse, QAfterFilterCondition>
      noteTextIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'noteText',
      ));
    });
  }

  QueryBuilder<SavedVerse, SavedVerse, QAfterFilterCondition> noteTextEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'noteText',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SavedVerse, SavedVerse, QAfterFilterCondition>
      noteTextGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'noteText',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SavedVerse, SavedVerse, QAfterFilterCondition> noteTextLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'noteText',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SavedVerse, SavedVerse, QAfterFilterCondition> noteTextBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'noteText',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SavedVerse, SavedVerse, QAfterFilterCondition>
      noteTextStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'noteText',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SavedVerse, SavedVerse, QAfterFilterCondition> noteTextEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'noteText',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SavedVerse, SavedVerse, QAfterFilterCondition> noteTextContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'noteText',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SavedVerse, SavedVerse, QAfterFilterCondition> noteTextMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'noteText',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SavedVerse, SavedVerse, QAfterFilterCondition>
      noteTextIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'noteText',
        value: '',
      ));
    });
  }

  QueryBuilder<SavedVerse, SavedVerse, QAfterFilterCondition>
      noteTextIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'noteText',
        value: '',
      ));
    });
  }

  QueryBuilder<SavedVerse, SavedVerse, QAfterFilterCondition> verseIndexEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'verseIndex',
        value: value,
      ));
    });
  }

  QueryBuilder<SavedVerse, SavedVerse, QAfterFilterCondition>
      verseIndexGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'verseIndex',
        value: value,
      ));
    });
  }

  QueryBuilder<SavedVerse, SavedVerse, QAfterFilterCondition>
      verseIndexLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'verseIndex',
        value: value,
      ));
    });
  }

  QueryBuilder<SavedVerse, SavedVerse, QAfterFilterCondition> verseIndexBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'verseIndex',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension SavedVerseQueryObject
    on QueryBuilder<SavedVerse, SavedVerse, QFilterCondition> {}

extension SavedVerseQueryLinks
    on QueryBuilder<SavedVerse, SavedVerse, QFilterCondition> {}

extension SavedVerseQuerySortBy
    on QueryBuilder<SavedVerse, SavedVerse, QSortBy> {
  QueryBuilder<SavedVerse, SavedVerse, QAfterSortBy> sortByBook() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'book', Sort.asc);
    });
  }

  QueryBuilder<SavedVerse, SavedVerse, QAfterSortBy> sortByBookDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'book', Sort.desc);
    });
  }

  QueryBuilder<SavedVerse, SavedVerse, QAfterSortBy> sortByChapter() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'chapter', Sort.asc);
    });
  }

  QueryBuilder<SavedVerse, SavedVerse, QAfterSortBy> sortByChapterDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'chapter', Sort.desc);
    });
  }

  QueryBuilder<SavedVerse, SavedVerse, QAfterSortBy> sortByIsBookmark() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isBookmark', Sort.asc);
    });
  }

  QueryBuilder<SavedVerse, SavedVerse, QAfterSortBy> sortByIsBookmarkDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isBookmark', Sort.desc);
    });
  }

  QueryBuilder<SavedVerse, SavedVerse, QAfterSortBy> sortByNoteText() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'noteText', Sort.asc);
    });
  }

  QueryBuilder<SavedVerse, SavedVerse, QAfterSortBy> sortByNoteTextDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'noteText', Sort.desc);
    });
  }

  QueryBuilder<SavedVerse, SavedVerse, QAfterSortBy> sortByVerseIndex() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'verseIndex', Sort.asc);
    });
  }

  QueryBuilder<SavedVerse, SavedVerse, QAfterSortBy> sortByVerseIndexDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'verseIndex', Sort.desc);
    });
  }
}

extension SavedVerseQuerySortThenBy
    on QueryBuilder<SavedVerse, SavedVerse, QSortThenBy> {
  QueryBuilder<SavedVerse, SavedVerse, QAfterSortBy> thenByBook() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'book', Sort.asc);
    });
  }

  QueryBuilder<SavedVerse, SavedVerse, QAfterSortBy> thenByBookDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'book', Sort.desc);
    });
  }

  QueryBuilder<SavedVerse, SavedVerse, QAfterSortBy> thenByChapter() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'chapter', Sort.asc);
    });
  }

  QueryBuilder<SavedVerse, SavedVerse, QAfterSortBy> thenByChapterDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'chapter', Sort.desc);
    });
  }

  QueryBuilder<SavedVerse, SavedVerse, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<SavedVerse, SavedVerse, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<SavedVerse, SavedVerse, QAfterSortBy> thenByIsBookmark() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isBookmark', Sort.asc);
    });
  }

  QueryBuilder<SavedVerse, SavedVerse, QAfterSortBy> thenByIsBookmarkDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isBookmark', Sort.desc);
    });
  }

  QueryBuilder<SavedVerse, SavedVerse, QAfterSortBy> thenByNoteText() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'noteText', Sort.asc);
    });
  }

  QueryBuilder<SavedVerse, SavedVerse, QAfterSortBy> thenByNoteTextDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'noteText', Sort.desc);
    });
  }

  QueryBuilder<SavedVerse, SavedVerse, QAfterSortBy> thenByVerseIndex() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'verseIndex', Sort.asc);
    });
  }

  QueryBuilder<SavedVerse, SavedVerse, QAfterSortBy> thenByVerseIndexDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'verseIndex', Sort.desc);
    });
  }
}

extension SavedVerseQueryWhereDistinct
    on QueryBuilder<SavedVerse, SavedVerse, QDistinct> {
  QueryBuilder<SavedVerse, SavedVerse, QDistinct> distinctByBook(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'book', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<SavedVerse, SavedVerse, QDistinct> distinctByChapter() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'chapter');
    });
  }

  QueryBuilder<SavedVerse, SavedVerse, QDistinct> distinctByIsBookmark() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isBookmark');
    });
  }

  QueryBuilder<SavedVerse, SavedVerse, QDistinct> distinctByNoteText(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'noteText', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<SavedVerse, SavedVerse, QDistinct> distinctByVerseIndex() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'verseIndex');
    });
  }
}

extension SavedVerseQueryProperty
    on QueryBuilder<SavedVerse, SavedVerse, QQueryProperty> {
  QueryBuilder<SavedVerse, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<SavedVerse, String, QQueryOperations> bookProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'book');
    });
  }

  QueryBuilder<SavedVerse, int, QQueryOperations> chapterProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'chapter');
    });
  }

  QueryBuilder<SavedVerse, bool, QQueryOperations> isBookmarkProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isBookmark');
    });
  }

  QueryBuilder<SavedVerse, String?, QQueryOperations> noteTextProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'noteText');
    });
  }

  QueryBuilder<SavedVerse, int, QQueryOperations> verseIndexProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'verseIndex');
    });
  }
}
