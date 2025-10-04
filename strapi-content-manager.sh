#!/bin/bash

echo "🚀 Simple Strapi Content Types Deployment Script"
echo "================================================"

# Function to update content type
update_content_type() {
    local content_type="$1"
    local schema_file="$2"
    echo "🔄 Updating $content_type content type..."
    ./strapi-content-manager.sh "$content_type" "$schema_file" update
    if [ $? -eq 0 ]; then
        echo "✅ $content_type updated successfully"
    else
        echo "❌ Failed to update $content_type"
        exit 1
    fi
}

echo ""
echo "📋 PHASE 1: Creating NO-RELATIONS schemas..."

# Create victims-schema-no-relations.json
echo '{
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
}' > /srv/app/victims-schema-no-relations.json
echo "✅ victims-schema-no-relations.json created"

# Create infostealer-data-schema-no-relations.json
echo '{
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
}' > /srv/app/infostealer-data-schema-no-relations.json
echo "✅ infostealer-data-schema-no-relations.json created"

# Create press-coverage-schema-no-relations.json
echo '{
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
}' > /srv/app/press-coverage-schema-no-relations.json
echo "✅ press-coverage-schema-no-relations.json created"

# Create group-locations-schema-no-relations.json
echo '{
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
}' > /srv/app/group-locations-schema-no-relations.json
echo "✅ group-locations-schema-no-relations.json created"

# Create victim-summaries-schema-no-relations.json
echo '{
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
}' > /srv/app/victim-summaries-schema-no-relations.json
echo "✅ victim-summaries-schema-no-relations.json created"

# Create ransomware-tracker-groups-schema-no-relations.json
echo '{
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
}' > /srv/app/ransomware-tracker-groups-schema-no-relations.json
echo "✅ ransomware-tracker-groups-schema-no-relations.json created"

echo ""
echo "📋 PHASE 2: Creating/Updating content types WITHOUT relationships..."

# Update all content types without relationships
update_content_type "victim" "victims-schema-no-relations.json"
update_content_type "infostealer-data" "infostealer-data-schema-no-relations.json"
update_content_type "press-coverage" "press-coverage-schema-no-relations.json"
update_content_type "group-location" "group-locations-schema-no-relations.json"
update_content_type "victim-summary" "victim-summaries-schema-no-relations.json"
update_content_type "ransomware-tracker" "ransomware-tracker-groups-schema-no-relations.json"

echo ""
echo "🎉 PHASE 1 COMPLETE!"
echo "===================="
echo "✅ All content types created WITHOUT relationships"
echo "✅ No circular dependencies"
echo ""
echo "🔄 Next: Add relationships manually or run phase 2 script"
