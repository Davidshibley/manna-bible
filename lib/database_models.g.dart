// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database_models.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetVerseCollection on Isar {
  IsarCollection<Verse> get verses => this.collection();
}

const VerseSchema = CollectionSchema(
  name: r'Verse',
  id: 6982547837312371642,
  properties: {
    r'bookName': PropertySchema(
      id: 0,
      name: r'bookName',
      type: IsarType.string,
    ),
    r'chapter': PropertySchema(
      id: 1,
      name: r'chapter',
      type: IsarType.int,
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
    r'verseIdKey': PropertySchema(
      id: 4,
      name: r'verseIdKey',
      type: IsarType.string,
    ),
    r'verseNumber': PropertySchema(
      id: 5,
      name: r'verseNumber',
      type: IsarType.int,
    )
  },
  estimateSize: _verseEstimateSize,
  serialize: _verseSerialize,
  deserialize: _verseDeserialize,
  deserializeProp: _verseDeserializeProp,
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
    ),
    r'textEnglish': IndexSchema(
      id: 3415635409106642539,
      name: r'textEnglish',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'textEnglish',
          type: IndexType.value,
          caseSensitive: true,
        )
      ],
    ),
    r'textTelugu': IndexSchema(
      id: 3327250851289813695,
      name: r'textTelugu',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'textTelugu',
          type: IndexType.value,
          caseSensitive: true,
        )
      ],
    ),
    r'verseIdKey': IndexSchema(
      id: 8455254937046294424,
      name: r'verseIdKey',
      unique: true,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'verseIdKey',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _verseGetId,
  getLinks: _verseGetLinks,
  attach: _verseAttach,
  version: '3.3.2',
);

int _verseEstimateSize(
  Verse object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.bookName.length * 3;
  bytesCount += 3 + object.textEnglish.length * 3;
  bytesCount += 3 + object.textTelugu.length * 3;
  bytesCount += 3 + object.verseIdKey.length * 3;
  return bytesCount;
}

void _verseSerialize(
  Verse object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.bookName);
  writer.writeInt(offsets[1], object.chapter);
  writer.writeString(offsets[2], object.textEnglish);
  writer.writeString(offsets[3], object.textTelugu);
  writer.writeString(offsets[4], object.verseIdKey);
  writer.writeInt(offsets[5], object.verseNumber);
}

Verse _verseDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = Verse();
  object.bookName = reader.readString(offsets[0]);
  object.chapter = reader.readInt(offsets[1]);
  object.id = id;
  object.textEnglish = reader.readString(offsets[2]);
  object.textTelugu = reader.readString(offsets[3]);
  object.verseIdKey = reader.readString(offsets[4]);
  object.verseNumber = reader.readInt(offsets[5]);
  return object;
}

P _verseDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readString(offset)) as P;
    case 1:
      return (reader.readInt(offset)) as P;
    case 2:
      return (reader.readString(offset)) as P;
    case 3:
      return (reader.readString(offset)) as P;
    case 4:
      return (reader.readString(offset)) as P;
    case 5:
      return (reader.readInt(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _verseGetId(Verse object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _verseGetLinks(Verse object) {
  return [];
}

void _verseAttach(IsarCollection<dynamic> col, Id id, Verse object) {
  object.id = id;
}

extension VerseByIndex on IsarCollection<Verse> {
  Future<Verse?> getByVerseIdKey(String verseIdKey) {
    return getByIndex(r'verseIdKey', [verseIdKey]);
  }

  Verse? getByVerseIdKeySync(String verseIdKey) {
    return getByIndexSync(r'verseIdKey', [verseIdKey]);
  }

  Future<bool> deleteByVerseIdKey(String verseIdKey) {
    return deleteByIndex(r'verseIdKey', [verseIdKey]);
  }

  bool deleteByVerseIdKeySync(String verseIdKey) {
    return deleteByIndexSync(r'verseIdKey', [verseIdKey]);
  }

  Future<List<Verse?>> getAllByVerseIdKey(List<String> verseIdKeyValues) {
    final values = verseIdKeyValues.map((e) => [e]).toList();
    return getAllByIndex(r'verseIdKey', values);
  }

  List<Verse?> getAllByVerseIdKeySync(List<String> verseIdKeyValues) {
    final values = verseIdKeyValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'verseIdKey', values);
  }

  Future<int> deleteAllByVerseIdKey(List<String> verseIdKeyValues) {
    final values = verseIdKeyValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'verseIdKey', values);
  }

  int deleteAllByVerseIdKeySync(List<String> verseIdKeyValues) {
    final values = verseIdKeyValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'verseIdKey', values);
  }

  Future<Id> putByVerseIdKey(Verse object) {
    return putByIndex(r'verseIdKey', object);
  }

  Id putByVerseIdKeySync(Verse object, {bool saveLinks = true}) {
    return putByIndexSync(r'verseIdKey', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByVerseIdKey(List<Verse> objects) {
    return putAllByIndex(r'verseIdKey', objects);
  }

  List<Id> putAllByVerseIdKeySync(List<Verse> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'verseIdKey', objects, saveLinks: saveLinks);
  }
}

extension VerseQueryWhereSort on QueryBuilder<Verse, Verse, QWhere> {
  QueryBuilder<Verse, Verse, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<Verse, Verse, QAfterWhere> anyBookName() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'bookName'),
      );
    });
  }

  QueryBuilder<Verse, Verse, QAfterWhere> anyChapter() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'chapter'),
      );
    });
  }

  QueryBuilder<Verse, Verse, QAfterWhere> anyTextEnglish() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'textEnglish'),
      );
    });
  }

  QueryBuilder<Verse, Verse, QAfterWhere> anyTextTelugu() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'textTelugu'),
      );
    });
  }
}

