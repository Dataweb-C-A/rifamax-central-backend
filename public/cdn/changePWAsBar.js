function notificationBarThemePWA(
  lightColor = "#FFFFFF", 
  darkColor = "#1A1B1E",
  preferColorScheme = "dark",
  metaTagID = "theme-color",
  storageItem = "theme"
) {
  const currentTheme = localStorage.getItem(storageItem) || preferColorScheme
  
  const colors = {
    light: lightColor,
    dark: darkColor
  };
  
  document.getElementById(metaTagID).setAttribute("content", colors[currentTheme]);
}