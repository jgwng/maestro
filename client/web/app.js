$(document).ready(function() {
  // Handle select all checkbox
  const $selectAllCheckbox = $('#selectAll');
  $selectAllCheckbox.on('click', function() {
    toggleSelectAll(this);
  });

  // Handle textarea input
  const $textarea = $('#yamlInput');
  const $actionButton = $('#actionButton');

  $textarea.on('input', function() {
    if ($textarea.val().trim().length > 0) {
      $actionButton.show();
    } else {
      $actionButton.hide();
    }
  });

  // Initialize sortable list
  const sortableList = document.getElementById('messageList');
  Sortable.create(sortableList, {
    animation: 150,
    ghostClass: 'sortable-ghost',
    chosenClass: 'sortable-chosen',
    onStart: function(evt) {
      $('body').addClass('dragging');
      $(evt.item).addClass('dragging-item');
    },
    onEnd: function(evt) {
      $('body').removeClass('dragging');
      $(evt.item).removeClass('dragging-item');
      console.log('Item reordered:', evt.item);
    }
  });
   $('#actionButton').on('click', function() {
    const yamlText = $('#yamlInput').val();
    checkYamlAddToList(yamlText);
  });

  // Handle save YAML button click
  $('#saveYamlBtn').on('click', function() {
    $('#myModal').modal('show');
  });

   const darkModeSwitch = $('#darkModeSwitch');
   darkModeSwitch.on('change', function() {
   if (darkModeSwitch.is(':checked')) {
        console.log('Dark mode disabled');
        window.postMessage('LIGHT', '*');
        // set theme on button press
        localStorage.setItem("theme", "LIGHT");
        $('body').removeClass('dark-mode');
   } else {
        console.log('Dark mode enabled');
         window.postMessage('DARK', '*');
        localStorage.setItem("theme", "DARK");
        $('body').addClass('dark-mode');
    }
   });
   let initMode = localStorage.getItem('theme');
   let isLightMode = initMode == "LIGHT";
   darkModeSwitch.prop('checked', isLightMode).trigger('change');

  // Handle confirm download button click
  $('#confirmDownloadBtn').on('click', function() {
    const filenameInput = $('#filenameInput').val().trim();
    const filename = filenameInput === '' ? 'download.yaml' : filenameInput;
    createYamlFile(filename);
    $('#myModal').modal('hide');
  });
});

function toggleDarkMode(theme){
    const darkModeSwitch = $('#darkModeSwitch');
    let darkModeTheme = (theme == 'LIGHT');
    darkModeSwitch.prop('checked', darkModeTheme).trigger('change');
}

function createYamlFile(filename) {
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

  // Set the download attribute with the filename
  link.download = (filename.includes('.yaml')) ? `${filename}` : `${filename}.yaml`;

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

function onContextMenuClick(action,yamlContent,callback) {
        console.log(`Context menu action: ${action}`);
        if (action.includes('ID 복사하기')) {
         copyToClipboard(yamlContent);
       } else {
         postMessageFromFlutter(action);
         if(action.includes('tapOn') || action.includes('doubleTapOn'))
         callback(action);
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
                checkYamlAddToList(yamlText);
            }
        });

function checkYamlAddToList(yamlText){
try {
                    const doc = jsyaml.load(yamlText);
                    if (typeof doc === 'object' && doc !== null && !Array.isArray(doc)) {
                        if (containsNull(doc)) {
                            alert('The YAML contains null values');
                        } else {
                            postMessageFromFlutter(yamlText);
                            event.target.value = ''; // Clear the input field
                        }
                    } else {
                        alert('The YAML is not a valid map/object');
                    }
                } catch (e) {
                    alert('Invalid YAML syntax');
   }
}


    function containsNull(obj) {
            for (const key in obj) {
                if (obj[key] === null) {
                    return true;
                }
                if (typeof obj[key] === 'object' && obj[key] !== null) {
                    if (containsNull(obj[key])) {
                        return true;
                    }
                }
            }
            return false;
        }

    // Hide context menu on click outside
document.addEventListener('click', function(event) {
   const contextMenu = document.getElementById('contextMenu');
   if (event.target.closest('#contextMenu') === null) {
            contextMenu.style.display = 'none';
   }
});


