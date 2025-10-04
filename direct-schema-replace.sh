#!/bin/bash

echo "🚀 Direct Manual Schema Update (No Scripts)"
echo "==========================================="

echo ""
echo "📋 Step 1: Creating JSON schemas..."

# Create victims-schema-no-relations.json
cat > /srv/app/victims-schema-no-relations.json << 'EOF'
{
  "kind": "collectionType",
  "collectionName": "victims",
  "info": {
    "singularName": "victim",
    "pluralName": "victims",
    "displayName": "Victim",
    "description": "Ransomware attack victims"
  },
  "options": {
    "draftAndPublish": true
  },
  "pluginOptions": {},
  "attributes": {
    "victim": {
      "type": "string",
      "required": true
    },
    "description": {
      "type": "text",
      "required": false
    },
    "attackDate": {
      "type": "date",
      "required": false
    },
    "country": {
      "type": "string",
      "required": false
    },
    "activity": {
      "type": "string",
      "required": false
    },
    "extrainfos": {
      "type": "json",
      "required": false
    },
    "groupName": {
      "type": "string",
      "required": false
    }
  }
}
EOF
echo "✅ victims-schema-no-relations.json created"

# Create infostealer-data-schema-no-relations.json
cat > /srv/app/infostealer-data-schema-no-relations.json << 'EOF'
{
  "kind": "collectionType",
  "collectionName": "infostealer_data",
  "info": {
    "singularName": "infostealer-data",
    "pluralName": "infostealer-datas",
    "displayName": "Infostealer Data",
    "description": "Infostealer statistics and data breach information"
  },
  "options": {
    "draftAndPublish": true
  },
  "pluginOptions": {},
  "attributes": {
    "employees": {
      "type": "integer",
      "required": false,
      "min": 0
    },
    "employeesUrl": {
      "type": "integer",
      "required": false,
      "min": 0
    },
    "infostealerStats": {
      "type": "json",
      "required": false,
      "description": "Statistics for different infostealer types"
    },
    "thirdparties": {
      "type": "integer",
      "required": false,
      "min": 0
    },
    "thirdpartiesDomain": {
      "type": "integer",
      "required": false,
      "min": 0
    },
    "update": {
      "type": "datetime",
      "required": false
    },
    "users": {
      "type": "integer",
      "required": false,
      "min": 0
    },
    "usersUrl": {
      "type": "integer",
      "required": false,
      "min": 0
    },
    "victimName": {
      "type": "string",
      "required": false
    }
  }
}
EOF
echo "✅ infostealer-data-schema-no-relations.json created"

# Create press-coverage-schema-no-relations.json
cat > /srv/app/press-coverage-schema-no-relations.json << 'EOF'
{
  "kind": "collectionType",
  "collectionName": "press_coverage",
  "info": {
    "singularName": "press-coverage",
    "pluralName": "press-coverages",
    "displayName": "Press Coverage",
    "description": "Media coverage and press reports for ransomware attacks"
  },
  "options": {
    "draftAndPublish": true
  },
  "pluginOptions": {},
  "attributes": {
    "link": {
      "type": "string",
      "required": true
    },
    "source": {
      "type": "string",
      "required": false
    },
    "summary": {
      "type": "text",
      "required": false
    },
    "date": {
      "type": "date",
      "required": false
    },
    "victimName": {
      "type": "string",
      "required": false
    }
  }
}
EOF
echo "✅ press-coverage-schema-no-relations.json created"

# Create group-locations-schema-no-relations.json
cat > /srv/app/group-locations-schema-no-relations.json << 'EOF'
{
  "kind": "collectionType",
  "collectionName": "group_locations",
  "info": {
    "singularName": "group-location",
    "pluralName": "group-locations",
    "displayName": "Group Location",
    "description": "Infrastructure locations and domains for ransomware groups"
  },
  "options": {
    "draftAndPublish": true
  },
  "pluginOptions": {},
  "attributes": {
    "fqdn": {
      "type": "string",
      "required": true
    },
    "type": {
      "type": "string",
      "required": false
    },
    "available": {
      "type": "boolean",
      "required": false,
      "default": true
    },
    "lastScrape": {
      "type": "datetime",
      "required": false
    },
    "groupName": {
      "type": "string",
      "required": false
    }
  }
}
EOF
echo "✅ group-locations-schema-no-relations.json created"

# Create victim-summaries-schema-no-relations.json
cat > /srv/app/victim-summaries-schema-no-relations.json << 'EOF'
{
  "kind": "collectionType",
  "collectionName": "victim_summaries",
  "info": {
    "singularName": "victim-summary",
    "pluralName": "victim-summaries",
    "displayName": "Victim Summary",
    "description": "Aggregated victim statistics and summaries for ransomware groups"
  },
  "options": {
    "draftAndPublish": true
  },
  "pluginOptions": {},
  "attributes": {
    "totalVictims": {
      "type": "integer",
      "required": false,
      "min": 0
    },
    "countries": {
      "type": "json",
      "required": false,
      "description": "Country statistics"
    },
    "sectors": {
      "type": "json",
      "required": false,
      "description": "Sector statistics"
    },
    "attackDates": {
      "type": "json",
      "required": false,
      "description": "Attack date statistics"
    },
    "recentAttacks": {
      "type": "json",
      "required": false,
      "description": "Recent attack data"
    },
    "groupName": {
      "type": "string",
      "required": false
    }
  }
}
EOF
echo "✅ victim-summaries-schema-no-relations.json created"

