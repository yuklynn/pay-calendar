// ignore_for_file: unused_import, implementation_imports

import 'dart:ffi';
import 'dart:convert';
import 'dart:isolate';
import 'dart:typed_data';
import 'dart:io';
import 'package:isar/isar.dart';
import 'package:isar/src/isar_native.dart';
import 'package:isar/src/query_builder.dart';
import 'package:ffi/ffi.dart';
import 'package:path/path.dart' as p;
import 'isar/memo/collection.dart';
import 'isar/note/collection.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/widgets.dart';

const _utf8Encoder = Utf8Encoder();

final _schema =
    '[{"name":"MemoCollection","idProperty":"id","properties":[{"name":"id","type":3},{"name":"noteId","type":3},{"name":"title","type":5},{"name":"cost","type":3},{"name":"date","type":3},{"name":"description","type":5},{"name":"done","type":0}],"indexes":[],"links":[]},{"name":"NoteCollection","idProperty":"id","properties":[{"name":"id","type":3},{"name":"title","type":5},{"name":"color","type":3},{"name":"description","type":5},{"name":"pin","type":0}],"indexes":[],"links":[]},{"name":"LastShownNoteCollection","idProperty":"id","properties":[{"name":"id","type":3}],"indexes":[],"links":[{"name":"note","collection":"NoteCollection"}]}]';

Future<Isar> openIsar(
    {String name = 'isar',
    String? directory,
    int maxSize = 1000000000,
    Uint8List? encryptionKey}) async {
  final path = await _preparePath(directory);
  return openIsarInternal(
      name: name,
      directory: path,
      maxSize: maxSize,
      encryptionKey: encryptionKey,
      schema: _schema,
      getCollections: (isar) {
        final collectionPtrPtr = malloc<Pointer>();
        final propertyOffsetsPtr = malloc<Uint32>(7);
        final propertyOffsets = propertyOffsetsPtr.asTypedList(7);
        final collections = <String, IsarCollection>{};
        nCall(IC.isar_get_collection(isar.ptr, collectionPtrPtr, 0));
        IC.isar_get_property_offsets(
            collectionPtrPtr.value, propertyOffsetsPtr);
        collections['MemoCollection'] = IsarCollectionImpl<MemoCollection>(
          isar: isar,
          adapter: _MemoCollectionAdapter(),
          ptr: collectionPtrPtr.value,
          propertyOffsets: propertyOffsets.sublist(0, 7),
          propertyIds: {
            'id': 0,
            'noteId': 1,
            'title': 2,
            'cost': 3,
            'date': 4,
            'description': 5,
            'done': 6
          },
          indexIds: {},
          linkIds: {},
          backlinkIds: {},
          getId: (obj) => obj.id,
          setId: (obj, id) => obj.id = id,
        );
        nCall(IC.isar_get_collection(isar.ptr, collectionPtrPtr, 1));
        IC.isar_get_property_offsets(
            collectionPtrPtr.value, propertyOffsetsPtr);
        collections['NoteCollection'] = IsarCollectionImpl<NoteCollection>(
          isar: isar,
          adapter: _NoteCollectionAdapter(),
          ptr: collectionPtrPtr.value,
          propertyOffsets: propertyOffsets.sublist(0, 5),
          propertyIds: {
            'id': 0,
            'title': 1,
            'color': 2,
            'description': 3,
            'pin': 4
          },
          indexIds: {},
          linkIds: {},
          backlinkIds: {},
          getId: (obj) => obj.id,
          setId: (obj, id) => obj.id = id,
        );
        nCall(IC.isar_get_collection(isar.ptr, collectionPtrPtr, 2));
        IC.isar_get_property_offsets(
            collectionPtrPtr.value, propertyOffsetsPtr);
        collections['LastShownNoteCollection'] =
            IsarCollectionImpl<LastShownNoteCollection>(
          isar: isar,
          adapter: _LastShownNoteCollectionAdapter(),
          ptr: collectionPtrPtr.value,
          propertyOffsets: propertyOffsets.sublist(0, 1),
          propertyIds: {'id': 0},
          indexIds: {},
          linkIds: {'note': 0},
          backlinkIds: {},
          getId: (obj) => obj.id,
          setId: (obj, id) => obj.id = id,
        );
        malloc.free(propertyOffsetsPtr);
        malloc.free(collectionPtrPtr);

        return collections;
      });
}

Future<String> _preparePath(String? path) async {
  if (path == null || p.isRelative(path)) {
    WidgetsFlutterBinding.ensureInitialized();
    final dir = await getApplicationDocumentsDirectory();
    return p.join(dir.path, path ?? 'isar');
  } else {
    return path;
  }
}