function mouseRightClick(yamlContent,callback) {
   const menuItems = [
      `- runScript:\n    id: "${yamlContent}"`,
      `- tapOn:\n    id: "${yamlContent}"`,
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
      onContextMenuClick(item,yamlContent,callback);
    };
    contextMenu.appendChild(menuItem);
  });

  // Show the context menu at the last right-click position
  contextMenu.style.display = 'grid';
  const { left, top } = getAdjustedPosition(event.clientX, event.clientY, contextMenu);
  contextMenu.style.left = `${left}px`;
  contextMenu.style.top = `${top}px`;
}

function toggleSelectAll(source) {
  const checkboxes = document.querySelectorAll('.form-check-input');
  console.log('source : ', source);
  console.log('source.checked : ', source.checked);
  checkboxes.forEach(checkbox => {
    checkbox.checked = source.checked;
  });
  checkForCheckedItems();
}
          // Function to check for checked items and toggle visibility of buttons
function checkForCheckedItems() {
            const buttonsElement = document.querySelector('.buttons');
            const anyChecked = document.querySelectorAll('#messageList li input[type="checkbox"]:checked').length > 0;
            if (anyChecked) {
              buttonsElement.style.visibility = 'visible';
            } else {
              buttonsElement.style.visibility = 'hidden';
            }
}

function removeCheckedItems() {
  // Select all checked checkboxes with the class 'form-check-input'
  const checkboxes = document.querySelectorAll('.form-check-input:checked');

  // Remove each checked checkbox's closest 'li' element
  checkboxes.forEach(checkbox => {
    checkbox.closest('li').remove();
  });

  // Update the visibility of the buttons based on checked items
  checkForCheckedItems();

  // Uncheck the select-all checkbox if no items are left
  const selectAllCheckbox = document.getElementById('selectAll');
  if (selectAllCheckbox) {
    selectAllCheckbox.checked = false;
  }
}

function postMessageFromFlutter(yamlContent) {
  // Handle the YAML content received from Flutter
  console.log('Received YAML content from Flutter:', yamlContent);

  // Create a list item
  const listItem = document.createElement('li');
  listItem.classList.add('list-item');
  listItem.style.position = 'relative'; // Ensure relative positioning for child elements

  // Create a drag icon element
  const dragIcon = document.createElement('span');
  dragIcon.classList.add('drag-icon');
  dragIcon.innerHTML = '≡'; // Unicode for the drag icon
  dragIcon.style.marginLeft = '12px'; // Add 8px space between drag icon and checkbox
  dragIcon.style.marginRight = '8px'; // Add 8px space between drag icon and checkbox
  dragIcon.style.position = 'absolute';
  dragIcon.style.left = '0';
  dragIcon.style.display = 'none'; // Hide the drag icon initially

  // Show the drag icon on hover
  listItem.addEventListener('mouseenter', () => {
    dragIcon.style.display = 'block';
  });

  // Hide the drag icon when not hovering
  listItem.addEventListener('mouseleave', () => {
    dragIcon.style.display = 'none';
  });

  // Create a wrapper div for the checkbox
  const checkboxWrapper = document.createElement('div');
  checkboxWrapper.classList.add('form-check'); // Bootstrap class for form check
  checkboxWrapper.style.paddingLeft = '0.5rem !important'; // Add margin to ensure spacing with drag icon

  // Create a checkbox element
  const checkbox = document.createElement('input');
  checkbox.type = 'checkbox';
  checkbox.style.marginLeft = '0px';
  checkbox.classList.add('form-check-input'); // Bootstrap class for form check input
  checkbox.id = `checkbox-${Date.now()}`; // Unique ID for the checkbox
  checkbox.addEventListener('change', checkForCheckedItems);

  // Create a label element for the checkbox
  const checkboxLabel = document.createElement('label');
  checkboxLabel.classList.add('form-check-label'); // Bootstrap class for form check label
  checkboxLabel.setAttribute('for', checkbox.id); // Set 'for' attribute to match checkbox id

  // Create a preformatted element
  const preElement = document.createElement('pre');
  preElement.textContent = yamlContent;
  preElement.style.cursor = 'pointer'; // Change cursor to pointer to indicate it's clickable
  preElement.addEventListener('click', () => {
    checkbox.checked = !checkbox.checked;
    checkForCheckedItems();
  });

  // Append the checkbox and label to the wrapper
  checkboxWrapper.appendChild(checkbox);
  checkboxWrapper.appendChild(checkboxLabel);

  // Append the drag icon, wrapper, and preformatted element to the list item
  listItem.appendChild(dragIcon);
  listItem.appendChild(checkboxWrapper);
  listItem.appendChild(preElement);

  // Append the list item to the message list
  document.getElementById('messageList').appendChild(listItem);
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
