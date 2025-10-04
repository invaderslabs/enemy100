#!/bin/bash
# strapi-content-type-manager.sh
# Generic Strapi content type creation/update script

# Usage: ./strapi-content-type-manager.sh <content-type-name> <schema-file.json> [action]
# Examples:
#   ./strapi-content-type-manager.sh ransomware-tracker ransomware-tracker-groups-schema-update.json update
#   ./strapi-content-type-manager.sh victim victims-schema.json create
#   ./strapi-content-type-manager.sh group-location group-locations-schema.json create

# Default values
ACTION="update"  # Default action is update
BASE_PATH="/srv/app/src/api"

# Function to display usage
show_usage() {
    echo "🚀 Strapi Content Type Manager"
    echo ""
    echo "Usage: $0 <content-type-name> <schema-file.json> [action]"
    echo ""
    echo "Parameters:"
    echo "  content-type-name  : Name of the Strapi content type (e.g., 'ransomware-tracker', 'victim')"
    echo "  schema-file.json   : Path to the JSON schema file"
    echo "  action            : 'create' or 'update' (default: update)"
    echo ""
    echo "Examples:"
    echo "  $0 ransomware-tracker ransomware-tracker-groups-schema-update.json update"
    echo "  $0 victim victims-schema.json create"
    echo "  $0 group-location group-locations-schema.json create"
    echo "  $0 infostealer-data infostealer-data-schema.json create"
    echo ""
    echo "Actions:"
    echo "  create  : Create a new content type (will fail if it already exists)"
    echo "  update  : Update existing content type (will fail if it doesn't exist)"
    echo ""
    echo "Required Files:"
    echo "  - Schema JSON file must exist"
    echo "  - For 'update': Content type directory must exist"
    echo "  - For 'create': Content type directory must NOT exist"
}

# Function to validate JSON file
validate_json() {
    local json_file="$1"
    
    if [ ! -f "$json_file" ]; then
        echo "❌ Error: JSON file '$json_file' not found!"
        return 1
    fi
    
    # Check if it's valid JSON
    if ! python3 -m json.tool "$json_file" > /dev/null 2>&1; then
        echo "❌ Error: '$json_file' is not valid JSON!"
        return 1
    fi
    
    # Check if it has required fields
    if ! grep -q '"kind"' "$json_file" || ! grep -q '"info"' "$json_file" || ! grep -q '"attributes"' "$json_file"; then
        echo "❌ Error: '$json_file' is not a valid Strapi schema file!"
        echo "   Required fields: kind, info, attributes"
        return 1
    fi
    
    echo "✅ JSON file validation passed"
    return 0
}

# Function to extract content type info from JSON
extract_content_type_info() {
    local json_file="$1"
    
    # Extract singular and plural names
    SINGULAR_NAME=$(python3 -c "import json; data=json.load(open('$json_file')); print(data['info']['singularName'])" 2>/dev/null)
    PLURAL_NAME=$(python3 -c "import json; data=json.load(open('$json_file')); print(data['info']['pluralName'])" 2>/dev/null)
    DISPLAY_NAME=$(python3 -c "import json; data=json.load(open('$json_file')); print(data['info']['displayName'])" 2>/dev/null)
    COLLECTION_NAME=$(python3 -c "import json; data=json.load(open('$json_file')); print(data['kind'])" 2>/dev/null)
    
    if [ -z "$SINGULAR_NAME" ] || [ -z "$PLURAL_NAME" ]; then
        echo "❌ Error: Could not extract content type info from JSON file"
        return 1
    fi
    
    echo "📋 Content Type Info:"
    echo "   Singular Name: $SINGULAR_NAME"
    echo "   Plural Name: $PLURAL_NAME"
    echo "   Display Name: $DISPLAY_NAME"
    echo "   Collection Type: $COLLECTION_NAME"
}

# Function to create content type directory structure
create_content_type_structure() {
    local content_type="$1"
    
    echo "📁 Creating content type directory structure..."
    
    # Create main directory
    mkdir -p "$BASE_PATH/$content_type"
    
    # Create subdirectories (matching original structure)
    mkdir -p "$BASE_PATH/$content_type/content-types/$content_type"
    mkdir -p "$BASE_PATH/$content_type/controllers"
    mkdir -p "$BASE_PATH/$content_type/services"
    mkdir -p "$BASE_PATH/$content_type/routes"
    mkdir -p "$BASE_PATH/$content_type/middlewares"
    mkdir -p "$BASE_PATH/$content_type/policies"
    mkdir -p "$BASE_PATH/$content_type/migrations"
    mkdir -p "$BASE_PATH/$content_type/tests"
    
    echo "✅ Directory structure created"
}