class _MemoCollectionAdapter extends TypeAdapter<MemoCollection> {
  @override
  int serialize(IsarCollectionImpl<MemoCollection> collection, RawObject rawObj,
      MemoCollection object, List<int> offsets,
      [int? existingBufferSize]) {
    var dynamicSize = 0;
    final value0 = object.id;
    final _id = value0;
    final value1 = object.noteId;
    final _noteId = value1;
    final value2 = object.title;
    Uint8List? _title;
    if (value2 != null) {
      _title = _utf8Encoder.convert(value2);
    }
    dynamicSize += _title?.length ?? 0;
    final value3 = object.cost;
    final _cost = value3;
    final value4 = object.date;
    final _date = value4;
    final value5 = object.description;
    Uint8List? _description;
    if (value5 != null) {
      _description = _utf8Encoder.convert(value5);
    }
    dynamicSize += _description?.length ?? 0;
    final value6 = object.done;
    final _done = value6;
    final size = dynamicSize + 51;

    late int bufferSize;
    if (existingBufferSize != null) {
      if (existingBufferSize < size) {
        malloc.free(rawObj.buffer);
        rawObj.buffer = malloc(size);
        bufferSize = size;
      } else {
        bufferSize = existingBufferSize;
      }
    } else {
      rawObj.buffer = malloc(size);
      bufferSize = size;
    }
    rawObj.buffer_length = size;
    final buffer = rawObj.buffer.asTypedList(size);
    final writer = BinaryWriter(buffer, 51);
    writer.writeLong(offsets[0], _id);
    writer.writeLong(offsets[1], _noteId);
    writer.writeBytes(offsets[2], _title);
    writer.writeLong(offsets[3], _cost);
    writer.writeDateTime(offsets[4], _date);
    writer.writeBytes(offsets[5], _description);
    writer.writeBool(offsets[6], _done);
    return bufferSize;
  }

  @override
  MemoCollection deserialize(IsarCollectionImpl<MemoCollection> collection,
      BinaryReader reader, List<int> offsets) {
    final object = MemoCollection();
    object.id = reader.readLongOrNull(offsets[0]);
    object.noteId = reader.readLongOrNull(offsets[1]);
    object.title = reader.readStringOrNull(offsets[2]);
    object.cost = reader.readLongOrNull(offsets[3]);
    object.date = reader.readDateTimeOrNull(offsets[4]);
    object.description = reader.readStringOrNull(offsets[5]);
    object.done = reader.readBoolOrNull(offsets[6]);
    return object;
  }

  @override
  P deserializeProperty<P>(BinaryReader reader, int propertyIndex, int offset) {
    switch (propertyIndex) {
      case 0:
        return (reader.readLongOrNull(offset)) as P;
      case 1:
        return (reader.readLongOrNull(offset)) as P;
      case 2:
        return (reader.readStringOrNull(offset)) as P;
      case 3:
        return (reader.readLongOrNull(offset)) as P;
      case 4:
        return (reader.readDateTimeOrNull(offset)) as P;
      case 5:
        return (reader.readStringOrNull(offset)) as P;
      case 6:
        return (reader.readBoolOrNull(offset)) as P;
      default:
        throw 'Illegal propertyIndex';
    }
  }
}

class _NoteCollectionAdapter extends TypeAdapter<NoteCollection> {
  @override
  int serialize(IsarCollectionImpl<NoteCollection> collection, RawObject rawObj,
      NoteCollection object, List<int> offsets,
      [int? existingBufferSize]) {
    var dynamicSize = 0;
    final value0 = object.id;
    final _id = value0;
    final value1 = object.title;
    Uint8List? _title;
    if (value1 != null) {
      _title = _utf8Encoder.convert(value1);
    }
    dynamicSize += _title?.length ?? 0;
    final value2 = object.color;
    final _color = value2;
    final value3 = object.description;
    Uint8List? _description;
    if (value3 != null) {
      _description = _utf8Encoder.convert(value3);
    }
    dynamicSize += _description?.length ?? 0;
    final value4 = object.pin;
    final _pin = value4;
    final size = dynamicSize + 35;

    late int bufferSize;
    if (existingBufferSize != null) {
      if (existingBufferSize < size) {
        malloc.free(rawObj.buffer);
        rawObj.buffer = malloc(size);
        bufferSize = size;
      } else {
        bufferSize = existingBufferSize;
      }
    } else {
      rawObj.buffer = malloc(size);
      bufferSize = size;
    }
    rawObj.buffer_length = size;
    final buffer = rawObj.buffer.asTypedList(size);
    final writer = BinaryWriter(buffer, 35);
    writer.writeLong(offsets[0], _id);
    writer.writeBytes(offsets[1], _title);
    writer.writeLong(offsets[2], _color);
    writer.writeBytes(offsets[3], _description);
    writer.writeBool(offsets[4], _pin);
    return bufferSize;
  }

  @override
  NoteCollection deserialize(IsarCollectionImpl<NoteCollection> collection,
      BinaryReader reader, List<int> offsets) {
    final object = NoteCollection();
    object.id = reader.readLongOrNull(offsets[0]);
    object.title = reader.readStringOrNull(offsets[1]);
    object.color = reader.readLongOrNull(offsets[2]);
    object.description = reader.readStringOrNull(offsets[3]);
    object.pin = reader.readBoolOrNull(offsets[4]);
    return object;
  }

  @override
  P deserializeProperty<P>(BinaryReader reader, int propertyIndex, int offset) {
    switch (propertyIndex) {
      case 0:
        return (reader.readLongOrNull(offset)) as P;
      case 1:
        return (reader.readStringOrNull(offset)) as P;
      case 2:
        return (reader.readLongOrNull(offset)) as P;
      case 3:
        return (reader.readStringOrNull(offset)) as P;
      case 4:
        return (reader.readBoolOrNull(offset)) as P;
      default:
        throw 'Illegal propertyIndex';
    }
  }
}

