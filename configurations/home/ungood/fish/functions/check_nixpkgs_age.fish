function check_nixpkgs_age --description "Show age of installed nixpkgs"
    if not command -q jq; or not command -q curl
        return
    end

    # Get the installed nixpkgs revision from the running system
    set -l version_file
    if test -f /run/current-system/darwin-version.json
        set version_file /run/current-system/darwin-version.json
    else if test -f /run/current-system/nixos-version.json
        set version_file /run/current-system/nixos-version.json
    else
        return
    end

    set -l installed_rev (jq -r '.nixpkgsRevision // empty' "$version_file" 2>/dev/null)
    if test -z "$installed_rev"
        return
    end

    # Look up the commit timestamp, using a cache to avoid repeated API calls
    set -l cache_dir ~/.cache/check-nixpkgs-age
    set -l cache_file "$cache_dir/$installed_rev"

    set -l commit_epoch
    if test -f "$cache_file"
        set commit_epoch (cat "$cache_file")
    else
        # Fetch commit date from GitHub API
        set -l commit_date (curl -sf "https://api.github.com/repos/NixOS/nixpkgs/commits/$installed_rev" | jq -r '.commit.committer.date // empty' 2>/dev/null)
        if test -z "$commit_date"
            return
        end

        # Convert ISO 8601 date to epoch seconds
        set commit_epoch (date -j -f "%Y-%m-%dT%H:%M:%SZ" "$commit_date" +%s 2>/dev/null)
        # Fallback for GNU date
        if test -z "$commit_epoch"
            set commit_epoch (date -d "$commit_date" +%s 2>/dev/null)
        end

        if test -n "$commit_epoch"
            mkdir -p "$cache_dir"
            echo "$commit_epoch" > "$cache_file"
        end
    end

    if test -z "$commit_epoch"
        return
    end

    set -l now (date +%s)
    set -l age_days (math --scale=0 "($now - $commit_epoch) / 86400")

    if test "$age_days" -gt 30
        set_color --bold brred
    else if test "$age_days" -gt 7
        set_color --bold bryellow
    end

    echo "nixpkgs: $age_days days old ($(string sub -l 7 $installed_rev))"
    set_color normal
end
