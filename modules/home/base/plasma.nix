_: {

  programs.plasma = {
    enable = true;

    workspace = {
      clickItemTo = "select";
      lookAndFeel = "org.kde.breezedark.desktop";
    };

    powerdevil = {
      general = {
        pausePlayersOnSuspend = true;
      };

      AC = {
        powerProfile = "performance";
        whenSleepingEnter = "standby";
        displayBrightness = null;

        powerButtonAction = "sleep";
        whenLaptopLidClosed = "sleep";
        inhibitLidActionWhenExternalMonitorConnected = true;

        dimDisplay = {
          enable = true;
          idleTimeout = 60 * 5;
        };

        turnOffDisplay = {
          idleTimeout = 60 * 10;
          idleTimeoutWhenLocked = 60 * 5;
        };

        autoSuspend = {
          action = "sleep";
          idleTimeout = 60 * 15;
        };
      };

      battery = {
        powerProfile = "balanced";
        whenSleepingEnter = "hybridSleep";
        displayBrightness = 50;

        powerButtonAction = "sleep";
        whenLaptopLidClosed = "sleep";
        inhibitLidActionWhenExternalMonitorConnected = false;

        dimDisplay = {
          enable = true;
          idleTimeout = 60 * 2;
        };

        turnOffDisplay = {
          idleTimeout = 60 * 5;
          idleTimeoutWhenLocked = 60;
        };

        autoSuspend = {
          action = "sleep";
          idleTimeout = 60 * 10;
        };
      };

      lowBattery = {
        powerProfile = "powerSaving";
        whenSleepingEnter = "standbyThenHibernate";
        displayBrightness = 30;

        powerButtonAction = "hibernate";
        whenLaptopLidClosed = "hibernate";
        inhibitLidActionWhenExternalMonitorConnected = false;

        dimDisplay = {
          enable = true;
          idleTimeout = 60;
        };

        turnOffDisplay = {
          idleTimeout = 60 * 2;
          idleTimeoutWhenLocked = 60;
        };

        autoSuspend = {
          action = "hibernate";
          idleTimeout = 60 * 5;
        };
      };
    };
  };
}