class _LastShownNoteCollectionAdapter
    extends TypeAdapter<LastShownNoteCollection> {
  @override
  int serialize(IsarCollectionImpl<LastShownNoteCollection> collection,
      RawObject rawObj, LastShownNoteCollection object, List<int> offsets,
      [int? existingBufferSize]) {
    var dynamicSize = 0;
    final value0 = object.id;
    final _id = value0;
    final size = dynamicSize + 10;

    late int bufferSize;
    if (existingBufferSize != null) {
      if (existingBufferSize < size) {
        malloc.free(rawObj.buffer);
        rawObj.buffer = malloc(size);
        bufferSize = size;
      } else {
        bufferSize = existingBufferSize;
      }
    } else {
      rawObj.buffer = malloc(size);
      bufferSize = size;
    }
    rawObj.buffer_length = size;
    final buffer = rawObj.buffer.asTypedList(size);
    final writer = BinaryWriter(buffer, 10);
    writer.writeLong(offsets[0], _id);
    if (!(object.note as IsarLinkImpl).attached) {
      (object.note as IsarLinkImpl).attach(
        collection,
        collection.isar.noteCollections as IsarCollectionImpl<NoteCollection>,
        object,
        0,
        false,
      );
    }
    return bufferSize;
  }

  @override
  LastShownNoteCollection deserialize(
      IsarCollectionImpl<LastShownNoteCollection> collection,
      BinaryReader reader,
      List<int> offsets) {
    final object = LastShownNoteCollection();
    object.id = reader.readLongOrNull(offsets[0]);
    object.note = IsarLinkImpl()
      ..attach(
        collection,
        collection.isar.noteCollections as IsarCollectionImpl<NoteCollection>,
        object,
        0,
        false,
      );

    return object;
  }

  @override
  P deserializeProperty<P>(BinaryReader reader, int propertyIndex, int offset) {
    switch (propertyIndex) {
      case 0:
        return (reader.readLongOrNull(offset)) as P;
      default:
        throw 'Illegal propertyIndex';
    }
  }
}

extension GetCollection on Isar {
  IsarCollection<MemoCollection> get memoCollections {
    return getCollection('MemoCollection');
  }

  IsarCollection<NoteCollection> get noteCollections {
    return getCollection('NoteCollection');
  }

  IsarCollection<LastShownNoteCollection> get lastShownNoteCollections {
    return getCollection('LastShownNoteCollection');
  }
}

extension MemoCollectionQueryWhereSort on QueryBuilder<MemoCollection, QWhere> {
  QueryBuilder<MemoCollection, QAfterWhere> anyId() {
    return addWhereClause(WhereClause(indexName: 'id'));
  }
}

extension MemoCollectionQueryWhere
    on QueryBuilder<MemoCollection, QWhereClause> {}

extension NoteCollectionQueryWhereSort on QueryBuilder<NoteCollection, QWhere> {
  QueryBuilder<NoteCollection, QAfterWhere> anyId() {
    return addWhereClause(WhereClause(indexName: 'id'));
  }
}

extension NoteCollectionQueryWhere
    on QueryBuilder<NoteCollection, QWhereClause> {}

extension LastShownNoteCollectionQueryWhereSort
    on QueryBuilder<LastShownNoteCollection, QWhere> {
  QueryBuilder<LastShownNoteCollection, QAfterWhere> anyId() {
    return addWhereClause(WhereClause(indexName: 'id'));
  }
}

extension LastShownNoteCollectionQueryWhere
    on QueryBuilder<LastShownNoteCollection, QWhereClause> {}

