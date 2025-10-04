#!/bin/bash

echo "🚀 Complete Strapi Content Types Deployment Script (Self-Contained)"
echo "================================================================="

# Check if we're running from host or inside container
if [ -f /.dockerenv ]; then
    echo "❌ This script must be run from the HOST machine, not inside the container!"
    echo "   Run: ./deploy-all-content-types-embedded.sh"
    exit 1
fi

# Function to create JSON file in container
create_json_in_container() {
    local filename="$1"
    local content="$2"
    echo "📁 Creating $filename in container..."
    
    # Create the JSON file content
    docker exec strapi_test bash -c "cat > /srv/app/$filename << 'EOF'
$content
EOF"
    
    if [ $? -eq 0 ]; then
        echo "✅ $filename created successfully"
    else
        echo "❌ Failed to create $filename"
        exit 1
    fi
}

# Function to update content type
update_content_type() {
    local content_type="$1"
    local schema_file="$2"
    echo "🔄 Updating $content_type content type..."
    docker exec strapi_test ./strapi-content-manager.sh "$content_type" "$schema_file" update
    if [ $? -eq 0 ]; then
        echo "✅ $content_type updated successfully"
    else
        echo "❌ Failed to update $content_type"
        exit 1
    fi
}

echo ""
echo "📋 PHASE 1: Creating NO-RELATIONS schemas in container..."
echo "========================================================"

# Create victims-schema-no-relations.json
create_json_in_container "victims-schema-no-relations.json" '{
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
}'

# Create infostealer-data-schema-no-relations.json
create_json_in_container "infostealer-data-schema-no-relations.json" '{
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
}'

# Create press-coverage-schema-no-relations.json
create_json_in_container "press-coverage-schema-no-relations.json" '{
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
}'

# Create group-locations-schema-no-relations.json
create_json_in_container "group-locations-schema-no-relations.json" '{
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
}'

# Create victim-summaries-schema-no-relations.json
create_json_in_container "victim-summaries-schema-no-relations.json" '{
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
}'

# Create ransomware-tracker-groups-schema-no-relations.json
create_json_in_container "ransomware-tracker-groups-schema-no-relations.json" '{
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
}'

echo ""
echo "📋 PHASE 2: Creating/Updating content types WITHOUT relationships..."
echo "=================================================================="

# Update all content types without relationships
update_content_type "victim" "victims-schema-no-relations.json"
update_content_type "infostealer-data" "infostealer-data-schema-no-relations.json"
update_content_type "press-coverage" "press-coverage-schema-no-relations.json"
update_content_type "group-location" "group-locations-schema-no-relations.json"
update_content_type "victim-summary" "victim-summaries-schema-no-relations.json"
update_content_type "ransomware-tracker" "ransomware-tracker-groups-schema-no-relations.json"

echo ""
echo "📋 PHASE 3: Creating WITH-RELATIONS schemas in container..."
echo "========================================================="

# Create victims-schema-with-relations.json
create_json_in_container "victims-schema-with-relations.json" '{
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
    "group": {
      "type": "relation",
      "relation": "manyToOne",
      "target": "api::ransomware-tracker.ransomware-tracker",
      "inversedBy": "victimsData"
    },
    "infostealer": {
      "type": "relation",
      "relation": "oneToOne",
      "target": "api::infostealer-data.infostealer-data",
      "mappedBy": "victim"
    },
    "press": {
      "type": "relation",
      "relation": "oneToOne",
      "target": "api::press-coverage.press-coverage",
      "mappedBy": "victim"
    }
  }
}'

# Create infostealer-data-schema-with-relations.json
create_json_in_container "infostealer-data-schema-with-relations.json" '{
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
    "victim": {
      "type": "relation",
      "relation": "oneToOne",
      "target": "api::victim.victim",
      "inversedBy": "infostealer"
    }
  }
}'

# Create press-coverage-schema-with-relations.json
create_json_in_container "press-coverage-schema-with-relations.json" '{
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
    "victim": {
      "type": "relation",
      "relation": "oneToOne",
      "target": "api::victim.victim",
      "inversedBy": "press"
    }
  }
}'

# Create group-locations-schema-with-relations.json
create_json_in_container "group-locations-schema-with-relations.json" '{
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
    "group": {
      "type": "relation",
      "relation": "manyToOne",
      "target": "api::ransomware-tracker.ransomware-tracker",
      "inversedBy": "locations"
    }
  }
}'

# Create victim-summaries-schema-with-relations.json
create_json_in_container "victim-summaries-schema-with-relations.json" '{
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
    "group": {
      "type": "relation",
      "relation": "manyToOne",
      "target": "api::ransomware-tracker.ransomware-tracker",
      "inversedBy": "victimSummary"
    }
  }
}'

echo ""
echo "📋 PHASE 4: Adding relationships to content types..."
echo "===================================================="

# Update all content types with relationships
update_content_type "victim" "victims-schema-with-relations.json"
update_content_type "infostealer-data" "infostealer-data-schema-with-relations.json"
update_content_type "press-coverage" "press-coverage-schema-with-relations.json"
update_content_type "group-location" "group-locations-schema-with-relations.json"
update_content_type "victim-summary" "victim-summaries-schema-with-relations.json"

echo ""
echo "📋 PHASE 5: Final ransomware-tracker update with all relationships..."
echo "=================================================================="

# Create the final ransomware-tracker schema (your working one)
create_json_in_container "ransomware-tracker-groups-schema-simple.json" '{
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
    },
    "victimsData": {
      "type": "relation",
      "relation": "oneToMany",
      "target": "api::victim.victim",
      "mappedBy": "group"
    },
    "locations": {
      "type": "relation",
      "relation": "oneToMany",
      "target": "api::group-location.group-location",
      "mappedBy": "group"
    },
    "victimSummary": {
      "type": "relation",
      "relation": "oneToMany",
      "target": "api::victim-summary.victim-summary",
      "mappedBy": "group"
    }
  }
}'

# Final ransomware-tracker update with all relationships
update_content_type "ransomware-tracker" "ransomware-tracker-groups-schema-simple.json"

echo ""
echo "🎉 DEPLOYMENT COMPLETE!"
echo "======================"
echo "✅ All content types created/updated successfully"
echo "✅ All relationships established"
echo "✅ No circular dependencies"
echo ""
echo "🚀 You can now start your Strapi container:"
echo "   docker start strapi_test"
echo ""
echo "🔍 Verify in admin panel:"
echo "   https://api.invaders.ie/admin"
