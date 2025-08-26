#!/bin/bash

# blog-create.sh - Strapi Content Type Creator for Blog
# Generated automatically from schema: blogs
# Fields: 20 | Created: $(date)

API_DIR="/srv/app/src/api"

create_content_type() {
    local name="blog"
    local display_name="Blog"
    
    # Create directories
    mkdir -p "$API_DIR/$name/content-types/$name"
    mkdir -p "$API_DIR/$name/controllers"
    mkdir -p "$API_DIR/$name/routes" 
    mkdir -p "$API_DIR/$name/services"
    
    # Create schema.json
    cat > "$API_DIR/$name/content-types/$name/schema.json" << EOF
{
  "kind": "collectionType",
  "collectionName": "blogs",
  "info": {
    "singularName": "blog",
    "pluralName": "blogs",
    "displayName": "Blog",
    "description": "Complete blog content type with SEO and rich content features"
  },
  "options": {
    "draftAndPublish": true,
    "timestamps": true
  },
  "attributes": {
    "title": { "type": "string", "required": true, "maxLength": 255 },
    "slug": { "type": "uid", "required": true, "targetField": "title" },
    "excerpt": { "type": "text", "maxLength": 500 },
    "content": { "type": "richtext", "required": true },
    "coverImage": { "type": "media", "allowedTypes": ["images"] },
    "gallery": { "type": "media", "multiple": true, "allowedTypes": ["images"] },
    "readingTime": { "type": "integer", "min": 1 },
    "featured": { "type": "boolean", "default": false },
    "publishedDate": { "type": "datetime" },
    "author": { "type": "relation", "relation": "manyToOne", "target": "api::author.author", "inversedBy": "blogs" },
    "categories": { "type": "relation", "relation": "manyToMany", "target": "api::category.category", "inversedBy": "blogs" },
    "tags": { "type": "relation", "relation": "manyToMany", "target": "api::tag.tag", "inversedBy": "blogs" },
    "relatedPosts": { "type": "relation", "relation": "manyToMany", "target": "api::blog.blog" },
    "seo": { "type": "component" },
    "tableOfContents": { "type": "json" },
    "status": { "type": "enumeration", "default": "draft", "enum": ["draft","published","archived"] },
    "viewCount": { "type": "integer", "default": 0 },
    "likes": { "type": "integer", "default": 0 },
    "commentsEnabled": { "type": "boolean", "default": true },
    "locale": { "type": "string" }
  }
}
EOF

    # Create controller
    cat > "$API_DIR/$name/controllers/$name.js" << EOF
const { createCoreController } = require('@strapi/strapi').factories;
module.exports = createCoreController('api::$name.$name');
EOF

    # Create routes
    cat > "$API_DIR/$name/routes/$name.js" << EOF
const { createCoreRouter } = require('@strapi/strapi').factories;
module.exports = createCoreRouter('api::$name.$name');
EOF

    # Create service
    cat > "$API_DIR/$name/services/$name.js" << EOF
const { createCoreService } = require('@strapi/strapi').factories;
module.exports = createCoreService('api::$name.$name');
EOF

    echo "Created content-type: $name"
}

# Create the content type
create_content_type

echo "Content type 'blog' created successfully!"
echo "📁 Files created in: $API_DIR/blog/"
echo "🔄 Restart Strapi to see the new content type in the admin panel"