# Function to create basic controller
create_controller() {
    local content_type="$1"
    
    echo "🎮 Creating controller..."
    
    cat > "$BASE_PATH/$content_type/controllers/$content_type.js" << CONTROLLER_EOF
'use strict';

/**
 * $content_type controller
 */

const { createCoreController } = require('@strapi/strapi').factories;

module.exports = createCoreController('api::$content_type.$content_type');
CONTROLLER_EOF
    
    echo "✅ Controller created"
}

# Function to create basic service
create_service() {
    local content_type="$1"
    
    echo "⚙️ Creating service..."
    
    cat > "$BASE_PATH/$content_type/services/$content_type.js" << SERVICE_EOF
'use strict';

/**
 * $content_type service
 */

const { createCoreService } = require('@strapi/strapi').factories;

module.exports = createCoreService('api::$content_type.$content_type');
SERVICE_EOF
    
    echo "✅ Service created"
}

# Function to create basic routes
create_routes() {
    local content_type="$1"
    
    echo "🛣️ Creating routes..."
    
    cat > "$BASE_PATH/$content_type/routes/$content_type.js" << ROUTES_EOF
'use strict';

/**
 * $content_type router
 */

const { createCoreRouter } = require('@strapi/strapi').factories;

module.exports = createCoreRouter('api::$content_type.$content_type');
ROUTES_EOF
    
    echo "✅ Routes created"
}

