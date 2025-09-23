# Legacy configuration - imports the gaming role which includes all components
# This maintains backward compatibility while transitioning to role-based system
{ ... }:
{
  imports = [
    ./gaming
  ];
}