extension VerseQueryWhere on QueryBuilder<Verse, Verse, QWhereClause> {
  QueryBuilder<Verse, Verse, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<Verse, Verse, QAfterWhereClause> idNotEqualTo(Id id) {
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

  QueryBuilder<Verse, Verse, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<Verse, Verse, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<Verse, Verse, QAfterWhereClause> idBetween(
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

  QueryBuilder<Verse, Verse, QAfterWhereClause> bookNameEqualTo(
      String bookName) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'bookName',
        value: [bookName],
      ));
    });
  }

  QueryBuilder<Verse, Verse, QAfterWhereClause> bookNameNotEqualTo(
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

  QueryBuilder<Verse, Verse, QAfterWhereClause> bookNameGreaterThan(
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

  QueryBuilder<Verse, Verse, QAfterWhereClause> bookNameLessThan(
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

  QueryBuilder<Verse, Verse, QAfterWhereClause> bookNameBetween(
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

  QueryBuilder<Verse, Verse, QAfterWhereClause> bookNameStartsWith(
      String BookNamePrefix) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'bookName',
        lower: [BookNamePrefix],
        upper: ['$BookNamePrefix\u{FFFFF}'],
      ));
    });
  }

  QueryBuilder<Verse, Verse, QAfterWhereClause> bookNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'bookName',
        value: [''],
      ));
    });
  }

  QueryBuilder<Verse, Verse, QAfterWhereClause> bookNameIsNotEmpty() {
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

  QueryBuilder<Verse, Verse, QAfterWhereClause> chapterEqualTo(int chapter) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'chapter',
        value: [chapter],
      ));
    });
  }

  QueryBuilder<Verse, Verse, QAfterWhereClause> chapterNotEqualTo(int chapter) {
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

  QueryBuilder<Verse, Verse, QAfterWhereClause> chapterGreaterThan(
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

  QueryBuilder<Verse, Verse, QAfterWhereClause> chapterLessThan(
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

  QueryBuilder<Verse, Verse, QAfterWhereClause> chapterBetween(
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

  QueryBuilder<Verse, Verse, QAfterWhereClause> textEnglishEqualTo(
      String textEnglish) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'textEnglish',
        value: [textEnglish],
      ));
    });
  }

  QueryBuilder<Verse, Verse, QAfterWhereClause> textEnglishNotEqualTo(
      String textEnglish) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'textEnglish',
              lower: [],
              upper: [textEnglish],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'textEnglish',
              lower: [textEnglish],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'textEnglish',
              lower: [textEnglish],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'textEnglish',
              lower: [],
              upper: [textEnglish],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<Verse, Verse, QAfterWhereClause> textEnglishGreaterThan(
    String textEnglish, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'textEnglish',
        lower: [textEnglish],
        includeLower: include,
        upper: [],
      ));
    });
  }

  QueryBuilder<Verse, Verse, QAfterWhereClause> textEnglishLessThan(
    String textEnglish, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'textEnglish',
        lower: [],
        upper: [textEnglish],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<Verse, Verse, QAfterWhereClause> textEnglishBetween(
    String lowerTextEnglish,
    String upperTextEnglish, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'textEnglish',
        lower: [lowerTextEnglish],
        includeLower: includeLower,
        upper: [upperTextEnglish],
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Verse, Verse, QAfterWhereClause> textEnglishStartsWith(
      String TextEnglishPrefix) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'textEnglish',
        lower: [TextEnglishPrefix],
        upper: ['$TextEnglishPrefix\u{FFFFF}'],
      ));
    });
  }

  QueryBuilder<Verse, Verse, QAfterWhereClause> textEnglishIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'textEnglish',
        value: [''],
      ));
    });
  }

  QueryBuilder<Verse, Verse, QAfterWhereClause> textEnglishIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.lessThan(
              indexName: r'textEnglish',
              upper: [''],
            ))
            .addWhereClause(IndexWhereClause.greaterThan(
              indexName: r'textEnglish',
              lower: [''],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.greaterThan(
              indexName: r'textEnglish',
              lower: [''],
            ))
            .addWhereClause(IndexWhereClause.lessThan(
              indexName: r'textEnglish',
              upper: [''],
            ));
      }
    });
  }

  QueryBuilder<Verse, Verse, QAfterWhereClause> textTeluguEqualTo(
      String textTelugu) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'textTelugu',
        value: [textTelugu],
      ));
    });
  }

  QueryBuilder<Verse, Verse, QAfterWhereClause> textTeluguNotEqualTo(
      String textTelugu) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'textTelugu',
              lower: [],
              upper: [textTelugu],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'textTelugu',
              lower: [textTelugu],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'textTelugu',
              lower: [textTelugu],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'textTelugu',
              lower: [],
              upper: [textTelugu],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<Verse, Verse, QAfterWhereClause> textTeluguGreaterThan(
    String textTelugu, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'textTelugu',
        lower: [textTelugu],
        includeLower: include,
        upper: [],
      ));
    });
  }

  QueryBuilder<Verse, Verse, QAfterWhereClause> textTeluguLessThan(
    String textTelugu, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'textTelugu',
        lower: [],
        upper: [textTelugu],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<Verse, Verse, QAfterWhereClause> textTeluguBetween(
    String lowerTextTelugu,
    String upperTextTelugu, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'textTelugu',
        lower: [lowerTextTelugu],
        includeLower: includeLower,
        upper: [upperTextTelugu],
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Verse, Verse, QAfterWhereClause> textTeluguStartsWith(
      String TextTeluguPrefix) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'textTelugu',
        lower: [TextTeluguPrefix],
        upper: ['$TextTeluguPrefix\u{FFFFF}'],
      ));
    });
  }

  QueryBuilder<Verse, Verse, QAfterWhereClause> textTeluguIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'textTelugu',
        value: [''],
      ));
    });
  }

  QueryBuilder<Verse, Verse, QAfterWhereClause> textTeluguIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.lessThan(
              indexName: r'textTelugu',
              upper: [''],
            ))
            .addWhereClause(IndexWhereClause.greaterThan(
              indexName: r'textTelugu',
              lower: [''],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.greaterThan(
              indexName: r'textTelugu',
              lower: [''],
            ))
            .addWhereClause(IndexWhereClause.lessThan(
              indexName: r'textTelugu',
              upper: [''],
            ));
      }
    });
  }

  QueryBuilder<Verse, Verse, QAfterWhereClause> verseIdKeyEqualTo(
      String verseIdKey) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'verseIdKey',
        value: [verseIdKey],
      ));
    });
  }

  QueryBuilder<Verse, Verse, QAfterWhereClause> verseIdKeyNotEqualTo(
      String verseIdKey) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'verseIdKey',
              lower: [],
              upper: [verseIdKey],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'verseIdKey',
              lower: [verseIdKey],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'verseIdKey',
              lower: [verseIdKey],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'verseIdKey',
              lower: [],
              upper: [verseIdKey],
              includeUpper: false,
            ));
      }
    });
  }
}

