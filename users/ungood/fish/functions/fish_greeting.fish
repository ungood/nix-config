function fish_greeting
    if command -q neofetch
      neofetch
    else
      gum log -l warn "neofetch is not installed"
    end
end
