function fish_greeting
    if command -q fastfetch
      fastfetch
    else
      gum log -l warn "fastfetch is not installed"
    end
end