extension VerseQueryFilter on QueryBuilder<Verse, Verse, QFilterCondition> {
  QueryBuilder<Verse, Verse, QAfterFilterCondition> bookNameEqualTo(
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

  QueryBuilder<Verse, Verse, QAfterFilterCondition> bookNameGreaterThan(
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

  QueryBuilder<Verse, Verse, QAfterFilterCondition> bookNameLessThan(
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

  QueryBuilder<Verse, Verse, QAfterFilterCondition> bookNameBetween(
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

  QueryBuilder<Verse, Verse, QAfterFilterCondition> bookNameStartsWith(
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

  QueryBuilder<Verse, Verse, QAfterFilterCondition> bookNameEndsWith(
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

  QueryBuilder<Verse, Verse, QAfterFilterCondition> bookNameContains(
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

  QueryBuilder<Verse, Verse, QAfterFilterCondition> bookNameMatches(
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

  QueryBuilder<Verse, Verse, QAfterFilterCondition> bookNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'bookName',
        value: '',
      ));
    });
  }

  QueryBuilder<Verse, Verse, QAfterFilterCondition> bookNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'bookName',
        value: '',
      ));
    });
  }

  QueryBuilder<Verse, Verse, QAfterFilterCondition> chapterEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'chapter',
        value: value,
      ));
    });
  }

  QueryBuilder<Verse, Verse, QAfterFilterCondition> chapterGreaterThan(
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

  QueryBuilder<Verse, Verse, QAfterFilterCondition> chapterLessThan(
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

  QueryBuilder<Verse, Verse, QAfterFilterCondition> chapterBetween(
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

  QueryBuilder<Verse, Verse, QAfterFilterCondition> idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<Verse, Verse, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<Verse, Verse, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<Verse, Verse, QAfterFilterCondition> idBetween(
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

  QueryBuilder<Verse, Verse, QAfterFilterCondition> textEnglishEqualTo(
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

  QueryBuilder<Verse, Verse, QAfterFilterCondition> textEnglishGreaterThan(
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

  QueryBuilder<Verse, Verse, QAfterFilterCondition> textEnglishLessThan(
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

  QueryBuilder<Verse, Verse, QAfterFilterCondition> textEnglishBetween(
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

  QueryBuilder<Verse, Verse, QAfterFilterCondition> textEnglishStartsWith(
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

  QueryBuilder<Verse, Verse, QAfterFilterCondition> textEnglishEndsWith(
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

  QueryBuilder<Verse, Verse, QAfterFilterCondition> textEnglishContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'textEnglish',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Verse, Verse, QAfterFilterCondition> textEnglishMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'textEnglish',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Verse, Verse, QAfterFilterCondition> textEnglishIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'textEnglish',
        value: '',
      ));
    });
  }

  QueryBuilder<Verse, Verse, QAfterFilterCondition> textEnglishIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'textEnglish',
        value: '',
      ));
    });
  }

  QueryBuilder<Verse, Verse, QAfterFilterCondition> textTeluguEqualTo(
    String value, {
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

  QueryBuilder<Verse, Verse, QAfterFilterCondition> textTeluguGreaterThan(
    String value, {
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

  QueryBuilder<Verse, Verse, QAfterFilterCondition> textTeluguLessThan(
    String value, {
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

  QueryBuilder<Verse, Verse, QAfterFilterCondition> textTeluguBetween(
    String lower,
    String upper, {
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

  QueryBuilder<Verse, Verse, QAfterFilterCondition> textTeluguStartsWith(
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

  QueryBuilder<Verse, Verse, QAfterFilterCondition> textTeluguEndsWith(
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

  QueryBuilder<Verse, Verse, QAfterFilterCondition> textTeluguContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'textTelugu',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Verse, Verse, QAfterFilterCondition> textTeluguMatches(
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

  QueryBuilder<Verse, Verse, QAfterFilterCondition> textTeluguIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'textTelugu',
        value: '',
      ));
    });
  }

  QueryBuilder<Verse, Verse, QAfterFilterCondition> textTeluguIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'textTelugu',
        value: '',
      ));
    });
  }

  QueryBuilder<Verse, Verse, QAfterFilterCondition> verseIdKeyEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'verseIdKey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Verse, Verse, QAfterFilterCondition> verseIdKeyGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'verseIdKey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Verse, Verse, QAfterFilterCondition> verseIdKeyLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'verseIdKey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Verse, Verse, QAfterFilterCondition> verseIdKeyBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'verseIdKey',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Verse, Verse, QAfterFilterCondition> verseIdKeyStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'verseIdKey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Verse, Verse, QAfterFilterCondition> verseIdKeyEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'verseIdKey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Verse, Verse, QAfterFilterCondition> verseIdKeyContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'verseIdKey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Verse, Verse, QAfterFilterCondition> verseIdKeyMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'verseIdKey',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Verse, Verse, QAfterFilterCondition> verseIdKeyIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'verseIdKey',
        value: '',
      ));
    });
  }

  QueryBuilder<Verse, Verse, QAfterFilterCondition> verseIdKeyIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'verseIdKey',
        value: '',
      ));
    });
  }

  QueryBuilder<Verse, Verse, QAfterFilterCondition> verseNumberEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'verseNumber',
        value: value,
      ));
    });
  }

  QueryBuilder<Verse, Verse, QAfterFilterCondition> verseNumberGreaterThan(
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

  QueryBuilder<Verse, Verse, QAfterFilterCondition> verseNumberLessThan(
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

  QueryBuilder<Verse, Verse, QAfterFilterCondition> verseNumberBetween(
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

extension VerseQueryObject on QueryBuilder<Verse, Verse, QFilterCondition> {}

extension VerseQueryLinks on QueryBuilder<Verse, Verse, QFilterCondition> {}

extension VerseQuerySortBy on QueryBuilder<Verse, Verse, QSortBy> {
  QueryBuilder<Verse, Verse, QAfterSortBy> sortByBookName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bookName', Sort.asc);
    });
  }

  QueryBuilder<Verse, Verse, QAfterSortBy> sortByBookNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bookName', Sort.desc);
    });
  }

  QueryBuilder<Verse, Verse, QAfterSortBy> sortByChapter() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'chapter', Sort.asc);
    });
  }

  QueryBuilder<Verse, Verse, QAfterSortBy> sortByChapterDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'chapter', Sort.desc);
    });
  }

  QueryBuilder<Verse, Verse, QAfterSortBy> sortByTextEnglish() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'textEnglish', Sort.asc);
    });
  }

  QueryBuilder<Verse, Verse, QAfterSortBy> sortByTextEnglishDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'textEnglish', Sort.desc);
    });
  }

  QueryBuilder<Verse, Verse, QAfterSortBy> sortByTextTelugu() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'textTelugu', Sort.asc);
    });
  }

  QueryBuilder<Verse, Verse, QAfterSortBy> sortByTextTeluguDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'textTelugu', Sort.desc);
    });
  }

  QueryBuilder<Verse, Verse, QAfterSortBy> sortByVerseIdKey() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'verseIdKey', Sort.asc);
    });
  }

  QueryBuilder<Verse, Verse, QAfterSortBy> sortByVerseIdKeyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'verseIdKey', Sort.desc);
    });
  }

  QueryBuilder<Verse, Verse, QAfterSortBy> sortByVerseNumber() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'verseNumber', Sort.asc);
    });
  }

  QueryBuilder<Verse, Verse, QAfterSortBy> sortByVerseNumberDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'verseNumber', Sort.desc);
    });
  }
}

