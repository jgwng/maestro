const express = require('express');
const path = require('path');
const { exec, spawn } = require('child_process');
const app = express();
const fs = require('fs');
const port = 8080;

app.use(express.static('web'));
app.use(express.json());

const execCommand = (command) => {
  return new Promise((resolve, reject) => {
    exec(command, (error, stdout, stderr) => {
      if (error) {
        reject(`Error executing command: ${error.message}`);
      } else if (stderr) {
        reject(`Error output: ${stderr}`);
      } else {
        resolve(stdout);
      }
    });
  });
};
// Serve the index.html file
app.get('/', (req, res) => {
  res.sendFile(path.join(__dirname, 'web', 'index.html'));
});
const defaultFolders = [
  'test1', 'test2', 'test3', 'test4','test5',
  'test6', 'test7', 'test3', 'test4','test5',
];
const deviceDescriptions = new Map([
  
]);
// Endpoint to get the list of folders
app.get('/folders', (req, res) => {
  // Extract pagination parameters from the query
  const page = parseInt(req.query.page) || 1;
  const itemsPerPage = parseInt(req.query.itemsPerPage) || 10;

  // Calculate start and end index for pagination
  const start = (page - 1) * itemsPerPage;
  const end = start + itemsPerPage;

  // Paginate the default folders list
  const paginatedFolders = defaultFolders.slice(start, end);

  // Calculate total pages
  const totalPages = Math.ceil(defaultFolders.length / itemsPerPage);

  // Return the paginated folders list along with pagination info
  res.json({
      folders: paginatedFolders,
      totalItems: defaultFolders.length,
      currentPage: page,
      totalPages: totalPages
  });
});

//연결되어 있는 안드로이드 기기들과 IOS 에뮬레이터
app.get('/devices', async (req, res) => {
  try {
    // Execute the 'adb devices' command
    const adbDevicesOutput = await execCommand('adb devices');
    // Parse the output to get a list of ADB devices with names
    const adbDevices = adbDevicesOutput.split('\n')
        .filter(line => line.includes('\tdevice'))
        .map(line => {
          const uuid = line.split('\t')[0];
          const name = deviceDescriptions.get(uuid) || 'Unknown Android Device';
          return { uuid, name };
        });

    // Try to execute the 'xcrun simctl list devices' command
    let iosSimulators = [];
    try {
      const iosSimulatorsOutput = await execCommand("xcrun simctl list devices | grep Booted");
      iosSimulators = iosSimulatorsOutput.trim().split('\n')
          .filter(line => line)
          .map(line => {
            const trimmedLine = line.trim();  // Trim leading and trailing whitespace
            const matches = trimmedLine.match(/^(.*) \(([^)]+)\) \(Booted\)$/);
            if (matches && matches.length === 3) {
              const name = matches[1].trim();
              const uuid = matches[2].trim();
              return { uuid, name };
            } else {
              return { uuid: 'Unknown', name: 'Unknown iOS Simulator' };
            }
          });
    } catch (iosError) {
      console.error('iOS Simulators Error:', iosError);
    }

    // Send the combined result as JSON
    res.json({
      adbDevices,
      iosSimulators
    });
  } catch (error) {
    // Handle any errors that occurred during the execution of commands
    console.error('Error:', error);
    res.status(500).send(`Error executing command: ${error}`);
  }
});

app.post('/start_test_script', async (req, res) => {
  if (studioProcess) {
    return res.status(400).send('Script already running');
  }

  if (!deviceUUID) {
    deviceUUID = await getConnectedDeviceUUID();
    if (!deviceUUID) {
      return res.status(400).send('No connected device found');
    }
  }

  fs.writeFileSync(yamlPath, req.body);

  const command = `maestro --device ${deviceUUID} test ${yamlPath}`;
  studioProcess = exec(command);

  logMessages = []; // Reset log messages

  studioProcess.stdout.on('data', (data) => {
    const lines = data.toString().split('\n').filter(line => line.trim() !== '');
    lines.forEach(line => logMessages.push(line));
  });

  studioProcess.stderr.on('data', (data) => {
    logMessages.push(`Maestro error: ${data.toString()}`);
  });

  studioProcess.on('close', (code) => {
    logMessages.push(`Maestro process exited with code ${code}`);
    logMessages.push('event: end'); // Signal end of script execution
    studioProcess = null;
  });

  res.send('Script started');
});

app.get('/stream_logs', (req, res) => {
  res.setHeader('Content-Type', 'text/event-stream');
  res.setHeader('Cache-Control', 'no-cache');
  res.setHeader('Connection', 'keep-alive');

  const sendLogMessages = () => {
    logMessages.forEach((message) => {
      res.write(`data: ${message}\n\n`);
    });
  };

  sendLogMessages();

  const intervalId = setInterval(() => {
    sendLogMessages();
    logMessages = []; // Clear sent messages
  }, 1000);

  req.on('close', () => {
    clearInterval(intervalId);
    res.end();
  });
});
app.post('/stop_test_script', (req, res) => {
  if (!studioProcess) {
    return res.status(400).send('No script running');
  }

  studioProcess.kill();
  studioProcess = null;

  // Close WebSocket connection, delete screenshots folder, and delete script file
  if (wsClient) {
    wsClient.close();
    wsClient = null;
  }
  console.log('Script stopped and cleaned up resources.');

  res.send('Script stopped');
});

const getConnectedDeviceUUID = async () => {
  try {
    // Execute the 'adb devices' command
    const adbDevicesOutput = await execCommand('adb devices');
    // Parse the output to get a list of ADB devices with names
    const adbDevices = adbDevicesOutput.split('\n')
      .filter(line => line.includes('\tdevice'))
      .map(line => {
        const uuid = line.split('\t')[0];
        return { uuid, name: uuid };
      });
    return adbDevices.length > 0 ? adbDevices[0].uuid : null;
  } catch (error) {
    console.error('Error getting connected devices:', error);
    return null;
  }
};

// Function to get the list of folders in a directory
function getFolders(directory) {
  return fs.readdirSync(directory).filter(file => {
    return fs.statSync(path.join(directory, file)).isDirectory();
  });
}

// Start the server
server.listen(port, () => {
  console.log(`Server running at http://localhost:${port}`);
});

