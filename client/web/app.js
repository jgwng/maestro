document.addEventListener('DOMContentLoaded', () => {
  const sortableList = document.getElementById('messageList');
    Sortable.create(sortableList, {
      animation: 150,
      ghostClass: 'sortable-ghost',
      chosenClass: 'sortable-chosen',
      onStart: function (evt) {
        document.body.classList.add('dragging');
        evt.item.classList.add('dragging-item');
      },
      onEnd: function (evt) {
        document.body.classList.remove('dragging');
        evt.item.classList.remove('dragging-item');
        console.log('Item reordered:', evt.item);
      }
    });
});

function createYamlFile() {
  // Collect checked items from the message list
  const checkedItems = [];
  let checkedYamlContent = '';
  document.querySelectorAll('#messageList li input[type="checkbox"]:checked').forEach((checkbox) => {
      const listItem = checkbox.closest('li');
      const preElement = listItem.querySelector('pre');
      if (preElement) {
        checkedYamlContent += preElement.textContent + '\n';
      }
    });
  const appId = 'com.woong.client';
  const yamlContent = {
          appId: appId,
  };

  let yamlStr = `${jsyaml.dump(yamlContent)}---\n`;
  yamlStr += '- launchApp\n';
  yamlStr += `${checkedYamlContent}`;
  yamlStr += '- stopApp\n';

  // Create a Blob from the YAML string
  const blob = new Blob([yamlStr], { type: 'application/x-yaml' });

  // Create a link element
  const link = document.createElement('a');

  // Set the download attribute with a filename
  link.download = 'checked_items.yaml';

  // Create a URL for the Blob and set it as the href attribute
  link.href = window.URL.createObjectURL(blob);

  // Append the link to the body
  document.body.appendChild(link);

  // Programmatically click the link to trigger the download
  link.click();

  // Remove the link from the document
  document.body.removeChild(link);
}

function getAdjustedPosition(x, y, menu) {
      const menuWidth = menu.offsetWidth;
      const menuHeight = menu.offsetHeight;
      const windowWidth = window.innerWidth;
      const windowHeight = window.innerHeight;

      if (x + menuWidth > windowWidth) {
        x = windowWidth - menuWidth;
      }

      if (y + menuHeight > windowHeight) {
        y = windowHeight - menuHeight;
      }

      return { left: x, top: y };
}

function onContextMenuClick(action,yamlContent) {
        console.log(`Context menu action: ${action}`);
        if (action.includes('ID 복사하기')) {
         copyToClipboard(yamlContent);
       } else {
         postMessageFromFlutter(action);
       }
       document.getElementById('contextMenu').style.display = 'none';
}

function copyToClipboard(text) {
  if (navigator.clipboard && navigator.clipboard.writeText) {
    navigator.clipboard.writeText(text).then(function() {
      alert('Copied to clipboard');
    }).catch(function(err) {
      console.error('Could not copy text: ', err);
    });
  } else {
    // Fallback for browsers that do not support the Clipboard API
    const textArea = document.createElement('textarea');
    textArea.value = text;
    document.body.appendChild(textArea);
    textArea.select();
    document.execCommand('copy');
    document.body.removeChild(textArea);
    alert('Copied to clipboard');
  }
}

document.getElementById('yamlInput').addEventListener('keydown', function(event) {
    if (event.altKey && event.key === 'Enter') {
        event.preventDefault();
        const yamlText = event.target.value;
        console.log('yamltext : ' + yamlText);
        try {
            const doc = jsyaml.load(yamlText);
            console.log('doc : ' + doc);
            addYamlToList(yamlText);
            event.target.value = ''; // Clear the input field
        } catch (e) {
            alert('Invalid YAML syntax');
        }
    }
});

function addYamlToList(yamlText) {
    const messageList = document.getElementById('messageList');
    const listItem = document.createElement('li');
    const preElement = document.createElement('pre');
    preElement.textContent = yamlText;
    listItem.appendChild(preElement);
    messageList.appendChild(listItem);
}
    // Hide context menu on click outside
