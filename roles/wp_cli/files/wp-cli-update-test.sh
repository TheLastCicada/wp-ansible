#!/bin/bash
# Test script for WP-CLI auto-updates
# This script tests if wp-cli can be updated via the command line
# It's useful for debugging cron job issues
#
# Usage: ./wp-cli-update-test.sh
# Make this file executable with: chmod +x wp-cli-update-test.sh

set -e

# Log file for output
LOG_FILE="/tmp/wp-cli-update-test.log"

# Record start time
echo "WP-CLI update test started at $(date)" >> "$LOG_FILE"

# Check if WP-CLI is installed and executable
if ! command -v wp &> /dev/null; then
    echo "ERROR: wp-cli is not installed or not in PATH" >> "$LOG_FILE"
    exit 1
fi

# Check which user is running this script
CURRENT_USER=$(whoami)
echo "Running as user: $CURRENT_USER" >> "$LOG_FILE"

# Get current version
CURRENT_VERSION=$(wp cli version | cut -d' ' -f2)
echo "Current WP-CLI version: $CURRENT_VERSION" >> "$LOG_FILE"

# Check for updates (but don't apply)
echo "Checking for WP-CLI updates..." >> "$LOG_FILE"
UPDATE_CHECK=$(wp cli check-update)
echo "$UPDATE_CHECK" >> "$LOG_FILE"

# Run update with --yes flag
echo "Running update test (this won't actually update unless a new version is available)..." >> "$LOG_FILE"
wp cli update --yes >> "$LOG_FILE" 2>&1
UPDATE_EXIT_CODE=$?

# Get version after update attempt
NEW_VERSION=$(wp cli version | cut -d' ' -f2)
echo "WP-CLI version after update attempt: $NEW_VERSION" >> "$LOG_FILE"

# Report result
if [ $UPDATE_EXIT_CODE -eq 0 ]; then
    if [ "$CURRENT_VERSION" != "$NEW_VERSION" ]; then
        echo "UPDATE SUCCESSFUL: WP-CLI updated from $CURRENT_VERSION to $NEW_VERSION" >> "$LOG_FILE"
    else
        echo "NO UPDATE NEEDED: WP-CLI is already at the latest version ($CURRENT_VERSION)" >> "$LOG_FILE"
    fi
else
    echo "UPDATE FAILED: Exit code $UPDATE_EXIT_CODE" >> "$LOG_FILE"
fi

echo "Test completed at $(date)" >> "$LOG_FILE"
echo "Log file created at $LOG_FILE"

# Return success
exit 0
