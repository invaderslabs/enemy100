#!/bin/bash

# author-create.sh - Strapi Content Type Creator for Author
# Generated automatically from schema: authors
# Fields: 8 | Created: $(date)

API_DIR="/srv/app/src/api"

create_content_type() {
    local name="author"
    local display_name="Author"
    
    # Create directories
    mkdir -p "$API_DIR/$name/content-types/$name"
    mkdir -p "$API_DIR/$name/controllers"
    mkdir -p "$API_DIR/$name/routes" 
    mkdir -p "$API_DIR/$name/services"
    
    # Create schema.json
    cat > "$API_DIR/$name/content-types/$name/schema.json" << EOF
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
    "name": { "type": "string", "required": true },
    "slug": { "type": "uid", "targetField": "name" },
    "email": { "type": "email", "required": true },
    "bio": { "type": "text", "maxLength": 1000 },
    "avatar": { "type": "media", "allowedTypes": ["images"] },
    "socialLinks": { "type": "json" },
    "isActive": { "type": "boolean", "default": true },
    "blogs": { "type": "relation", "relation": "oneToMany", "target": "api::blog.blog" }
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

echo "Content type 'author' created successfully!"
echo "📁 Files created in: $API_DIR/author/"
echo "🔄 Restart Strapi to see the new content type in the admin panel"
