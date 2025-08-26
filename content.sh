{
  "kind": "collectionType",
  "collectionName": "authors",
  "info": {
    "singularName": "author",
    "pluralName": "authors",
    "displayName": "Author",
    "description": "Blog authors and contributors"
  },
  "options": {
    "draftAndPublish": false
  },
  "attributes": {
    "name": {
      "type": "string",
      "required": true
    },
    "slug": {
      "type": "uid",
      "targetField": "name"
    },
    "email": {
      "type": "email",
      "required": true,
      "unique": true
    },
    "bio": {
      "type": "text",
      "maxLength": 1000
    },
    "avatar": {
      "type": "media",
      "multiple": false,
      "allowedTypes": ["images"]
    },
    "socialLinks": {
      "type": "json"
    },
    "isActive": {
      "type": "boolean",
      "default": true
    },
    "blogs": {
      "type": "relation",
      "relation": "oneToMany",
      "target": "api::blog.blog",
      "mappedBy": "author"
    }
  }
}
