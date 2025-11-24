/*
* Copyright 2021 Amazon.com, Inc. or its affiliates. All Rights Reserved.
*
* Licensed under the Apache License, Version 2.0 (the "License").
* You may not use this file except in compliance with the License.
* A copy of the License is located at
*
*  http://aws.amazon.com/apache2.0
*
* or in the "license" file accompanying this file. This file is distributed
* on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either
* express or implied. See the License for the specific language governing
* permissions and limitations under the License.
*/

// NOTE: This file is generated and may not follow lint rules defined in your app
// Generated files can be excluded from analysis in analysis_options.yaml
// For more info, see: https://dart.dev/guides/language/analysis-options#excluding-code-from-analysis

// ignore_for_file: public_member_api_docs, annotate_overrides, dead_code, dead_codepublic_member_api_docs, depend_on_referenced_packages, file_names, library_private_types_in_public_api, no_leading_underscores_for_library_prefixes, no_leading_underscores_for_local_identifiers, non_constant_identifier_names, null_check_on_nullable_type_parameter, override_on_non_overriding_member, prefer_adjacent_string_concatenation, prefer_const_constructors, prefer_if_null_operators, prefer_interpolation_to_compose_strings, slash_for_doc_comments, sort_child_properties_last, unnecessary_const, unnecessary_constructor_name, unnecessary_late, unnecessary_new, unnecessary_null_aware_assignments, unnecessary_nullable_for_final_variable_declarations, unnecessary_string_interpolations, use_build_context_synchronously

import 'ModelProvider.dart';
import 'package:amplify_core/amplify_core.dart' as amplify_core;


/** This is an auto generated class representing the PostTag type in your schema. */
class PostTag extends amplify_core.Model {
  static const classType = const _PostTagModelType();
  final String id;
  final String? _tagName;
  final String? _postId;
  final Post? _post;
  final amplify_core.TemporalDateTime? _createdAt;
  final amplify_core.TemporalDateTime? _updatedAt;

  @override
  getInstanceType() => classType;
  
  @Deprecated('[getId] is being deprecated in favor of custom primary key feature. Use getter [modelIdentifier] to get model identifier.')
  @override
  String getId() => id;
  
  PostTagModelIdentifier get modelIdentifier {
      return PostTagModelIdentifier(
        id: id
      );
  }
  