# Function to create middlewares (matching original structure)
create_middlewares() {
    local content_type="$1"
    
    echo "🔧 Creating middlewares..."
    
    cat > "$BASE_PATH/$content_type/middlewares/index.js" << MIDDLEWARE_EOF
'use strict';

/**
 * $content_type middlewares
 */

module.exports = {
  // Rate limiting to prevent abuse
  rateLimit: async (ctx, next) => {
    // Simple rate limiting: 100 requests per minute per IP
    const ip = ctx.request.ip;
    const key = \`rate_limit_\${ip}\`;
    
    // Get current count from memory (in production, use Redis)
    const currentCount = strapi.cache.get(key) || 0;
    
    if (currentCount >= 100) {
      ctx.throw(429, 'Too many requests. Please try again later.');
    }
    
    // Increment counter
    strapi.cache.set(key, currentCount + 1, 60); // 60 seconds TTL
    
    await next();
  },
  
  // CORS for frontend integration
  cors: async (ctx, next) => {
    ctx.set('Access-Control-Allow-Origin', '*');
    ctx.set('Access-Control-Allow-Methods', 'GET, POST, PUT, DELETE, OPTIONS');
    ctx.set('Access-Control-Allow-Headers', 'Content-Type, Authorization, X-Requested-With');
    ctx.set('Access-Control-Max-Age', '86400'); // 24 hours
    
    if (ctx.method === 'OPTIONS') {
      ctx.status = 200;
      return;
    }
    
    await next();
  },
  
  // Request logging for security monitoring
  logging: async (ctx, next) => {
    const start = Date.now();
    const ip = ctx.request.ip;
    const userAgent = ctx.request.headers['user-agent'];
    
    await next();
    
    const duration = Date.now() - start;
    const logData = {
      method: ctx.method,
      url: ctx.url,
      status: ctx.status,
      duration: \`\${duration}ms\`,
      ip: ip,
      userAgent: userAgent,
      timestamp: new Date().toISOString()
    };
    
    // Log to Strapi logger
    strapi.log.info(\`[$content_type] \${JSON.stringify(logData)}\`);
    
    // Log suspicious activity
    if (ctx.status >= 400 || duration > 5000) {
      strapi.log.warn(\`[$content_type-SUSPICIOUS] \${JSON.stringify(logData)}\`);
    }
  },
  
  // Security headers
  securityHeaders: async (ctx, next) => {
    ctx.set('X-Content-Type-Options', 'nosniff');
    ctx.set('X-Frame-Options', 'DENY');
    ctx.set('X-XSS-Protection', '1; mode=block');
    ctx.set('Referrer-Policy', 'strict-origin-when-cross-origin');
    
    await next();
  }
};
MIDDLEWARE_EOF
    
    echo "✅ Middlewares created"
}

# Function to create migration template
create_migration_template() {
    local content_type="$1"
    local singular_name="$2"
    
    echo "📊 Creating migration template..."
    
    cat > "$BASE_PATH/$content_type/migrations/initial-migration.js" << MIGRATION_EOF
'use strict';

/**
 * Initial migration for $content_type
 * This migration runs when the content type is first created
 */

module.exports = {
  async up(knex) {
    // Add any initial data or table modifications here
    console.log('✅ Initial migration for $content_type completed');
  },

  async down(knex) {
    // Add rollback logic here
    console.log('🔄 Initial migration for $content_type rolled back');
  },
};
MIGRATION_EOF
    
    echo "✅ Migration template created"
}

# Function to create test template
create_test_template() {
    local content_type="$1"
    local singular_name="$2"
    
    echo "🧪 Creating test template..."
    
    cat > "$BASE_PATH/$content_type/tests/test-$content_type.js" << TEST_EOF
'use strict';

/**
 * Test suite for $content_type
 */

const request = require('supertest');
const strapi = require('@strapi/strapi');

describe('$content_type API', () => {
  let app;

  beforeAll(async () => {
    app = await strapi().load();
  });

  afterAll(async () => {
    await app.destroy();
  });

  test('Should fetch $content_type records', async () => {
    const response = await request(app.server)
      .get('/api/$content_type')
      .expect(200);

    expect(response.body.data).toBeDefined();
    expect(Array.isArray(response.body.data)).toBe(true);
  });

  test('Should handle pagination', async () => {
    const response = await request(app.server)
      .get('/api/$content_type?pagination[page]=1&pagination[pageSize]=5')
      .expect(200);

    expect(response.body.meta).toBeDefined();
    expect(response.body.meta.pagination).toBeDefined();
  });
});
TEST_EOF
    
    echo "✅ Test template created"
}

# Function to update existing content type
update_content_type() {
    local content_type="$1"
    local json_file="$2"
    local singular_name="$3"
    
    echo "🔄 Updating existing content type..."
    
    # Backup existing schema
    if [ -f "$BASE_PATH/$content_type/content-types/$singular_name/schema.json" ]; then
        cp "$BASE_PATH/$content_type/content-types/$singular_name/schema.json" \
           "$BASE_PATH/$content_type/content-types/$singular_name/schema.json.backup.$(date +%Y%m%d_%H%M%S)"
        echo "✅ Schema backup created"
    else
        echo "❌ Error: Existing schema file not found!"
        return 1
    fi
    
    # Update schema
    cp "$json_file" "$BASE_PATH/$content_type/content-types/$singular_name/schema.json"
    echo "✅ Schema updated"
    
    # Backup and update controller if it exists
    if [ -f "$BASE_PATH/$content_type/controllers/$content_type.js" ]; then
        cp "$BASE_PATH/$content_type/controllers/$content_type.js" \
           "$BASE_PATH/$content_type/controllers/$content_type.js.backup.$(date +%Y%m%d_%H%M%S)"
        echo "✅ Controller backup created"
    fi
    
    # Backup and update service if it exists
    if [ -f "$BASE_PATH/$content_type/services/$content_type.js" ]; then
        cp "$BASE_PATH/$content_type/services/$content_type.js" \
           "$BASE_PATH/$content_type/services/$content_type.js.backup.$(date +%Y%m%d_%H%M%S)"
        echo "✅ Service backup created"
    fi
}

# Function to create new content type
create_content_type() {
    local content_type="$1"
    local json_file="$2"
    local singular_name="$3"
    
    echo "🆕 Creating new content type..."
    
    # Create directory structure
    create_content_type_structure "$content_type"
    
    # Copy schema (matching original structure)
    cp "$json_file" "$BASE_PATH/$content_type/content-types/$content_type/schema.json"
    echo "✅ Schema created"
    
    # Create basic files
    create_controller "$content_type"
    create_service "$content_type"
    create_routes "$content_type"
    create_middlewares "$content_type"
    create_migration_template "$content_type"
    create_test_template "$content_type"
}

# Function to set permissions
set_permissions() {
    local content_type="$1"
    local singular_name="$2"
    
    echo "🔐 Setting proper permissions..."
    
    # Set permissions for all files
    find "$BASE_PATH/$content_type" -type f -exec chmod 644 {} \;
    
    # Set permissions for directories
    find "$BASE_PATH/$content_type" -type d -exec chmod 755 {} \;
    
    echo "✅ Permissions set"
}

# Function to show success message
show_success_message() {
    local content_type="$1"
    local action="$2"
    local singular_name="$3"
    local display_name="$4"
    
    echo ""
    echo "🎉 Strapi Content Type $action Completed Successfully!"
    echo ""
    echo "📋 Content Type Details:"
    echo "   Name: $content_type"
    echo "   Singular: $singular_name"
    echo "   Display: $display_name"
    echo "   Action: $action"
    echo ""
    echo "📁 Files Created/Updated:"
    echo "   ✅ Schema: $BASE_PATH/$content_type/content-types/$singular_name/schema.json"
    echo "   ✅ Controller: $BASE_PATH/$content_type/controllers/$content_type.js"
    echo "   ✅ Service: $BASE_PATH/$content_type/services/$content_type.js"
    echo "   ✅ Routes: $BASE_PATH/$content_type/routes/$content_type.js"
    echo "   ✅ Migration: $BASE_PATH/$content_type/migrations/initial-migration.js"
    echo "   ✅ Tests: $BASE_PATH/$content_type/tests/test-$content_type.js"
    echo ""
    echo "🚀 Next Steps:"
    echo "   1. Restart Strapi: npm run develop"
    if [ "$action" = "create" ]; then
        echo "   2. Run migration: npm run strapi migration:run"
    fi
    echo "   3. Test the API: GET /api/$content_type"
    echo "   4. Verify in admin panel: http://localhost:1337/admin"
    echo ""
    echo "🔍 API Endpoints:"
    echo "   • GET /api/$content_type - List all records"
    echo "   • GET /api/$content_type/:id - Get single record"
    echo "   • POST /api/$content_type - Create new record"
    echo "   • PUT /api/$content_type/:id - Update record"
    echo "   • DELETE /api/$content_type/:id - Delete record"
    echo ""
    echo "✨ Ready for use!"
}

# Main script logic
main() {
    # Check arguments
    if [ $# -lt 2 ] || [ $# -gt 3 ]; then
        show_usage
        exit 1
    fi
    
    CONTENT_TYPE="$1"
    JSON_FILE="$2"
    ACTION="${3:-update}"  # Default to update if not specified
    
    # Validate action
    if [ "$ACTION" != "create" ] && [ "$ACTION" != "update" ]; then
        echo "❌ Error: Action must be 'create' or 'update'"
        show_usage
        exit 1
    fi
    
    echo "🚀 Strapi Content Type Manager"
    echo "   Content Type: $CONTENT_TYPE"
    echo "   Schema File: $JSON_FILE"
    echo "   Action: $ACTION"
    echo ""
    
    # Validate JSON file
    if ! validate_json "$JSON_FILE"; then
        exit 1
    fi
    
    # Extract content type info
    if ! extract_content_type_info "$JSON_FILE"; then
        exit 1
    fi
    
    # Check if content type directory exists
    if [ "$ACTION" = "update" ]; then
        if [ ! -d "$BASE_PATH/$CONTENT_TYPE" ]; then
            echo "❌ Error: Content type directory '$BASE_PATH/$CONTENT_TYPE' does not exist!"
            echo "   Use 'create' action to create a new content type."
            exit 1
        fi
    elif [ "$ACTION" = "create" ]; then
        if [ -d "$BASE_PATH/$CONTENT_TYPE" ]; then
            echo "❌ Error: Content type directory '$BASE_PATH/$CONTENT_TYPE' already exists!"
            echo "   Use 'update' action to update an existing content type."
            exit 1
        fi
    fi
    
    # Perform the action
    if [ "$ACTION" = "create" ]; then
        create_content_type "$CONTENT_TYPE" "$JSON_FILE" "$SINGULAR_NAME"
    else
        update_content_type "$CONTENT_TYPE" "$JSON_FILE" "$SINGULAR_NAME"
    fi
    
    # Set permissions
    set_permissions "$CONTENT_TYPE" "$SINGULAR_NAME"
    
    # Show success message
    show_success_message "$CONTENT_TYPE" "$ACTION" "$SINGULAR_NAME" "$DISPLAY_NAME"
}

# Run main function
main "$@"