extension MemoCollectionQueryFilter
    on QueryBuilder<MemoCollection, QFilterCondition> {
  QueryBuilder<MemoCollection, QAfterFilterCondition> idIsNull() {
    return addFilterCondition(FilterCondition(
      type: ConditionType.Eq,
      property: 'id',
      value: null,
    ));
  }

  QueryBuilder<MemoCollection, QAfterFilterCondition> idEqualTo(int? value) {
    return addFilterCondition(FilterCondition(
      type: ConditionType.Eq,
      property: 'id',
      value: value,
    ));
  }

  QueryBuilder<MemoCollection, QAfterFilterCondition> idGreaterThan(
      int? value) {
    return addFilterCondition(FilterCondition(
      type: ConditionType.Gt,
      property: 'id',
      value: value,
    ));
  }

  QueryBuilder<MemoCollection, QAfterFilterCondition> idLessThan(int? value) {
    return addFilterCondition(FilterCondition(
      type: ConditionType.Lt,
      property: 'id',
      value: value,
    ));
  }

  QueryBuilder<MemoCollection, QAfterFilterCondition> idBetween(
      int? lower, int? upper) {
    return addFilterCondition(FilterCondition.between(
      property: 'id',
      lower: lower,
      upper: upper,
    ));
  }

  QueryBuilder<MemoCollection, QAfterFilterCondition> noteIdIsNull() {
    return addFilterCondition(FilterCondition(
      type: ConditionType.Eq,
      property: 'noteId',
      value: null,
    ));
  }

  QueryBuilder<MemoCollection, QAfterFilterCondition> noteIdEqualTo(
      int? value) {
    return addFilterCondition(FilterCondition(
      type: ConditionType.Eq,
      property: 'noteId',
      value: value,
    ));
  }

  QueryBuilder<MemoCollection, QAfterFilterCondition> noteIdGreaterThan(
      int? value) {
    return addFilterCondition(FilterCondition(
      type: ConditionType.Gt,
      property: 'noteId',
      value: value,
    ));
  }

  QueryBuilder<MemoCollection, QAfterFilterCondition> noteIdLessThan(
      int? value) {
    return addFilterCondition(FilterCondition(
      type: ConditionType.Lt,
      property: 'noteId',
      value: value,
    ));
  }

  QueryBuilder<MemoCollection, QAfterFilterCondition> noteIdBetween(
      int? lower, int? upper) {
    return addFilterCondition(FilterCondition.between(
      property: 'noteId',
      lower: lower,
      upper: upper,
    ));
  }

  QueryBuilder<MemoCollection, QAfterFilterCondition> titleIsNull() {
    return addFilterCondition(FilterCondition(
      type: ConditionType.Eq,
      property: 'title',
      value: null,
    ));
  }

  QueryBuilder<MemoCollection, QAfterFilterCondition> titleEqualTo(
      String? value,
      {bool caseSensitive = true}) {
    return addFilterCondition(FilterCondition(
      type: ConditionType.Eq,
      property: 'title',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<MemoCollection, QAfterFilterCondition> titleStartsWith(
      String? value,
      {bool caseSensitive = true}) {
    final convertedValue = value;
    assert(convertedValue != null, 'Null values are not allowed');
    return addFilterCondition(FilterCondition(
      type: ConditionType.StartsWith,
      property: 'title',
      value: convertedValue,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<MemoCollection, QAfterFilterCondition> titleEndsWith(
      String? value,
      {bool caseSensitive = true}) {
    final convertedValue = value;
    assert(convertedValue != null, 'Null values are not allowed');
    return addFilterCondition(FilterCondition(
      type: ConditionType.EndsWith,
      property: 'title',
      value: convertedValue,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<MemoCollection, QAfterFilterCondition> titleContains(
      String? value,
      {bool caseSensitive = true}) {
    final convertedValue = value;
    assert(convertedValue != null, 'Null values are not allowed');
    return addFilterCondition(FilterCondition(
      type: ConditionType.Matches,
      property: 'title',
      value: '*$convertedValue*',
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<MemoCollection, QAfterFilterCondition> titleMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return addFilterCondition(FilterCondition(
      type: ConditionType.Matches,
      property: 'title',
      value: pattern,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<MemoCollection, QAfterFilterCondition> costIsNull() {
    return addFilterCondition(FilterCondition(
      type: ConditionType.Eq,
      property: 'cost',
      value: null,
    ));
  }

  QueryBuilder<MemoCollection, QAfterFilterCondition> costEqualTo(int? value) {
    return addFilterCondition(FilterCondition(
      type: ConditionType.Eq,
      property: 'cost',
      value: value,
    ));
  }

  QueryBuilder<MemoCollection, QAfterFilterCondition> costGreaterThan(
      int? value) {
    return addFilterCondition(FilterCondition(
      type: ConditionType.Gt,
      property: 'cost',
      value: value,
    ));
  }

  QueryBuilder<MemoCollection, QAfterFilterCondition> costLessThan(int? value) {
    return addFilterCondition(FilterCondition(
      type: ConditionType.Lt,
      property: 'cost',
      value: value,
    ));
  }

  QueryBuilder<MemoCollection, QAfterFilterCondition> costBetween(
      int? lower, int? upper) {
    return addFilterCondition(FilterCondition.between(
      property: 'cost',
      lower: lower,
      upper: upper,
    ));
  }

  QueryBuilder<MemoCollection, QAfterFilterCondition> dateIsNull() {
    return addFilterCondition(FilterCondition(
      type: ConditionType.Eq,
      property: 'date',
      value: null,
    ));
  }

  QueryBuilder<MemoCollection, QAfterFilterCondition> dateEqualTo(
      DateTime? value) {
    return addFilterCondition(FilterCondition(
      type: ConditionType.Eq,
      property: 'date',
      value: value,
    ));
  }

  QueryBuilder<MemoCollection, QAfterFilterCondition> dateGreaterThan(
      DateTime? value) {
    return addFilterCondition(FilterCondition(
      type: ConditionType.Gt,
      property: 'date',
      value: value,
    ));
  }

  QueryBuilder<MemoCollection, QAfterFilterCondition> dateLessThan(
      DateTime? value) {
    return addFilterCondition(FilterCondition(
      type: ConditionType.Lt,
      property: 'date',
      value: value,
    ));
  }

  QueryBuilder<MemoCollection, QAfterFilterCondition> dateBetween(
      DateTime? lower, DateTime? upper) {
    return addFilterCondition(FilterCondition.between(
      property: 'date',
      lower: lower,
      upper: upper,
    ));
  }

  QueryBuilder<MemoCollection, QAfterFilterCondition> descriptionIsNull() {
    return addFilterCondition(FilterCondition(
      type: ConditionType.Eq,
      property: 'description',
      value: null,
    ));
  }

  QueryBuilder<MemoCollection, QAfterFilterCondition> descriptionEqualTo(
      String? value,
      {bool caseSensitive = true}) {
    return addFilterCondition(FilterCondition(
      type: ConditionType.Eq,
      property: 'description',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<MemoCollection, QAfterFilterCondition> descriptionStartsWith(
      String? value,
      {bool caseSensitive = true}) {
    final convertedValue = value;
    assert(convertedValue != null, 'Null values are not allowed');
    return addFilterCondition(FilterCondition(
      type: ConditionType.StartsWith,
      property: 'description',
      value: convertedValue,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<MemoCollection, QAfterFilterCondition> descriptionEndsWith(
      String? value,
      {bool caseSensitive = true}) {
    final convertedValue = value;
    assert(convertedValue != null, 'Null values are not allowed');
    return addFilterCondition(FilterCondition(
      type: ConditionType.EndsWith,
      property: 'description',
      value: convertedValue,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<MemoCollection, QAfterFilterCondition> descriptionContains(
      String? value,
      {bool caseSensitive = true}) {
    final convertedValue = value;
    assert(convertedValue != null, 'Null values are not allowed');
    return addFilterCondition(FilterCondition(
      type: ConditionType.Matches,
      property: 'description',
      value: '*$convertedValue*',
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<MemoCollection, QAfterFilterCondition> descriptionMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return addFilterCondition(FilterCondition(
      type: ConditionType.Matches,
      property: 'description',
      value: pattern,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<MemoCollection, QAfterFilterCondition> doneIsNull() {
    return addFilterCondition(FilterCondition(
      type: ConditionType.Eq,
      property: 'done',
      value: null,
    ));
  }

  QueryBuilder<MemoCollection, QAfterFilterCondition> doneEqualTo(bool? value) {
    return addFilterCondition(FilterCondition(
      type: ConditionType.Eq,
      property: 'done',
      value: value,
    ));
  }
}

extension NoteCollectionQueryFilter
    on QueryBuilder<NoteCollection, QFilterCondition> {
  QueryBuilder<NoteCollection, QAfterFilterCondition> idIsNull() {
    return addFilterCondition(FilterCondition(
      type: ConditionType.Eq,
      property: 'id',
      value: null,
    ));
  }

  QueryBuilder<NoteCollection, QAfterFilterCondition> idEqualTo(int? value) {
    return addFilterCondition(FilterCondition(
      type: ConditionType.Eq,
      property: 'id',
      value: value,
    ));
  }

  QueryBuilder<NoteCollection, QAfterFilterCondition> idGreaterThan(
      int? value) {
    return addFilterCondition(FilterCondition(
      type: ConditionType.Gt,
      property: 'id',
      value: value,
    ));
  }

  QueryBuilder<NoteCollection, QAfterFilterCondition> idLessThan(int? value) {
    return addFilterCondition(FilterCondition(
      type: ConditionType.Lt,
      property: 'id',
      value: value,
    ));
  }

  QueryBuilder<NoteCollection, QAfterFilterCondition> idBetween(
      int? lower, int? upper) {
    return addFilterCondition(FilterCondition.between(
      property: 'id',
      lower: lower,
      upper: upper,
    ));
  }

  QueryBuilder<NoteCollection, QAfterFilterCondition> titleIsNull() {
    return addFilterCondition(FilterCondition(
      type: ConditionType.Eq,
      property: 'title',
      value: null,
    ));
  }

  QueryBuilder<NoteCollection, QAfterFilterCondition> titleEqualTo(
      String? value,
      {bool caseSensitive = true}) {
    return addFilterCondition(FilterCondition(
      type: ConditionType.Eq,
      property: 'title',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<NoteCollection, QAfterFilterCondition> titleStartsWith(
      String? value,
      {bool caseSensitive = true}) {
    final convertedValue = value;
    assert(convertedValue != null, 'Null values are not allowed');
    return addFilterCondition(FilterCondition(
      type: ConditionType.StartsWith,
      property: 'title',
      value: convertedValue,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<NoteCollection, QAfterFilterCondition> titleEndsWith(
      String? value,
      {bool caseSensitive = true}) {
    final convertedValue = value;
    assert(convertedValue != null, 'Null values are not allowed');
    return addFilterCondition(FilterCondition(
      type: ConditionType.EndsWith,
      property: 'title',
      value: convertedValue,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<NoteCollection, QAfterFilterCondition> titleContains(
      String? value,
      {bool caseSensitive = true}) {
    final convertedValue = value;
    assert(convertedValue != null, 'Null values are not allowed');
    return addFilterCondition(FilterCondition(
      type: ConditionType.Matches,
      property: 'title',
      value: '*$convertedValue*',
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<NoteCollection, QAfterFilterCondition> titleMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return addFilterCondition(FilterCondition(
      type: ConditionType.Matches,
      property: 'title',
      value: pattern,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<NoteCollection, QAfterFilterCondition> colorIsNull() {
    return addFilterCondition(FilterCondition(
      type: ConditionType.Eq,
      property: 'color',
      value: null,
    ));
  }

  QueryBuilder<NoteCollection, QAfterFilterCondition> colorEqualTo(int? value) {
    return addFilterCondition(FilterCondition(
      type: ConditionType.Eq,
      property: 'color',
      value: value,
    ));
  }

  QueryBuilder<NoteCollection, QAfterFilterCondition> colorGreaterThan(
      int? value) {
    return addFilterCondition(FilterCondition(
      type: ConditionType.Gt,
      property: 'color',
      value: value,
    ));
  }

  QueryBuilder<NoteCollection, QAfterFilterCondition> colorLessThan(
      int? value) {
    return addFilterCondition(FilterCondition(
      type: ConditionType.Lt,
      property: 'color',
      value: value,
    ));
  }

  QueryBuilder<NoteCollection, QAfterFilterCondition> colorBetween(
      int? lower, int? upper) {
    return addFilterCondition(FilterCondition.between(
      property: 'color',
      lower: lower,
      upper: upper,
    ));
  }

  QueryBuilder<NoteCollection, QAfterFilterCondition> descriptionIsNull() {
    return addFilterCondition(FilterCondition(
      type: ConditionType.Eq,
      property: 'description',
      value: null,
    ));
  }

  QueryBuilder<NoteCollection, QAfterFilterCondition> descriptionEqualTo(
      String? value,
      {bool caseSensitive = true}) {
    return addFilterCondition(FilterCondition(
      type: ConditionType.Eq,
      property: 'description',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<NoteCollection, QAfterFilterCondition> descriptionStartsWith(
      String? value,
      {bool caseSensitive = true}) {
    final convertedValue = value;
    assert(convertedValue != null, 'Null values are not allowed');
    return addFilterCondition(FilterCondition(
      type: ConditionType.StartsWith,
      property: 'description',
      value: convertedValue,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<NoteCollection, QAfterFilterCondition> descriptionEndsWith(
      String? value,
      {bool caseSensitive = true}) {
    final convertedValue = value;
    assert(convertedValue != null, 'Null values are not allowed');
    return addFilterCondition(FilterCondition(
      type: ConditionType.EndsWith,
      property: 'description',
      value: convertedValue,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<NoteCollection, QAfterFilterCondition> descriptionContains(
      String? value,
      {bool caseSensitive = true}) {
    final convertedValue = value;
    assert(convertedValue != null, 'Null values are not allowed');
    return addFilterCondition(FilterCondition(
      type: ConditionType.Matches,
      property: 'description',
      value: '*$convertedValue*',
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<NoteCollection, QAfterFilterCondition> descriptionMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return addFilterCondition(FilterCondition(
      type: ConditionType.Matches,
      property: 'description',
      value: pattern,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<NoteCollection, QAfterFilterCondition> pinIsNull() {
    return addFilterCondition(FilterCondition(
      type: ConditionType.Eq,
      property: 'pin',
      value: null,
    ));
  }

  QueryBuilder<NoteCollection, QAfterFilterCondition> pinEqualTo(bool? value) {
    return addFilterCondition(FilterCondition(
      type: ConditionType.Eq,
      property: 'pin',
      value: value,
    ));
  }
}

extension LastShownNoteCollectionQueryFilter
    on QueryBuilder<LastShownNoteCollection, QFilterCondition> {
  QueryBuilder<LastShownNoteCollection, QAfterFilterCondition> idIsNull() {
    return addFilterCondition(FilterCondition(
      type: ConditionType.Eq,
      property: 'id',
      value: null,
    ));
  }

  QueryBuilder<LastShownNoteCollection, QAfterFilterCondition> idEqualTo(
      int? value) {
    return addFilterCondition(FilterCondition(
      type: ConditionType.Eq,
      property: 'id',
      value: value,
    ));
  }

  QueryBuilder<LastShownNoteCollection, QAfterFilterCondition> idGreaterThan(
      int? value) {
    return addFilterCondition(FilterCondition(
      type: ConditionType.Gt,
      property: 'id',
      value: value,
    ));
  }

  QueryBuilder<LastShownNoteCollection, QAfterFilterCondition> idLessThan(
      int? value) {
    return addFilterCondition(FilterCondition(
      type: ConditionType.Lt,
      property: 'id',
      value: value,
    ));
  }

  QueryBuilder<LastShownNoteCollection, QAfterFilterCondition> idBetween(
      int? lower, int? upper) {
    return addFilterCondition(FilterCondition.between(
      property: 'id',
      lower: lower,
      upper: upper,
    ));
  }
}

extension MemoCollectionQueryLinks
    on QueryBuilder<MemoCollection, QFilterCondition> {}

extension NoteCollectionQueryLinks
    on QueryBuilder<NoteCollection, QFilterCondition> {}

extension LastShownNoteCollectionQueryLinks
    on QueryBuilder<LastShownNoteCollection, QFilterCondition> {
  QueryBuilder<LastShownNoteCollection, QAfterFilterCondition> note(
      FilterQuery<NoteCollection> q) {
    return linkInternal(
      isar.noteCollections,
      q,
      'note',
    );
  }
}

extension MemoCollectionQueryWhereSortBy
    on QueryBuilder<MemoCollection, QSortBy> {
  QueryBuilder<MemoCollection, QAfterSortBy> sortById() {
    return addSortByInternal('id', Sort.Asc);
  }

  QueryBuilder<MemoCollection, QAfterSortBy> sortByIdDesc() {
    return addSortByInternal('id', Sort.Desc);
  }

  QueryBuilder<MemoCollection, QAfterSortBy> sortByNoteId() {
    return addSortByInternal('noteId', Sort.Asc);
  }

  QueryBuilder<MemoCollection, QAfterSortBy> sortByNoteIdDesc() {
    return addSortByInternal('noteId', Sort.Desc);
  }

  QueryBuilder<MemoCollection, QAfterSortBy> sortByTitle() {
    return addSortByInternal('title', Sort.Asc);
  }

  QueryBuilder<MemoCollection, QAfterSortBy> sortByTitleDesc() {
    return addSortByInternal('title', Sort.Desc);
  }

  QueryBuilder<MemoCollection, QAfterSortBy> sortByCost() {
    return addSortByInternal('cost', Sort.Asc);
  }

  QueryBuilder<MemoCollection, QAfterSortBy> sortByCostDesc() {
    return addSortByInternal('cost', Sort.Desc);
  }

  QueryBuilder<MemoCollection, QAfterSortBy> sortByDate() {
    return addSortByInternal('date', Sort.Asc);
  }

  QueryBuilder<MemoCollection, QAfterSortBy> sortByDateDesc() {
    return addSortByInternal('date', Sort.Desc);
  }

  QueryBuilder<MemoCollection, QAfterSortBy> sortByDescription() {
    return addSortByInternal('description', Sort.Asc);
  }

  QueryBuilder<MemoCollection, QAfterSortBy> sortByDescriptionDesc() {
    return addSortByInternal('description', Sort.Desc);
  }

  QueryBuilder<MemoCollection, QAfterSortBy> sortByDone() {
    return addSortByInternal('done', Sort.Asc);
  }

  QueryBuilder<MemoCollection, QAfterSortBy> sortByDoneDesc() {
    return addSortByInternal('done', Sort.Desc);
  }
}

extension MemoCollectionQueryWhereSortThenBy
    on QueryBuilder<MemoCollection, QSortThenBy> {
  QueryBuilder<MemoCollection, QAfterSortBy> thenById() {
    return addSortByInternal('id', Sort.Asc);
  }

  QueryBuilder<MemoCollection, QAfterSortBy> thenByIdDesc() {
    return addSortByInternal('id', Sort.Desc);
  }

  QueryBuilder<MemoCollection, QAfterSortBy> thenByNoteId() {
    return addSortByInternal('noteId', Sort.Asc);
  }

  QueryBuilder<MemoCollection, QAfterSortBy> thenByNoteIdDesc() {
    return addSortByInternal('noteId', Sort.Desc);
  }

  QueryBuilder<MemoCollection, QAfterSortBy> thenByTitle() {
    return addSortByInternal('title', Sort.Asc);
  }

  QueryBuilder<MemoCollection, QAfterSortBy> thenByTitleDesc() {
    return addSortByInternal('title', Sort.Desc);
  }

  QueryBuilder<MemoCollection, QAfterSortBy> thenByCost() {
    return addSortByInternal('cost', Sort.Asc);
  }

  QueryBuilder<MemoCollection, QAfterSortBy> thenByCostDesc() {
    return addSortByInternal('cost', Sort.Desc);
  }

  QueryBuilder<MemoCollection, QAfterSortBy> thenByDate() {
    return addSortByInternal('date', Sort.Asc);
  }

  QueryBuilder<MemoCollection, QAfterSortBy> thenByDateDesc() {
    return addSortByInternal('date', Sort.Desc);
  }

  QueryBuilder<MemoCollection, QAfterSortBy> thenByDescription() {
    return addSortByInternal('description', Sort.Asc);
  }

  QueryBuilder<MemoCollection, QAfterSortBy> thenByDescriptionDesc() {
    return addSortByInternal('description', Sort.Desc);
  }

  QueryBuilder<MemoCollection, QAfterSortBy> thenByDone() {
    return addSortByInternal('done', Sort.Asc);
  }

  QueryBuilder<MemoCollection, QAfterSortBy> thenByDoneDesc() {
    return addSortByInternal('done', Sort.Desc);
  }
}

extension NoteCollectionQueryWhereSortBy
    on QueryBuilder<NoteCollection, QSortBy> {
  QueryBuilder<NoteCollection, QAfterSortBy> sortById() {
    return addSortByInternal('id', Sort.Asc);
  }

  QueryBuilder<NoteCollection, QAfterSortBy> sortByIdDesc() {
    return addSortByInternal('id', Sort.Desc);
  }

  QueryBuilder<NoteCollection, QAfterSortBy> sortByTitle() {
    return addSortByInternal('title', Sort.Asc);
  }

  QueryBuilder<NoteCollection, QAfterSortBy> sortByTitleDesc() {
    return addSortByInternal('title', Sort.Desc);
  }

  QueryBuilder<NoteCollection, QAfterSortBy> sortByColor() {
    return addSortByInternal('color', Sort.Asc);
  }

  QueryBuilder<NoteCollection, QAfterSortBy> sortByColorDesc() {
    return addSortByInternal('color', Sort.Desc);
  }

  QueryBuilder<NoteCollection, QAfterSortBy> sortByDescription() {
    return addSortByInternal('description', Sort.Asc);
  }

  QueryBuilder<NoteCollection, QAfterSortBy> sortByDescriptionDesc() {
    return addSortByInternal('description', Sort.Desc);
  }

  QueryBuilder<NoteCollection, QAfterSortBy> sortByPin() {
    return addSortByInternal('pin', Sort.Asc);
  }

  QueryBuilder<NoteCollection, QAfterSortBy> sortByPinDesc() {
    return addSortByInternal('pin', Sort.Desc);
  }
}

extension NoteCollectionQueryWhereSortThenBy
    on QueryBuilder<NoteCollection, QSortThenBy> {
  QueryBuilder<NoteCollection, QAfterSortBy> thenById() {
    return addSortByInternal('id', Sort.Asc);
  }

  QueryBuilder<NoteCollection, QAfterSortBy> thenByIdDesc() {
    return addSortByInternal('id', Sort.Desc);
  }

  QueryBuilder<NoteCollection, QAfterSortBy> thenByTitle() {
    return addSortByInternal('title', Sort.Asc);
  }

  QueryBuilder<NoteCollection, QAfterSortBy> thenByTitleDesc() {
    return addSortByInternal('title', Sort.Desc);
  }

  QueryBuilder<NoteCollection, QAfterSortBy> thenByColor() {
    return addSortByInternal('color', Sort.Asc);
  }

  QueryBuilder<NoteCollection, QAfterSortBy> thenByColorDesc() {
    return addSortByInternal('color', Sort.Desc);
  }

  QueryBuilder<NoteCollection, QAfterSortBy> thenByDescription() {
    return addSortByInternal('description', Sort.Asc);
  }

  QueryBuilder<NoteCollection, QAfterSortBy> thenByDescriptionDesc() {
    return addSortByInternal('description', Sort.Desc);
  }

  QueryBuilder<NoteCollection, QAfterSortBy> thenByPin() {
    return addSortByInternal('pin', Sort.Asc);
  }

  QueryBuilder<NoteCollection, QAfterSortBy> thenByPinDesc() {
    return addSortByInternal('pin', Sort.Desc);
  }
}

extension LastShownNoteCollectionQueryWhereSortBy
    on QueryBuilder<LastShownNoteCollection, QSortBy> {
  QueryBuilder<LastShownNoteCollection, QAfterSortBy> sortById() {
    return addSortByInternal('id', Sort.Asc);
  }

  QueryBuilder<LastShownNoteCollection, QAfterSortBy> sortByIdDesc() {
    return addSortByInternal('id', Sort.Desc);
  }
}

extension LastShownNoteCollectionQueryWhereSortThenBy
    on QueryBuilder<LastShownNoteCollection, QSortThenBy> {
  QueryBuilder<LastShownNoteCollection, QAfterSortBy> thenById() {
    return addSortByInternal('id', Sort.Asc);
  }

  QueryBuilder<LastShownNoteCollection, QAfterSortBy> thenByIdDesc() {
    return addSortByInternal('id', Sort.Desc);
  }
}

extension MemoCollectionQueryWhereDistinct
    on QueryBuilder<MemoCollection, QDistinct> {
  QueryBuilder<MemoCollection, QDistinct> distinctById() {
    return addDistinctByInternal('id');
  }

  QueryBuilder<MemoCollection, QDistinct> distinctByNoteId() {
    return addDistinctByInternal('noteId');
  }

  QueryBuilder<MemoCollection, QDistinct> distinctByTitle(
      {bool caseSensitive = true}) {
    return addDistinctByInternal('title', caseSensitive: caseSensitive);
  }

  QueryBuilder<MemoCollection, QDistinct> distinctByCost() {
    return addDistinctByInternal('cost');
  }

  QueryBuilder<MemoCollection, QDistinct> distinctByDate() {
    return addDistinctByInternal('date');
  }

  QueryBuilder<MemoCollection, QDistinct> distinctByDescription(
      {bool caseSensitive = true}) {
    return addDistinctByInternal('description', caseSensitive: caseSensitive);
  }

  QueryBuilder<MemoCollection, QDistinct> distinctByDone() {
    return addDistinctByInternal('done');
  }
}

extension NoteCollectionQueryWhereDistinct
    on QueryBuilder<NoteCollection, QDistinct> {
  QueryBuilder<NoteCollection, QDistinct> distinctById() {
    return addDistinctByInternal('id');
  }

  QueryBuilder<NoteCollection, QDistinct> distinctByTitle(
      {bool caseSensitive = true}) {
    return addDistinctByInternal('title', caseSensitive: caseSensitive);
  }

  QueryBuilder<NoteCollection, QDistinct> distinctByColor() {
    return addDistinctByInternal('color');
  }

  QueryBuilder<NoteCollection, QDistinct> distinctByDescription(
      {bool caseSensitive = true}) {
    return addDistinctByInternal('description', caseSensitive: caseSensitive);
  }

  QueryBuilder<NoteCollection, QDistinct> distinctByPin() {
    return addDistinctByInternal('pin');
  }
}

extension LastShownNoteCollectionQueryWhereDistinct
    on QueryBuilder<LastShownNoteCollection, QDistinct> {
  QueryBuilder<LastShownNoteCollection, QDistinct> distinctById() {
    return addDistinctByInternal('id');
  }
}

extension MemoCollectionQueryProperty
    on QueryBuilder<MemoCollection, QQueryProperty> {
  QueryBuilder<int?, QQueryOperations> idProperty() {
    return addPropertyName('id');
  }

  QueryBuilder<int?, QQueryOperations> noteIdProperty() {
    return addPropertyName('noteId');
  }

  QueryBuilder<String?, QQueryOperations> titleProperty() {
    return addPropertyName('title');
  }

  QueryBuilder<int?, QQueryOperations> costProperty() {
    return addPropertyName('cost');
  }

  QueryBuilder<DateTime?, QQueryOperations> dateProperty() {
    return addPropertyName('date');
  }

  QueryBuilder<String?, QQueryOperations> descriptionProperty() {
    return addPropertyName('description');
  }

  QueryBuilder<bool?, QQueryOperations> doneProperty() {
    return addPropertyName('done');
  }
}

extension NoteCollectionQueryProperty
    on QueryBuilder<NoteCollection, QQueryProperty> {
  QueryBuilder<int?, QQueryOperations> idProperty() {
    return addPropertyName('id');
  }

  QueryBuilder<String?, QQueryOperations> titleProperty() {
    return addPropertyName('title');
  }

  QueryBuilder<int?, QQueryOperations> colorProperty() {
    return addPropertyName('color');
  }

  QueryBuilder<String?, QQueryOperations> descriptionProperty() {
    return addPropertyName('description');
  }

  QueryBuilder<bool?, QQueryOperations> pinProperty() {
    return addPropertyName('pin');
  }
}

extension LastShownNoteCollectionQueryProperty
    on QueryBuilder<LastShownNoteCollection, QQueryProperty> {
  QueryBuilder<int?, QQueryOperations> idProperty() {
    return addPropertyName('id');
  }
}