extension VerseQuerySortThenBy on QueryBuilder<Verse, Verse, QSortThenBy> {
  QueryBuilder<Verse, Verse, QAfterSortBy> thenByBookName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bookName', Sort.asc);
    });
  }

  QueryBuilder<Verse, Verse, QAfterSortBy> thenByBookNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bookName', Sort.desc);
    });
  }

  QueryBuilder<Verse, Verse, QAfterSortBy> thenByChapter() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'chapter', Sort.asc);
    });
  }

  QueryBuilder<Verse, Verse, QAfterSortBy> thenByChapterDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'chapter', Sort.desc);
    });
  }

  QueryBuilder<Verse, Verse, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<Verse, Verse, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<Verse, Verse, QAfterSortBy> thenByTextEnglish() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'textEnglish', Sort.asc);
    });
  }

  QueryBuilder<Verse, Verse, QAfterSortBy> thenByTextEnglishDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'textEnglish', Sort.desc);
    });
  }

  QueryBuilder<Verse, Verse, QAfterSortBy> thenByTextTelugu() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'textTelugu', Sort.asc);
    });
  }

  QueryBuilder<Verse, Verse, QAfterSortBy> thenByTextTeluguDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'textTelugu', Sort.desc);
    });
  }

  QueryBuilder<Verse, Verse, QAfterSortBy> thenByVerseIdKey() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'verseIdKey', Sort.asc);
    });
  }

  QueryBuilder<Verse, Verse, QAfterSortBy> thenByVerseIdKeyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'verseIdKey', Sort.desc);
    });
  }

  QueryBuilder<Verse, Verse, QAfterSortBy> thenByVerseNumber() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'verseNumber', Sort.asc);
    });
  }

  QueryBuilder<Verse, Verse, QAfterSortBy> thenByVerseNumberDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'verseNumber', Sort.desc);
    });
  }
}

extension VerseQueryWhereDistinct on QueryBuilder<Verse, Verse, QDistinct> {
  QueryBuilder<Verse, Verse, QDistinct> distinctByBookName(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'bookName', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Verse, Verse, QDistinct> distinctByChapter() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'chapter');
    });
  }

  QueryBuilder<Verse, Verse, QDistinct> distinctByTextEnglish(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'textEnglish', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Verse, Verse, QDistinct> distinctByTextTelugu(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'textTelugu', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Verse, Verse, QDistinct> distinctByVerseIdKey(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'verseIdKey', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Verse, Verse, QDistinct> distinctByVerseNumber() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'verseNumber');
    });
  }
}

extension VerseQueryProperty on QueryBuilder<Verse, Verse, QQueryProperty> {
  QueryBuilder<Verse, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<Verse, String, QQueryOperations> bookNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'bookName');
    });
  }

  QueryBuilder<Verse, int, QQueryOperations> chapterProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'chapter');
    });
  }

  QueryBuilder<Verse, String, QQueryOperations> textEnglishProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'textEnglish');
    });
  }

  QueryBuilder<Verse, String, QQueryOperations> textTeluguProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'textTelugu');
    });
  }

  QueryBuilder<Verse, String, QQueryOperations> verseIdKeyProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'verseIdKey');
    });
  }

  QueryBuilder<Verse, int, QQueryOperations> verseNumberProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'verseNumber');
    });
  }
}

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetUserVerseDataCollection on Isar {
  IsarCollection<UserVerseData> get userVerseDatas => this.collection();
}

const UserVerseDataSchema = CollectionSchema(
  name: r'UserVerseData',
  id: -5703728178457124798,
  properties: {
    r'highlightColorHex': PropertySchema(
      id: 0,
      name: r'highlightColorHex',
      type: IsarType.string,
    ),
    r'isBookmarked': PropertySchema(
      id: 1,
      name: r'isBookmarked',
      type: IsarType.bool,
    ),
    r'noteText': PropertySchema(
      id: 2,
      name: r'noteText',
      type: IsarType.string,
    ),
    r'updatedAt': PropertySchema(
      id: 3,
      name: r'updatedAt',
      type: IsarType.dateTime,
    ),
    r'verseIdKey': PropertySchema(
      id: 4,
      name: r'verseIdKey',
      type: IsarType.string,
    )
  },
  estimateSize: _userVerseDataEstimateSize,
  serialize: _userVerseDataSerialize,
  deserialize: _userVerseDataDeserialize,
  deserializeProp: _userVerseDataDeserializeProp,
  idName: r'id',
  indexes: {
    r'verseIdKey': IndexSchema(
      id: 8455254937046294424,
      name: r'verseIdKey',
      unique: true,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'verseIdKey',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _userVerseDataGetId,
  getLinks: _userVerseDataGetLinks,
  attach: _userVerseDataAttach,
  version: '3.3.2',
);

int _userVerseDataEstimateSize(
  UserVerseData object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.highlightColorHex;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.noteText;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.verseIdKey.length * 3;
  return bytesCount;
}

void _userVerseDataSerialize(
  UserVerseData object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.highlightColorHex);
  writer.writeBool(offsets[1], object.isBookmarked);
  writer.writeString(offsets[2], object.noteText);
  writer.writeDateTime(offsets[3], object.updatedAt);
  writer.writeString(offsets[4], object.verseIdKey);
}

UserVerseData _userVerseDataDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = UserVerseData();
  object.highlightColorHex = reader.readStringOrNull(offsets[0]);
  object.id = id;
  object.isBookmarked = reader.readBool(offsets[1]);
  object.noteText = reader.readStringOrNull(offsets[2]);
  object.updatedAt = reader.readDateTime(offsets[3]);
  object.verseIdKey = reader.readString(offsets[4]);
  return object;
}