  String get tagName {
    try {
      return _tagName!;
    } catch(e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  String get postId {
    try {
      return _postId!;
    } catch(e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  Post? get post {
    return _post;
  }
  
  amplify_core.TemporalDateTime get createdAt {
    try {
      return _createdAt!;
    } catch(e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  amplify_core.TemporalDateTime get updatedAt {
    try {
      return _updatedAt!;
    } catch(e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  const PostTag._internal({required this.id, required tagName, required postId, post, required createdAt, required updatedAt}): _tagName = tagName, _postId = postId, _post = post, _createdAt = createdAt, _updatedAt = updatedAt;
  
  factory PostTag({String? id, required String tagName, required String postId, Post? post, required amplify_core.TemporalDateTime createdAt, required amplify_core.TemporalDateTime updatedAt}) {
    return PostTag._internal(
      id: id == null ? amplify_core.UUID.getUUID() : id,
      tagName: tagName,
      postId: postId,
      post: post,
      createdAt: createdAt,
      updatedAt: updatedAt);
  }
  
  bool equals(Object other) {
    return this == other;
  }
  
  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is PostTag &&
      id == other.id &&
      _tagName == other._tagName &&
      _postId == other._postId &&
      _post == other._post &&
      _createdAt == other._createdAt &&
      _updatedAt == other._updatedAt;
  }
  
  @override
  int get hashCode => toString().hashCode;
  
  @override
  String toString() {
    var buffer = new StringBuffer();
    
    buffer.write("PostTag {");
    buffer.write("id=" + "$id" + ", ");
    buffer.write("tagName=" + "$_tagName" + ", ");
    buffer.write("postId=" + "$_postId" + ", ");
    buffer.write("createdAt=" + (_createdAt != null ? _createdAt!.format() : "null") + ", ");
    buffer.write("updatedAt=" + (_updatedAt != null ? _updatedAt!.format() : "null"));
    buffer.write("}");
    
    return buffer.toString();
  }
  
  PostTag copyWith({String? tagName, String? postId, Post? post, amplify_core.TemporalDateTime? createdAt, amplify_core.TemporalDateTime? updatedAt}) {
    return PostTag._internal(
      id: id,
      tagName: tagName ?? this.tagName,
      postId: postId ?? this.postId,
      post: post ?? this.post,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt);
  }
  
  PostTag copyWithModelFieldValues({
    ModelFieldValue<String>? tagName,
    ModelFieldValue<String>? postId,
    ModelFieldValue<Post?>? post,
    ModelFieldValue<amplify_core.TemporalDateTime>? createdAt,
    ModelFieldValue<amplify_core.TemporalDateTime>? updatedAt
  }) {
    return PostTag._internal(
      id: id,
      tagName: tagName == null ? this.tagName : tagName.value,
      postId: postId == null ? this.postId : postId.value,
      post: post == null ? this.post : post.value,
      createdAt: createdAt == null ? this.createdAt : createdAt.value,
      updatedAt: updatedAt == null ? this.updatedAt : updatedAt.value
    );
  }
  
  PostTag.fromJson(Map<String, dynamic> json)  
    : id = json['id'],
      _tagName = json['tagName'],
      _postId = json['postId'],
      _post = json['post'] != null
        ? json['post']['serializedData'] != null
          ? Post.fromJson(new Map<String, dynamic>.from(json['post']['serializedData']))
          : Post.fromJson(new Map<String, dynamic>.from(json['post']))
        : null,
      _createdAt = json['createdAt'] != null ? amplify_core.TemporalDateTime.fromString(json['createdAt']) : null,
      _updatedAt = json['updatedAt'] != null ? amplify_core.TemporalDateTime.fromString(json['updatedAt']) : null;
  
  Map<String, dynamic> toJson() => {
    'id': id, 'tagName': _tagName, 'postId': _postId, 'post': _post?.toJson(), 'createdAt': _createdAt?.format(), 'updatedAt': _updatedAt?.format()
  };
  
  Map<String, Object?> toMap() => {
    'id': id,
    'tagName': _tagName,
    'postId': _postId,
    'post': _post,
    'createdAt': _createdAt,
    'updatedAt': _updatedAt
  };

  static final amplify_core.QueryModelIdentifier<PostTagModelIdentifier> MODEL_IDENTIFIER = amplify_core.QueryModelIdentifier<PostTagModelIdentifier>();
  static final ID = amplify_core.QueryField(fieldName: "id");
  static final TAGNAME = amplify_core.QueryField(fieldName: "tagName");
  static final POSTID = amplify_core.QueryField(fieldName: "postId");
  static final POST = amplify_core.QueryField(
    fieldName: "post",
    fieldType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.model, ofModelName: 'Post'));
  static final CREATEDAT = amplify_core.QueryField(fieldName: "createdAt");
  static final UPDATEDAT = amplify_core.QueryField(fieldName: "updatedAt");
  static var schema = amplify_core.Model.defineSchema(define: (amplify_core.ModelSchemaDefinition modelSchemaDefinition) {
    modelSchemaDefinition.name = "PostTag";
    modelSchemaDefinition.pluralName = "PostTags";
    
    modelSchemaDefinition.authRules = [
      amplify_core.AuthRule(
        authStrategy: amplify_core.AuthStrategy.PUBLIC,
        operations: const [
          amplify_core.ModelOperation.CREATE,
          amplify_core.ModelOperation.UPDATE,
          amplify_core.ModelOperation.DELETE,
          amplify_core.ModelOperation.READ
        ])
    ];
    
    modelSchemaDefinition.indexes = [
      amplify_core.ModelIndex(fields: const ["tagName", "createdAt"], name: "byTag")
    ];
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.id());
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: PostTag.TAGNAME,
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: PostTag.POSTID,
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.hasOne(
      key: PostTag.POST,
      isRequired: false,
      ofModelName: 'Post',
      associatedKey: Post.ID
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: PostTag.CREATEDAT,
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.dateTime)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: PostTag.UPDATEDAT,
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.dateTime)
    ));
  });
}

class _PostTagModelType extends amplify_core.ModelType<PostTag> {
  const _PostTagModelType();
  
  @override
  PostTag fromJson(Map<String, dynamic> jsonData) {
    return PostTag.fromJson(jsonData);
  }
  
  @override
  String modelName() {
    return 'PostTag';
  }
}

/**
 * This is an auto generated class representing the model identifier
 * of [PostTag] in your schema.
 */
class PostTagModelIdentifier implements amplify_core.ModelIdentifier<PostTag> {
  final String id;

  /** Create an instance of PostTagModelIdentifier using [id] the primary key. */
  const PostTagModelIdentifier({
    required this.id});
  
  @override
  Map<String, dynamic> serializeAsMap() => (<String, dynamic>{
    'id': id
  });
  
  @override
  List<Map<String, dynamic>> serializeAsList() => serializeAsMap()
    .entries
    .map((entry) => (<String, dynamic>{ entry.key: entry.value }))
    .toList();
  
  @override
  String serializeAsString() => serializeAsMap().values.join('#');
  
  @override
  String toString() => 'PostTagModelIdentifier(id: $id)';
  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    
    return other is PostTagModelIdentifier &&
      id == other.id;
  }
  
  @override
  int get hashCode =>
    id.hashCode;
}