# Create ransomware-tracker-groups-schema-no-relations.json
cat > /srv/app/ransomware-tracker-groups-schema-no-relations.json << 'EOF'
{
  "kind": "collectionType",
  "collectionName": "ransomware_trackers",
  "info": {
    "singularName": "ransomware-tracker",
    "pluralName": "ransomware-trackers",
    "displayName": "Ransomware Tracker",
    "description": "Ransomware groups and their comprehensive data"
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
    },
    "groupstatus": {
      "type": "enumeration",
      "enum": ["active", "inactive", "rebranded", "unknown"],
      "required": false
    },
    "totalLocations": {
      "type": "integer",
      "required": false,
      "min": 0
    },
    "activeLocations": {
      "type": "integer",
      "required": false,
      "min": 0
    },
    "researchLinks": {
      "type": "json",
      "required": false
    },
    "tools": {
      "type": "json",
      "required": false
    },
    "ttps": {
      "type": "json",
      "required": false
    },
    "parserEnabled": {
      "type": "boolean",
      "required": false,
      "default": false
    }
  }
}
EOF
echo "✅ ransomware-tracker-groups-schema-no-relations.json created"

echo ""
echo "📋 Step 2: Direct manual schema replacement..."
echo "============================================="

# Directly replace schema files (bypass the script)
echo "🔄 Replacing victim schema..."
if [ -f "/srv/app/src/api/victim/content-types/victim/schema.json" ]; then
    cp /srv/app/src/api/victim/content-types/victim/schema.json /srv/app/src/api/victim/content-types/victim/schema.json.backup.$(date +%Y%m%d_%H%M%S)
    cp /srv/app/victims-schema-no-relations.json /srv/app/src/api/victim/content-types/victim/schema.json
    echo "✅ victim schema replaced"
else
    echo "❌ victim schema not found"
fi

echo "🔄 Replacing infostealer-data schema..."
if [ -f "/srv/app/src/api/infostealer-data/content-types/infostealer-data/schema.json" ]; then
    cp /srv/app/src/api/infostealer-data/content-types/infostealer-data/schema.json /srv/app/src/api/infostealer-data/content-types/infostealer-data/schema.json.backup.$(date +%Y%m%d_%H%M%S)
    cp /srv/app/infostealer-data-schema-no-relations.json /srv/app/src/api/infostealer-data/content-types/infostealer-data/schema.json
    echo "✅ infostealer-data schema replaced"
else
    echo "❌ infostealer-data schema not found"
fi

echo "🔄 Replacing press-coverage schema..."
if [ -f "/srv/app/src/api/press-coverage/content-types/press-coverage/schema.json" ]; then
    cp /srv/app/src/api/press-coverage/content-types/press-coverage/schema.json /srv/app/src/api/press-coverage/content-types/press-coverage/schema.json.backup.$(date +%Y%m%d_%H%M%S)
    cp /srv/app/press-coverage-schema-no-relations.json /srv/app/src/api/press-coverage/content-types/press-coverage/schema.json
    echo "✅ press-coverage schema replaced"
else
    echo "❌ press-coverage schema not found"
fi

echo "🔄 Replacing group-location schema..."
if [ -f "/srv/app/src/api/group-location/content-types/group-location/schema.json" ]; then
    cp /srv/app/src/api/group-location/content-types/group-location/schema.json /srv/app/src/api/group-location/content-types/group-location/schema.json.backup.$(date +%Y%m%d_%H%M%S)
    cp /srv/app/group-locations-schema-no-relations.json /srv/app/src/api/group-location/content-types/group-location/schema.json
    echo "✅ group-location schema replaced"
else
    echo "❌ group-location schema not found"
fi

echo "🔄 Replacing victim-summary schema..."
if [ -f "/srv/app/src/api/victim-summary/content-types/victim-summary/schema.json" ]; then
    cp /srv/app/src/api/victim-summary/content-types/victim-summary/schema.json /srv/app/src/api/victim-summary/content-types/victim-summary/schema.json.backup.$(date +%Y%m%d_%H%M%S)
    cp /srv/app/victim-summaries-schema-no-relations.json /srv/app/src/api/victim-summary/content-types/victim-summary/schema.json
    echo "✅ victim-summary schema replaced"
else
    echo "❌ victim-summary schema not found"
fi

echo "🔄 Replacing ransomware-tracker schema..."
if [ -f "/srv/app/src/api/ransomware-tracker/content-types/ransomware-tracker/schema.json" ]; then
    cp /srv/app/src/api/ransomware-tracker/content-types/ransomware-tracker/schema.json /srv/app/src/api/ransomware-tracker/content-types/ransomware-tracker/schema.json.backup.$(date +%Y%m%d_%H%M%S)
    cp /srv/app/ransomware-tracker-groups-schema-no-relations.json /srv/app/src/api/ransomware-tracker/content-types/ransomware-tracker/schema.json
    echo "✅ ransomware-tracker schema replaced"
else
    echo "❌ ransomware-tracker schema not found"
fi

echo ""
echo "🎉 DIRECT UPDATE COMPLETE!"
echo "========================="
echo "✅ All schemas replaced directly (no scripts)"
echo "✅ Backups created with timestamps"
echo "✅ No circular dependencies"
echo "✅ Strapi should now start without memory issues"
echo ""
echo "🔄 Next: Restart Strapi container"
echo "   docker restart strapi_test"
