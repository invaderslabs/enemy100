#!/bin/bash

# comprehensive-content-types-create.sh - Strapi Content Types Creator
# Generated automatically for Blog and 3 complementary content type(s)
# Created: $(date)

API_DIR="/srv/app/src/api"

echo "🚀 Starting creation of 4 content type(s)..."

# Create Author content type
create_author_content_type() {
    local name="author"
    local display_name="Author"
    
    echo "Creating Author content type..."
    
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

    echo "✅ Created Author content type"
}

# Create Category content type
create_category_content_type() {
    local name="category"
    local display_name="Category"
    
    echo "Creating Category content type..."
    
    # Create directories
    mkdir -p "$API_DIR/$name/content-types/$name"
    mkdir -p "$API_DIR/$name/controllers"
    mkdir -p "$API_DIR/$name/routes" 
    mkdir -p "$API_DIR/$name/services"
    
    # Create schema.json
    cat > "$API_DIR/$name/content-types/$name/schema.json" << EOF
{
  "kind": "collectionType",
  "collectionName": "categories",
  "info": {
    "singularName": "category",
    "pluralName": "categories",
    "displayName": "Category",
    "description": "Blog post categories"
  },
  "options": {
    "draftAndPublish": false
  },
  "attributes": {
    "name": { "type": "string", "required": true },
    "slug": { "type": "uid", "targetField": "name" },
    "description": { "type": "text" },
    "color": { "type": "string" },
    "icon": { "type": "string" },
    "parentCategory": { "type": "relation", "relation": "manyToOne", "target": "api::category.category" },
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

    echo "✅ Created Category content type"
}

# Create Tag content type
create_tag_content_type() {
    local name="tag"
    local display_name="Tag"
    
    echo "Creating Tag content type..."
    
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

    echo "✅ Created Tag content type"
}

# Create Blog content type
create_blog_content_type() {
    local name="blog"
    local display_name="Blog"
    
    echo "Creating Blog content type..."
    
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

    echo "✅ Created Blog content type"
}

# Main execution - create all content types in correct order
echo "📋 Creating complementary content types first..."

create_author_content_type
create_category_content_type
create_tag_content_type

echo "📋 Creating main content type..."
create_blog_content_type

echo ""
echo "🎉 All content types created successfully!"
echo "📁 Files created in: $API_DIR/"
echo "🔄 Restart Strapi to see all new content types in the admin panel"
echo ""
echo "📊 Summary:"
echo "   - Main: Blog (19 fields)
   - Author (8 fields)
   - Category (7 fields)
   - Tag (5 fields)
echo ""
echo "✅ Your Strapi instance is now ready with all required content types!"
