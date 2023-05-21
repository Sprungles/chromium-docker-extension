// Listen for installation completion
browser.runtime.onInstalled.addListener(() => {
  // Run the Docker installation script
  browser.scripting.executeScript({
    target: { tabId: -1 },
    files: ["docker-installation-script.sh"]
  });
});