P _userVerseDataDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readStringOrNull(offset)) as P;
    case 1:
      return (reader.readBool(offset)) as P;
    case 2:
      return (reader.readStringOrNull(offset)) as P;
    case 3:
      return (reader.readDateTime(offset)) as P;
    case 4:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _userVerseDataGetId(UserVerseData object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _userVerseDataGetLinks(UserVerseData object) {
  return [];
}

void _userVerseDataAttach(
    IsarCollection<dynamic> col, Id id, UserVerseData object) {
  object.id = id;
}

extension UserVerseDataByIndex on IsarCollection<UserVerseData> {
  Future<UserVerseData?> getByVerseIdKey(String verseIdKey) {
    return getByIndex(r'verseIdKey', [verseIdKey]);
  }

  UserVerseData? getByVerseIdKeySync(String verseIdKey) {
    return getByIndexSync(r'verseIdKey', [verseIdKey]);
  }

  Future<bool> deleteByVerseIdKey(String verseIdKey) {
    return deleteByIndex(r'verseIdKey', [verseIdKey]);
  }

  bool deleteByVerseIdKeySync(String verseIdKey) {
    return deleteByIndexSync(r'verseIdKey', [verseIdKey]);
  }

  Future<List<UserVerseData?>> getAllByVerseIdKey(
      List<String> verseIdKeyValues) {
    final values = verseIdKeyValues.map((e) => [e]).toList();
    return getAllByIndex(r'verseIdKey', values);
  }

  List<UserVerseData?> getAllByVerseIdKeySync(List<String> verseIdKeyValues) {
    final values = verseIdKeyValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'verseIdKey', values);
  }

  Future<int> deleteAllByVerseIdKey(List<String> verseIdKeyValues) {
    final values = verseIdKeyValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'verseIdKey', values);
  }

  int deleteAllByVerseIdKeySync(List<String> verseIdKeyValues) {
    final values = verseIdKeyValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'verseIdKey', values);
  }

  Future<Id> putByVerseIdKey(UserVerseData object) {
    return putByIndex(r'verseIdKey', object);
  }

  Id putByVerseIdKeySync(UserVerseData object, {bool saveLinks = true}) {
    return putByIndexSync(r'verseIdKey', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByVerseIdKey(List<UserVerseData> objects) {
    return putAllByIndex(r'verseIdKey', objects);
  }

  List<Id> putAllByVerseIdKeySync(List<UserVerseData> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'verseIdKey', objects, saveLinks: saveLinks);
  }
}

extension UserVerseDataQueryWhereSort
    on QueryBuilder<UserVerseData, UserVerseData, QWhere> {
  QueryBuilder<UserVerseData, UserVerseData, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension UserVerseDataQueryWhere
    on QueryBuilder<UserVerseData, UserVerseData, QWhereClause> {
  QueryBuilder<UserVerseData, UserVerseData, QAfterWhereClause> idEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<UserVerseData, UserVerseData, QAfterWhereClause> idNotEqualTo(
      Id id) {
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

  QueryBuilder<UserVerseData, UserVerseData, QAfterWhereClause> idGreaterThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<UserVerseData, UserVerseData, QAfterWhereClause> idLessThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<UserVerseData, UserVerseData, QAfterWhereClause> idBetween(
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

  QueryBuilder<UserVerseData, UserVerseData, QAfterWhereClause>
      verseIdKeyEqualTo(String verseIdKey) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'verseIdKey',
        value: [verseIdKey],
      ));
    });
  }

  QueryBuilder<UserVerseData, UserVerseData, QAfterWhereClause>
      verseIdKeyNotEqualTo(String verseIdKey) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'verseIdKey',
              lower: [],
              upper: [verseIdKey],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'verseIdKey',
              lower: [verseIdKey],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'verseIdKey',
              lower: [verseIdKey],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'verseIdKey',
              lower: [],
              upper: [verseIdKey],
              includeUpper: false,
            ));
      }
    });
  }
}

