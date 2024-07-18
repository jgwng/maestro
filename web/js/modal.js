const screen = document.getElementById('screen');
const yamlEditor = document.getElementById('yamlEditor');
const startTestScriptButton = document.getElementById('startTestScriptButton');
const stopTestScriptButton = document.getElementById('stopTestScriptButton');
const modalBtn = document.getElementById('testScriptButton');
const modal = document.getElementById('TestScriptModal');
const closeModal = document.getElementsByClassName('btn-close')[0];
const testLogOutputArea = document.getElementById('testLogOutputArea');
let isTestScriptRunning = false;

let eventSource = null;

// When the user clicks the button, open the modal 
modalBtn.onclick = function() {
  modal.style.display = 'block';
}

// When the user clicks on <span> (x), close the modal if the script is not running
closeModal.onclick = function() {
  if (!isTestScriptRunning) {
    modal.style.display = 'none';
  }
}

// When the user clicks anywhere outside of the modal, close it if the script is not running
window.onclick = function(event) {
  if (event.target == modal && !isScriptRunning) {
    modal.style.display = 'none';
  }
}

startTestScriptButton.addEventListener('click', () => {
  const yamlScript = yamlEditor.value;
  if (!yamlScript.trim()) {
    alert('Please enter a YAML script.');
    return;
  }

  startTestScriptButton.disabled = true;
  testLogOutputArea.innerText = '';
  testLogOutputArea.style.display= 'block';
  stopTestScriptButton.disabled = false;
  isTestScriptRunning = true;

  fetch('/start_test_script', {
    method: 'POST',
    headers: {
      'Content-Type': 'application/x-yaml'
    },
    body: yamlScript
  }).then(response => {
    if (!response.ok) {
      throw new Error('Failed to start script');
    }
    console.log('Script started');
    startEventSource();
  }).catch(error => {
    console.error(error);
    alert('Failed to start script');
    startTestScriptButton.disabled = false;
    stopTestScriptButton.disabled = true;
    isTestScriptRunning = false;
  });
});

stopTestScriptButton.addEventListener('click', () => {
  fetch('/stop_test_script', {
    method: 'POST'
  }).then(response => {
    if (!response.ok) {
      throw new Error('Failed to stop script');
    }
    console.log('Script stopped');
    stopEventSource();
    startTestScriptButton.disabled = false;
    stopTestScriptButton.disabled = true;
    isTestScriptRunning = false;
  }).catch(error => {
    console.error(error);
    alert('Failed to stop script');
  });
});

function startEventSource() {
  eventSource = new EventSource('/stream_logs');

  eventSource.onmessage = (event) => {
    testLogOutputArea.textContent += `${event.data}\n`;
    testLogOutputArea.scrollTop = testLogOutputArea.scrollHeight;
    if (event.data.includes('event: end')) {
      stopEventSource();
      startTestScriptButton.disabled = false;
      stopTestScriptButton.disabled = true;
      isTestScriptRunning = false;
    }
  };

  eventSource.onerror = (error) => {
    console.error('EventSource error:', error);
    stopEventSource();
  };
}

function stopEventSource() {
  if (eventSource) {
    eventSource.close();
    eventSource = null;
  }
}