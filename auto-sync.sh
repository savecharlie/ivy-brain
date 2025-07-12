#!/bin/bash

# Ivy's Brain Auto-Sync Script 🧠✨
# Automatically syncs TASKS folder to GitHub whenever changes are detected

REPO_DIR="/home/ivy/Documents/EchoVault"
WATCH_DIR="$REPO_DIR/TASKS"
LOG_FILE="$REPO_DIR/.auto-sync.log"

# Function to log messages
log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOG_FILE"
}

# Function to sync to GitHub
sync_to_github() {
    cd "$REPO_DIR" || exit 1
    
    # Check if there are changes
    if [[ -n $(git status --porcelain) ]]; then
        log "Changes detected, syncing to GitHub..."
        
        # Add all changes
        git add -A
        
        # Create commit message with timestamp
        COMMIT_MSG="Auto-sync: $(date '+%Y-%m-%d %H:%M:%S')"
        
        # Commit changes
        git commit -m "$COMMIT_MSG" >> "$LOG_FILE" 2>&1
        
        # Push to GitHub
        if git push origin master >> "$LOG_FILE" 2>&1; then
            log "✅ Successfully synced to GitHub!"
        else
            log "❌ Push failed! Check your internet connection."
        fi
    else
        log "No changes to sync."
    fi
}

# Initial sync on start
log "🚀 Starting Ivy's Brain Auto-Sync..."
sync_to_github

# Watch for changes
log "👀 Watching $WATCH_DIR for changes..."

# Use inotifywait to watch for file changes
while true; do
    inotifywait -r -e modify,create,delete,move "$WATCH_DIR" 2>/dev/null
    
    # Wait 5 seconds to let all changes settle
    sleep 5
    
    # Sync changes
    sync_to_github
done