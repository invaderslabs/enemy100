#!/bin/bash

echo "🚀 Complete Strapi Content Types Deployment Script"
echo "=================================================="

# Function to copy file to container
copy_to_container() {
    local file="$1"
    echo "📁 Copying $file to container..."
    docker cp "ransomware-tracker/victims/$file" strapi_test:/srv/app/
    if [ $? -eq 0 ]; then
        echo "✅ $file copied successfully"
    else
        echo "❌ Failed to copy $file"
        exit 1
    fi
}

# Function to update content type
update_content_type() {
    local content_type="$1"
    local schema_file="$2"
    echo "🔄 Updating $content_type content type..."
    docker exec -it strapi_test ./strapi-content-manager.sh "$content_type" "$schema_file" update
    if [ $? -eq 0 ]; then
        echo "✅ $content_type updated successfully"
    else
        echo "❌ Failed to update $content_type"
        exit 1
    fi
}

echo ""
echo "📋 PHASE 1: Copying NO-RELATIONS schemas..."
echo "=========================================="

# Copy all no-relations schemas
copy_to_container "victims-schema-no-relations.json"
copy_to_container "infostealer-data-schema-no-relations.json"
copy_to_container "press-coverage-schema-no-relations.json"
copy_to_container "group-locations-schema-no-relations.json"
copy_to_container "victim-summaries-schema-no-relations.json"
copy_to_container "ransomware-tracker-groups-schema-no-relations.json"

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
echo "📋 PHASE 3: Copying WITH-RELATIONS schemas..."
echo "============================================="

# Copy all with-relations schemas
copy_to_container "victims-schema-with-relations.json"
copy_to_container "infostealer-data-schema-with-relations.json"
copy_to_container "press-coverage-schema-with-relations.json"
copy_to_container "group-locations-schema-with-relations.json"
copy_to_container "victim-summaries-schema-with-relations.json"

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

# Copy the final ransomware-tracker schema (your working one)
copy_to_container "ransomware-tracker-groups-schema-simple.json"
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
