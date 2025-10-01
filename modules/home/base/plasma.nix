_: {

  programs.plasma = {
    enable = true;

    workspace = {
      clickItemTo = "select";
      lookAndFeel = "org.kde.breezedark.desktop";
    };

    powerdevil = {
      AC = {
        powerButtonAction = "lockScreen";
        autoSuspend = {
          action = "nothing";
          idleTimeout = null;
        };
        turnOffDisplay = {
          idleTimeout = 60 * 15;
          idleTimeoutWhenLocked = 60 * 5;
        };
        dimDisplay = {
          enable = true;
          idleTimeout = 60 * 5;
        };
        whenLaptopLidClosed = "sleep";
        inhibitLidActionWhenExternalMonitorConnected = true;
        powerProfile = "balanced";
        displayBrightness = null;
      };

      battery = {
        powerButtonAction = "lockScreen";
        autoSuspend = {
          action = "sleep";
          idleTimeout = 60 * 15;
        };
        turnOffDisplay = {
          idleTimeout = 60 * 5;
          idleTimeoutWhenLocked = 60;
        };
        dimDisplay = {
          enable = true;
          idleTimeout = 60 * 2;
        };
        whenLaptopLidClosed = "sleep";
        inhibitLidActionWhenExternalMonitorConnected = false;
        powerProfile = "powerSaving";
        displayBrightness = 50;
      };

      lowBattery = {
        powerButtonAction = "lockScreen";
        autoSuspend = {
          action = "hibernate";
          idleTimeout = 60 * 5;
        };
        turnOffDisplay = {
          idleTimeout = 60;
          idleTimeoutWhenLocked = 30;
        };
        dimDisplay = {
          enable = true;
          idleTimeout = 60;
        };
        whenLaptopLidClosed = "hibernate";
        inhibitLidActionWhenExternalMonitorConnected = false;
        powerProfile = "powerSaving";
        displayBrightness = 30;
      };

      general = {
        pausePlayersOnSuspend = true;
      };
    };
  };
}