extension UserVerseDataQueryFilter
    on QueryBuilder<UserVerseData, UserVerseData, QFilterCondition> {
  QueryBuilder<UserVerseData, UserVerseData, QAfterFilterCondition>
      highlightColorHexIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'highlightColorHex',
      ));
    });
  }

  QueryBuilder<UserVerseData, UserVerseData, QAfterFilterCondition>
      highlightColorHexIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'highlightColorHex',
      ));
    });
  }

  QueryBuilder<UserVerseData, UserVerseData, QAfterFilterCondition>
      highlightColorHexEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'highlightColorHex',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserVerseData, UserVerseData, QAfterFilterCondition>
      highlightColorHexGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'highlightColorHex',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserVerseData, UserVerseData, QAfterFilterCondition>
      highlightColorHexLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'highlightColorHex',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserVerseData, UserVerseData, QAfterFilterCondition>
      highlightColorHexBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'highlightColorHex',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserVerseData, UserVerseData, QAfterFilterCondition>
      highlightColorHexStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'highlightColorHex',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserVerseData, UserVerseData, QAfterFilterCondition>
      highlightColorHexEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'highlightColorHex',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserVerseData, UserVerseData, QAfterFilterCondition>
      highlightColorHexContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'highlightColorHex',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserVerseData, UserVerseData, QAfterFilterCondition>
      highlightColorHexMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'highlightColorHex',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserVerseData, UserVerseData, QAfterFilterCondition>
      highlightColorHexIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'highlightColorHex',
        value: '',
      ));
    });
  }

  QueryBuilder<UserVerseData, UserVerseData, QAfterFilterCondition>
      highlightColorHexIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'highlightColorHex',
        value: '',
      ));
    });
  }

  QueryBuilder<UserVerseData, UserVerseData, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<UserVerseData, UserVerseData, QAfterFilterCondition>
      idGreaterThan(
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

  QueryBuilder<UserVerseData, UserVerseData, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<UserVerseData, UserVerseData, QAfterFilterCondition> idBetween(
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

  QueryBuilder<UserVerseData, UserVerseData, QAfterFilterCondition>
      isBookmarkedEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isBookmarked',
        value: value,
      ));
    });
  }

  QueryBuilder<UserVerseData, UserVerseData, QAfterFilterCondition>
      noteTextIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'noteText',
      ));
    });
  }

  QueryBuilder<UserVerseData, UserVerseData, QAfterFilterCondition>
      noteTextIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'noteText',
      ));
    });
  }

  QueryBuilder<UserVerseData, UserVerseData, QAfterFilterCondition>
      noteTextEqualTo(
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

  QueryBuilder<UserVerseData, UserVerseData, QAfterFilterCondition>
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

  QueryBuilder<UserVerseData, UserVerseData, QAfterFilterCondition>
      noteTextLessThan(
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

  QueryBuilder<UserVerseData, UserVerseData, QAfterFilterCondition>
      noteTextBetween(
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

  QueryBuilder<UserVerseData, UserVerseData, QAfterFilterCondition>
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

  QueryBuilder<UserVerseData, UserVerseData, QAfterFilterCondition>
      noteTextEndsWith(
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

  QueryBuilder<UserVerseData, UserVerseData, QAfterFilterCondition>
      noteTextContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'noteText',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserVerseData, UserVerseData, QAfterFilterCondition>
      noteTextMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'noteText',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserVerseData, UserVerseData, QAfterFilterCondition>
      noteTextIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'noteText',
        value: '',
      ));
    });
  }

  QueryBuilder<UserVerseData, UserVerseData, QAfterFilterCondition>
      noteTextIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'noteText',
        value: '',
      ));
    });
  }

  QueryBuilder<UserVerseData, UserVerseData, QAfterFilterCondition>
      updatedAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'updatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<UserVerseData, UserVerseData, QAfterFilterCondition>
      updatedAtGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'updatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<UserVerseData, UserVerseData, QAfterFilterCondition>
      updatedAtLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'updatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<UserVerseData, UserVerseData, QAfterFilterCondition>
      updatedAtBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'updatedAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<UserVerseData, UserVerseData, QAfterFilterCondition>
      verseIdKeyEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'verseIdKey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserVerseData, UserVerseData, QAfterFilterCondition>
      verseIdKeyGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'verseIdKey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserVerseData, UserVerseData, QAfterFilterCondition>
      verseIdKeyLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'verseIdKey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserVerseData, UserVerseData, QAfterFilterCondition>
      verseIdKeyBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'verseIdKey',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserVerseData, UserVerseData, QAfterFilterCondition>
      verseIdKeyStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'verseIdKey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserVerseData, UserVerseData, QAfterFilterCondition>
      verseIdKeyEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'verseIdKey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserVerseData, UserVerseData, QAfterFilterCondition>
      verseIdKeyContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'verseIdKey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserVerseData, UserVerseData, QAfterFilterCondition>
      verseIdKeyMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'verseIdKey',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserVerseData, UserVerseData, QAfterFilterCondition>
      verseIdKeyIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'verseIdKey',
        value: '',
      ));
    });
  }

  QueryBuilder<UserVerseData, UserVerseData, QAfterFilterCondition>
      verseIdKeyIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'verseIdKey',
        value: '',
      ));
    });
  }
}

extension UserVerseDataQueryObject
    on QueryBuilder<UserVerseData, UserVerseData, QFilterCondition> {}

extension UserVerseDataQueryLinks
    on QueryBuilder<UserVerseData, UserVerseData, QFilterCondition> {}

extension UserVerseDataQuerySortBy
    on QueryBuilder<UserVerseData, UserVerseData, QSortBy> {
  QueryBuilder<UserVerseData, UserVerseData, QAfterSortBy>
      sortByHighlightColorHex() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'highlightColorHex', Sort.asc);
    });
  }

  QueryBuilder<UserVerseData, UserVerseData, QAfterSortBy>
      sortByHighlightColorHexDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'highlightColorHex', Sort.desc);
    });
  }

  QueryBuilder<UserVerseData, UserVerseData, QAfterSortBy>
      sortByIsBookmarked() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isBookmarked', Sort.asc);
    });
  }

  QueryBuilder<UserVerseData, UserVerseData, QAfterSortBy>
      sortByIsBookmarkedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isBookmarked', Sort.desc);
    });
  }

  QueryBuilder<UserVerseData, UserVerseData, QAfterSortBy> sortByNoteText() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'noteText', Sort.asc);
    });
  }

  QueryBuilder<UserVerseData, UserVerseData, QAfterSortBy>
      sortByNoteTextDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'noteText', Sort.desc);
    });
  }

  QueryBuilder<UserVerseData, UserVerseData, QAfterSortBy> sortByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<UserVerseData, UserVerseData, QAfterSortBy>
      sortByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }

  QueryBuilder<UserVerseData, UserVerseData, QAfterSortBy> sortByVerseIdKey() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'verseIdKey', Sort.asc);
    });
  }

  QueryBuilder<UserVerseData, UserVerseData, QAfterSortBy>
      sortByVerseIdKeyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'verseIdKey', Sort.desc);
    });
  }
}

extension UserVerseDataQuerySortThenBy
    on QueryBuilder<UserVerseData, UserVerseData, QSortThenBy> {
  QueryBuilder<UserVerseData, UserVerseData, QAfterSortBy>
      thenByHighlightColorHex() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'highlightColorHex', Sort.asc);
    });
  }

  QueryBuilder<UserVerseData, UserVerseData, QAfterSortBy>
      thenByHighlightColorHexDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'highlightColorHex', Sort.desc);
    });
  }

  QueryBuilder<UserVerseData, UserVerseData, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<UserVerseData, UserVerseData, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<UserVerseData, UserVerseData, QAfterSortBy>
      thenByIsBookmarked() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isBookmarked', Sort.asc);
    });
  }

  QueryBuilder<UserVerseData, UserVerseData, QAfterSortBy>
      thenByIsBookmarkedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isBookmarked', Sort.desc);
    });
  }

  QueryBuilder<UserVerseData, UserVerseData, QAfterSortBy> thenByNoteText() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'noteText', Sort.asc);
    });
  }

  QueryBuilder<UserVerseData, UserVerseData, QAfterSortBy>
      thenByNoteTextDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'noteText', Sort.desc);
    });
  }

  QueryBuilder<UserVerseData, UserVerseData, QAfterSortBy> thenByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<UserVerseData, UserVerseData, QAfterSortBy>
      thenByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }

  QueryBuilder<UserVerseData, UserVerseData, QAfterSortBy> thenByVerseIdKey() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'verseIdKey', Sort.asc);
    });
  }

  QueryBuilder<UserVerseData, UserVerseData, QAfterSortBy>
      thenByVerseIdKeyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'verseIdKey', Sort.desc);
    });
  }
}