document.addEventListener('click', function(event) {
   const contextMenu = document.getElementById('contextMenu');
   if (event.target.closest('#contextMenu') === null) {
            contextMenu.style.display = 'none';
   }
});


function mouseRightClick(yamlContent) {
   const menuItems = [
      `- runScript:\n    id: "${yamlContent}"`,
      `- doubleTapOn:\n    id: "${yamlContent}"`,
      `- assertVisible:\n    id: "${yamlContent}"`,
      `- assertNotVisible:\n    id: "${yamlContent}"`,
      `- copyTextFrom:\n    id: "${yamlContent}"`,
      'ID 복사하기',
    ];

  // Populate the context menu with the message
  const contextMenu = document.getElementById('contextMenu');
  contextMenu.innerHTML = ''; // Clear previous items

  menuItems.forEach(item => {
    const menuItem = document.createElement('pre');
    menuItem.classList.add('context-menu-item');
    menuItem.textContent = item;
    menuItem.onclick = function() {
      onContextMenuClick(item,yamlContent);
    };
    contextMenu.appendChild(menuItem);
  });

  // Show the context menu at the last right-click position
  contextMenu.style.display = 'grid';
  const { left, top } = getAdjustedPosition(event.clientX, event.clientY, contextMenu);
  contextMenu.style.left = `${left}px`;
  contextMenu.style.top = `${top}px`;
}

window.addEventListener('load', function(ev) {
  let target = document.getElementById("flutter-view");
  _flutter.loader.loadEntrypoint({
    serviceWorker: {
      serviceWorkerVersion: serviceWorkerVersion,
    },
    onEntrypointLoaded: async function(engineInitializer) {
        const config = {
                          // Set hostElement based on device type
                          hostElement: target,
                          canvasKitBaseUrl: "./canvaskit/",
//                          useColorEmoji:true,
                          buildConfig: {
                              builds: [
                                {
                                  compileTarget: "dart2wasm",
                                  renderer: "skwasm",
                                  mainWasmPath: "main.dart.wasm",
                                  jsSupportRuntimePath: "main.dart.mjs"
                                },
                                {
                                  compileTarget: "dart2js",
                                  renderer: "canvaskit",
                                  mainJsPath: "main.dart.js"
                                }
                              ]
                            }
                       };
       const appRunner = await engineInitializer.initializeEngine(config);
       appRunner.runApp();
    }
  });
});
//window.addEventListener('load', function(ev) {
//  // Set an initial progress of 33% when the page loads.
//  progress.style.width = `33%`;
// const myElement = document.getElementById('logo');
// const position = getElementPosition(myElement);
// console.log('Element Position:', position);
//  // Download main.dart.js
//  let target = document.querySelector("#flutter-view");
//
//  // Check if the user is on a mobile device (Android/iOS)
//  const isMobile = /Android|webOS|iPhone|iPad|iPod|BlackBerry|IEMobile|Opera Mini/i.test(navigator.userAgent);
//
//  _flutter.loader.loadEntrypoint({
//    serviceWorker: {
//      serviceWorkerVersion: serviceWorkerVersion,
//    },
//    onEntrypointLoaded: async function(engineInitializer) {
//        const config = {
//                          // Set hostElement based on device type
//                          hostElement: isMobile ? null : target,
//                          canvasKitBaseUrl: "./canvaskit/",
////                          useColorEmoji:true,
//                          buildConfig: {
//                              builds: [
//                                {
//                                  compileTarget: "dart2wasm",
//                                  renderer: "skwasm",
//                                  mainWasmPath: "main.dart.wasm",
//                                  jsSupportRuntimePath: "main.dart.mjs"
//                                },
//                                {
//                                  compileTarget: "dart2js",
//                                  renderer: "canvaskit",
//                                  mainJsPath: "main.dart.js"
//                                }
//                              ]
//                            }
//                       };
//       const appRunner = await engineInitializer.initializeEngine(config);
//       // Set progress to 99% before adding a delay.
//       progress.style.width = `100%`;
//
//       appRunner.runApp();
//    }
//  });
//});
