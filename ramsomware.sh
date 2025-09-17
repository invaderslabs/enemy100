#!/bin/bash
# create-ransomware-tracker-complete.sh

CONTENT_TYPE_NAME="ransomware-tracker"
BASE_PATH="/srv/app/src/api"

echo "🚀 Creating complete Ransomware Tracker content type with middleware..."

# 1. Create directory structure (including middlewares)
echo "📁 Creating directory structure..."
mkdir -p "$BASE_PATH/$CONTENT_TYPE_NAME/content-types/$CONTENT_TYPE_NAME"
mkdir -p "$BASE_PATH/$CONTENT_TYPE_NAME/controllers"
mkdir -p "$BASE_PATH/$CONTENT_TYPE_NAME/routes"
mkdir -p "$BASE_PATH/$CONTENT_TYPE_NAME/services"
mkdir -p "$BASE_PATH/$CONTENT_TYPE_NAME/middlewares"

# 2. Create schema file
echo "📋 Creating schema file..."
cat > "$BASE_PATH/$CONTENT_TYPE_NAME/content-types/$CONTENT_TYPE_NAME/schema.json" << 'SCHEMA_EOF'
{
  "kind": "collectionType",
  "collectionName": "ransomware_trackers",
  "info": {
    "singularName": "ransomware-tracker",
    "pluralName": "ransomware-trackers",
    "displayName": "Ransomware Tracker"
  },
  "options": {
    "draftAndPublish": true
  },
  "pluginOptions": {},
  "attributes": {
    "pageType": {
      "type": "enumeration",
      "enum": ["dashboard", "group-profile"],
      "required": true,
      "unique": false
    },
    "dashboardData": {
      "type": "json",
      "required": false
    },
    "groupData": {
      "type": "json",
      "required": false
    },
    "title": {
      "type": "string",
      "required": true
    },
    "slug": {
      "type": "uid",
      "targetField": "title"
    },
    "description": {
      "type": "blocks"
    },
    "Image": {
      "type": "media",
      "multiple": false,
      "allowedTypes": [
        "images",
        "files",
        "videos"
      ]
    },
    "status": {
      "type": "enumeration",
      "enum": ["active", "rebranded", "state-sponsored", "unknown"],
      "required": false
    },
    "country": {
      "type": "string",
      "required": false
    },
    "sectorTarget": {
      "type": "string",
      "required": false
    },
    "lastActivity": {
      "type": "date",
      "required": false
    },
    "victims": {
      "type": "string",
      "required": false
    },
    "avgRansom": {
      "type": "string",
      "required": false
    }
  }
}
SCHEMA_EOF

# 3. Create controller file
echo "🎮 Creating controller file..."
cat > "$BASE_PATH/$CONTENT_TYPE_NAME/controllers/$CONTENT_TYPE_NAME.js" << 'CONTROLLER_EOF'
'use strict';

/**
 * ransomware-tracker controller
 */

const { createCoreController } = require('@strapi/strapi').factories;

module.exports = createCoreController('api::ransomware-tracker.ransomware-tracker');
CONTROLLER_EOF

# 4. Create routes file
echo "🛣️ Creating routes file..."
cat > "$BASE_PATH/$CONTENT_TYPE_NAME/routes/$CONTENT_TYPE_NAME.js" << 'ROUTES_EOF'
'use strict';

/**
 * ransomware-tracker router
 */

const { createCoreRouter } = require('@strapi/strapi').factories;

module.exports = createCoreRouter('api::ransomware-tracker.ransomware-tracker');
ROUTES_EOF

# 5. Create services file
echo "⚙️ Creating services file..."
cat > "$BASE_PATH/$CONTENT_TYPE_NAME/services/$CONTENT_TYPE_NAME.js" << 'SERVICES_EOF'
'use strict';

/**
 * ransomware-tracker service
 */

const { createCoreService } = require('@strapi/strapi').factories;

module.exports = createCoreService('api::ransomware-tracker.ransomware-tracker');
SERVICES_EOF

# 6. Create middlewares file
echo "🔧 Creating middlewares file..."
cat > "$BASE_PATH/$CONTENT_TYPE_NAME/middlewares/index.js" << 'MIDDLEWARE_EOF'
'use strict';

/**
 * ransomware-tracker middlewares
 */

module.exports = {
  // Rate limiting to prevent abuse
  rateLimit: async (ctx, next) => {
    // Simple rate limiting: 100 requests per minute per IP
    const ip = ctx.request.ip;
    const key = `rate_limit_${ip}`;
    
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
      duration: `${duration}ms`,
      ip: ip,
      userAgent: userAgent,
      timestamp: new Date().toISOString()
    };
    
    // Log to Strapi logger
    strapi.log.info(`[RANSOMWARE-TRACKER] ${JSON.stringify(logData)}`);
    
    // Log suspicious activity
    if (ctx.status >= 400 || duration > 5000) {
      strapi.log.warn(`[RANSOMWARE-TRACKER-SUSPICIOUS] ${JSON.stringify(logData)}`);
    }
  },
  
  // Input validation for JSON fields
  validateInput: async (ctx, next) => {
    if (ctx.method === 'POST' || ctx.method === 'PUT') {
      const { dashboardData, groupData } = ctx.request.body.data || {};
      
      // Validate dashboard data structure
      if (dashboardData) {
        const requiredFields = ['activeGroups', 'totalVictims', 'newGroups30d', 'thisWeek'];
        for (const field of requiredFields) {
          if (typeof dashboardData[field] !== 'number') {
            ctx.throw(400, `Invalid dashboard data: ${field} must be a number`);
          }
        }
      }
      
      // Validate group data structure
      if (groupData) {
        const requiredFields = ['name', 'slug', 'status', 'addedDate'];
        for (const field of requiredFields) {
          if (!groupData[field]) {
            ctx.throw(400, `Invalid group data: ${field} is required`);
          }
        }
      }
    }
    
    await next();
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

echo "✅ Ransomware Tracker content type with middleware created successfully!"
echo "📁 Directory structure:"
echo "   $BASE_PATH/$CONTENT_TYPE_NAME/"
echo "   ├── content-types/$CONTENT_TYPE_NAME/schema.json"
echo "   ├── controllers/$CONTENT_TYPE_NAME.js"
echo "   ├── routes/$CONTENT_TYPE_NAME.js"
echo "   ├── services/$CONTENT_TYPE_NAME.js"
echo "   └── middlewares/index.js"
echo ""
echo "🔧 Middleware features:"
echo "   • Rate limiting (100 req/min per IP)"
echo "   • CORS handling"
echo "   • Request logging"
echo "   • Input validation"
echo "   • Security headers"
echo ""
echo "🚀 Next steps:"
echo "   1. Make script executable: chmod +x create-ransomware-tracker-complete.sh"
echo "   2. Run script: ./create-ransomware-tracker-complete.sh"
echo "   3. Restart Strapi server"
echo "   4. Check admin panel for new content type"
echo "   5. Create sample data entries"
echo "   6. Test middleware functionality"