extension UserVerseDataQueryWhereDistinct
    on QueryBuilder<UserVerseData, UserVerseData, QDistinct> {
  QueryBuilder<UserVerseData, UserVerseData, QDistinct>
      distinctByHighlightColorHex({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'highlightColorHex',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<UserVerseData, UserVerseData, QDistinct>
      distinctByIsBookmarked() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isBookmarked');
    });
  }

  QueryBuilder<UserVerseData, UserVerseData, QDistinct> distinctByNoteText(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'noteText', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<UserVerseData, UserVerseData, QDistinct> distinctByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'updatedAt');
    });
  }

  QueryBuilder<UserVerseData, UserVerseData, QDistinct> distinctByVerseIdKey(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'verseIdKey', caseSensitive: caseSensitive);
    });
  }
}

extension UserVerseDataQueryProperty
    on QueryBuilder<UserVerseData, UserVerseData, QQueryProperty> {
  QueryBuilder<UserVerseData, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<UserVerseData, String?, QQueryOperations>
      highlightColorHexProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'highlightColorHex');
    });
  }

  QueryBuilder<UserVerseData, bool, QQueryOperations> isBookmarkedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isBookmarked');
    });
  }

  QueryBuilder<UserVerseData, String?, QQueryOperations> noteTextProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'noteText');
    });
  }

  QueryBuilder<UserVerseData, DateTime, QQueryOperations> updatedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'updatedAt');
    });
  }

  QueryBuilder<UserVerseData, String, QQueryOperations> verseIdKeyProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'verseIdKey');
    });
  }
}

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetHistoryEntryCollection on Isar {
  IsarCollection<HistoryEntry> get historyEntrys => this.collection();
}

const HistoryEntrySchema = CollectionSchema(
  name: r'HistoryEntry',
  id: 2196274019059455532,
  properties: {
    r'actionType': PropertySchema(
      id: 0,
      name: r'actionType',
      type: IsarType.string,
    ),
    r'displayTitle': PropertySchema(
      id: 1,
      name: r'displayTitle',
      type: IsarType.string,
    ),
    r'timestamp': PropertySchema(
      id: 2,
      name: r'timestamp',
      type: IsarType.dateTime,
    )
  },
  estimateSize: _historyEntryEstimateSize,
  serialize: _historyEntrySerialize,
  deserialize: _historyEntryDeserialize,
  deserializeProp: _historyEntryDeserializeProp,
  idName: r'id',
  indexes: {
    r'timestamp': IndexSchema(
      id: 1852253767416892198,
      name: r'timestamp',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'timestamp',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _historyEntryGetId,
  getLinks: _historyEntryGetLinks,
  attach: _historyEntryAttach,
  version: '3.3.2',
);

int _historyEntryEstimateSize(
  HistoryEntry object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.actionType.length * 3;
  bytesCount += 3 + object.displayTitle.length * 3;
  return bytesCount;
}

void _historyEntrySerialize(
  HistoryEntry object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.actionType);
  writer.writeString(offsets[1], object.displayTitle);
  writer.writeDateTime(offsets[2], object.timestamp);
}

HistoryEntry _historyEntryDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = HistoryEntry();
  object.actionType = reader.readString(offsets[0]);
  object.displayTitle = reader.readString(offsets[1]);
  object.id = id;
  object.timestamp = reader.readDateTime(offsets[2]);
  return object;
}

P _historyEntryDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readString(offset)) as P;
    case 1:
      return (reader.readString(offset)) as P;
    case 2:
      return (reader.readDateTime(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _historyEntryGetId(HistoryEntry object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _historyEntryGetLinks(HistoryEntry object) {
  return [];
}

void _historyEntryAttach(
    IsarCollection<dynamic> col, Id id, HistoryEntry object) {
  object.id = id;
}

extension HistoryEntryQueryWhereSort
    on QueryBuilder<HistoryEntry, HistoryEntry, QWhere> {
  QueryBuilder<HistoryEntry, HistoryEntry, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<HistoryEntry, HistoryEntry, QAfterWhere> anyTimestamp() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'timestamp'),
      );
    });
  }
}

extension HistoryEntryQueryWhere
    on QueryBuilder<HistoryEntry, HistoryEntry, QWhereClause> {
  QueryBuilder<HistoryEntry, HistoryEntry, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<HistoryEntry, HistoryEntry, QAfterWhereClause> idNotEqualTo(
      Id id) {
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

  QueryBuilder<HistoryEntry, HistoryEntry, QAfterWhereClause> idGreaterThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<HistoryEntry, HistoryEntry, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<HistoryEntry, HistoryEntry, QAfterWhereClause> idBetween(
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

  QueryBuilder<HistoryEntry, HistoryEntry, QAfterWhereClause> timestampEqualTo(
      DateTime timestamp) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'timestamp',
        value: [timestamp],
      ));
    });
  }

  QueryBuilder<HistoryEntry, HistoryEntry, QAfterWhereClause>
      timestampNotEqualTo(DateTime timestamp) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'timestamp',
              lower: [],
              upper: [timestamp],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'timestamp',
              lower: [timestamp],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'timestamp',
              lower: [timestamp],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'timestamp',
              lower: [],
              upper: [timestamp],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<HistoryEntry, HistoryEntry, QAfterWhereClause>
      timestampGreaterThan(
    DateTime timestamp, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'timestamp',
        lower: [timestamp],
        includeLower: include,
        upper: [],
      ));
    });
  }

  QueryBuilder<HistoryEntry, HistoryEntry, QAfterWhereClause> timestampLessThan(
    DateTime timestamp, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'timestamp',
        lower: [],
        upper: [timestamp],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<HistoryEntry, HistoryEntry, QAfterWhereClause> timestampBetween(
    DateTime lowerTimestamp,
    DateTime upperTimestamp, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'timestamp',
        lower: [lowerTimestamp],
        includeLower: includeLower,
        upper: [upperTimestamp],
        includeUpper: includeUpper,
      ));
    });
  }
}

