#!/bin/bash

# tag-create.sh - Strapi Content Type Creator for Tag
# Generated automatically from schema: tags
# Fields: 5 | Created: $(date)

API_DIR="/srv/app/src/api"

create_content_type() {
    local name="tag"
    local display_name="Tag"
    
    # Create directories
    mkdir -p "$API_DIR/$name/content-types/$name"
    mkdir -p "$API_DIR/$name/controllers"
    mkdir -p "$API_DIR/$name/routes" 
    mkdir -p "$API_DIR/$name/services"
    
    # Create schema.json
    cat > "$API_DIR/$name/content-types/$name/schema.json" << EOF
{
  "kind": "collectionType",
  "collectionName": "tags",
  "info": {
    "singularName": "tag",
    "pluralName": "tags",
    "displayName": "Tag",
    "description": "Blog post tags"
  },
  "options": {
    "draftAndPublish": false
  },
  "attributes": {
    "name": { "type": "string", "required": true },
    "slug": { "type": "uid", "targetField": "name" },
    "description": { "type": "text" },
    "color": { "type": "string" },
    "blogs": { "type": "relation", "relation": "manyToMany", "target": "api::blog.blog" }
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

echo "Content type 'tag' created successfully!"
echo "📁 Files created in: $API_DIR/tag/"
echo "🔄 Restart Strapi to see the new content type in the admin panel"