extension HistoryEntryQueryFilter
    on QueryBuilder<HistoryEntry, HistoryEntry, QFilterCondition> {
  QueryBuilder<HistoryEntry, HistoryEntry, QAfterFilterCondition>
      actionTypeEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'actionType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HistoryEntry, HistoryEntry, QAfterFilterCondition>
      actionTypeGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'actionType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HistoryEntry, HistoryEntry, QAfterFilterCondition>
      actionTypeLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'actionType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HistoryEntry, HistoryEntry, QAfterFilterCondition>
      actionTypeBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'actionType',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HistoryEntry, HistoryEntry, QAfterFilterCondition>
      actionTypeStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'actionType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HistoryEntry, HistoryEntry, QAfterFilterCondition>
      actionTypeEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'actionType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HistoryEntry, HistoryEntry, QAfterFilterCondition>
      actionTypeContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'actionType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HistoryEntry, HistoryEntry, QAfterFilterCondition>
      actionTypeMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'actionType',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HistoryEntry, HistoryEntry, QAfterFilterCondition>
      actionTypeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'actionType',
        value: '',
      ));
    });
  }

  QueryBuilder<HistoryEntry, HistoryEntry, QAfterFilterCondition>
      actionTypeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'actionType',
        value: '',
      ));
    });
  }

  QueryBuilder<HistoryEntry, HistoryEntry, QAfterFilterCondition>
      displayTitleEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'displayTitle',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HistoryEntry, HistoryEntry, QAfterFilterCondition>
      displayTitleGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'displayTitle',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HistoryEntry, HistoryEntry, QAfterFilterCondition>
      displayTitleLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'displayTitle',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HistoryEntry, HistoryEntry, QAfterFilterCondition>
      displayTitleBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'displayTitle',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HistoryEntry, HistoryEntry, QAfterFilterCondition>
      displayTitleStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'displayTitle',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HistoryEntry, HistoryEntry, QAfterFilterCondition>
      displayTitleEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'displayTitle',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HistoryEntry, HistoryEntry, QAfterFilterCondition>
      displayTitleContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'displayTitle',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HistoryEntry, HistoryEntry, QAfterFilterCondition>
      displayTitleMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'displayTitle',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HistoryEntry, HistoryEntry, QAfterFilterCondition>
      displayTitleIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'displayTitle',
        value: '',
      ));
    });
  }

  QueryBuilder<HistoryEntry, HistoryEntry, QAfterFilterCondition>
      displayTitleIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'displayTitle',
        value: '',
      ));
    });
  }

  QueryBuilder<HistoryEntry, HistoryEntry, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<HistoryEntry, HistoryEntry, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<HistoryEntry, HistoryEntry, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<HistoryEntry, HistoryEntry, QAfterFilterCondition> idBetween(
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

  QueryBuilder<HistoryEntry, HistoryEntry, QAfterFilterCondition>
      timestampEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'timestamp',
        value: value,
      ));
    });
  }

  QueryBuilder<HistoryEntry, HistoryEntry, QAfterFilterCondition>
      timestampGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'timestamp',
        value: value,
      ));
    });
  }

  QueryBuilder<HistoryEntry, HistoryEntry, QAfterFilterCondition>
      timestampLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'timestamp',
        value: value,
      ));
    });
  }

  QueryBuilder<HistoryEntry, HistoryEntry, QAfterFilterCondition>
      timestampBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'timestamp',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension HistoryEntryQueryObject
    on QueryBuilder<HistoryEntry, HistoryEntry, QFilterCondition> {}

extension HistoryEntryQueryLinks
    on QueryBuilder<HistoryEntry, HistoryEntry, QFilterCondition> {}

extension HistoryEntryQuerySortBy
    on QueryBuilder<HistoryEntry, HistoryEntry, QSortBy> {
  QueryBuilder<HistoryEntry, HistoryEntry, QAfterSortBy> sortByActionType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'actionType', Sort.asc);
    });
  }

  QueryBuilder<HistoryEntry, HistoryEntry, QAfterSortBy>
      sortByActionTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'actionType', Sort.desc);
    });
  }

  QueryBuilder<HistoryEntry, HistoryEntry, QAfterSortBy> sortByDisplayTitle() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'displayTitle', Sort.asc);
    });
  }

  QueryBuilder<HistoryEntry, HistoryEntry, QAfterSortBy>
      sortByDisplayTitleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'displayTitle', Sort.desc);
    });
  }

  QueryBuilder<HistoryEntry, HistoryEntry, QAfterSortBy> sortByTimestamp() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'timestamp', Sort.asc);
    });
  }

  QueryBuilder<HistoryEntry, HistoryEntry, QAfterSortBy> sortByTimestampDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'timestamp', Sort.desc);
    });
  }
}

extension HistoryEntryQuerySortThenBy
    on QueryBuilder<HistoryEntry, HistoryEntry, QSortThenBy> {
  QueryBuilder<HistoryEntry, HistoryEntry, QAfterSortBy> thenByActionType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'actionType', Sort.asc);
    });
  }

  QueryBuilder<HistoryEntry, HistoryEntry, QAfterSortBy>
      thenByActionTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'actionType', Sort.desc);
    });
  }

  QueryBuilder<HistoryEntry, HistoryEntry, QAfterSortBy> thenByDisplayTitle() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'displayTitle', Sort.asc);
    });
  }

  QueryBuilder<HistoryEntry, HistoryEntry, QAfterSortBy>
      thenByDisplayTitleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'displayTitle', Sort.desc);
    });
  }

  QueryBuilder<HistoryEntry, HistoryEntry, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<HistoryEntry, HistoryEntry, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<HistoryEntry, HistoryEntry, QAfterSortBy> thenByTimestamp() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'timestamp', Sort.asc);
    });
  }

  QueryBuilder<HistoryEntry, HistoryEntry, QAfterSortBy> thenByTimestampDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'timestamp', Sort.desc);
    });
  }
}

extension HistoryEntryQueryWhereDistinct
    on QueryBuilder<HistoryEntry, HistoryEntry, QDistinct> {
  QueryBuilder<HistoryEntry, HistoryEntry, QDistinct> distinctByActionType(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'actionType', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<HistoryEntry, HistoryEntry, QDistinct> distinctByDisplayTitle(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'displayTitle', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<HistoryEntry, HistoryEntry, QDistinct> distinctByTimestamp() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'timestamp');
    });
  }
}

extension HistoryEntryQueryProperty
    on QueryBuilder<HistoryEntry, HistoryEntry, QQueryProperty> {
  QueryBuilder<HistoryEntry, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<HistoryEntry, String, QQueryOperations> actionTypeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'actionType');
    });
  }

  QueryBuilder<HistoryEntry, String, QQueryOperations> displayTitleProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'displayTitle');
    });
  }

  QueryBuilder<HistoryEntry, DateTime, QQueryOperations> timestampProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'timestamp');
    });
  }
}
