// window.addEventListener('beforeunload', (event) => {
//     event.preventDefault();
//     // Chrome에서는 returnValue 설정이 필요함
//     event.returnValue = '';
// });


const deviceForm = document.getElementById('deviceForm');
const deviceList = document.getElementById('deviceList');
const noDevicesMessage = document.getElementById('noDevicesMessage');
const loadingElement = document.getElementById('loading');
const runScriptButton = document.getElementById('runScriptButton');
const logOutput = document.getElementById('logOutput');
const loadingIndicator = document.getElementById('loadingIndicator');
const stopScriptButton = document.getElementById('stopScriptButton');
const preElement = document.querySelector('pre');

let selectedOrder = [];
let orderCount = 0;
let isScriptRunning = false;

function checkDeviceList() {
    const scriptForm = document.getElementById('scriptForm');
    const deviceForm = document.getElementById('deviceForm');
    const deviceList = document.getElementById('deviceList');
    const noDevicesMessage = document.getElementById('noDevicesMessage');
    const loadingElement = document.getElementById('loading');

    if (deviceList.children.length > 0) {
        deviceList.style.display = 'block';
        noDevicesMessage.style.display = 'none';
        loadingElement.style.display = 'none';
        deviceForm.classList.remove('centered');

        // Compare heights and set both to the larger one
        const scriptFormHeight = scriptForm.offsetHeight;
        const deviceFormHeight = deviceForm.offsetHeight;
        const maxHeight = Math.max(scriptFormHeight, deviceFormHeight);
        
        scriptForm.style.height = `${maxHeight}px`;
        deviceForm.style.height = `${maxHeight}px`;
    } else {
        deviceList.style.display = 'none';
        deviceForm.style.height = `${scriptForm.offsetHeight}px`;
        noDevicesMessage.style.display = 'flex'; // or 'block', depending on your layout
        loadingElement.style.display = 'none';
        deviceForm.classList.add('centered');
    }
}

// Add devices to the list
function addDevicesToList(devices, fragment, type,platform) {
    if (devices && devices.length > 0) {
        devices.forEach(device => {
            const listItem = document.createElement('div');
            listItem.classList.add('radio-item'); // Add class for consistent styling

            const radio = document.createElement('input');
            radio.type = 'radio';
            radio.name = 'device';
            radio.value = device.uuid;
            radio.dataset.platform = platform; // Store platform info
            radio.id = `${type}-${device.uuid}`;

            const label = document.createElement('label');
            label.htmlFor = radio.id;
            label.textContent = device.name;

            listItem.appendChild(radio);
            listItem.appendChild(label);
            fragment.appendChild(listItem);
        });
    }
}
let itemsPerPage = 5;
let currentPage = 1;
let selectedItems = {};

function fetchScriptList(page = 1) {
    const scriptForm = document.getElementById('scriptForm');
    const deviceForm = document.getElementById('deviceForm');
    currentPage = page;

    // Fetch the folder list from the server with pagination
    fetch(`/folders?page=${page}&itemsPerPage=${itemsPerPage}`)
        .then(response => response.json())
        .then(data => {
            scriptForm.innerHTML = '';

            const { folders, totalItems, totalPages } = data;
            const foldersToShow = folders;

            foldersToShow.forEach((folder, index) => {
                const radioItem = document.createElement('div');
                radioItem.className = 'radio-item';

                const itemIndex = (index + 1) + (page - 1) * itemsPerPage;
                const checkbox = document.createElement('input');
                checkbox.type = 'checkbox';
                checkbox.id = `script${itemIndex}`;
                checkbox.name = 'script';
                checkbox.value = folder;

                // Check if the item is in the selectedItems object
                if (selectedItems[folder]) {
                    checkbox.checked = true;
                }

                checkbox.addEventListener('change', (event) => {
                    if (event.target.checked) {
                        selectedItems[folder] = selectedItems[folder] || { order: Object.keys(selectedItems).length + 1 };
                    } else {
                        const order = selectedItems[folder].order;
                        delete selectedItems[folder];
                        updateOrderNumbers(order);
                    }
                    updateOrderNumbersDisplay();
                });

                const label = document.createElement('label');
                label.htmlFor = `script${itemIndex}`;
                label.textContent = folder;

                const orderNumber = document.createElement('span');
                orderNumber.className = 'order-number';
                orderNumber.id = `order-script${itemIndex}`;
                if (selectedItems[folder]) {
                    orderNumber.textContent = selectedItems[folder].order;
                }

                label.appendChild(orderNumber);
                radioItem.appendChild(checkbox);
                radioItem.appendChild(label);
                scriptForm.appendChild(radioItem);
                deviceForm.style.height = `${scriptForm.offsetHeight}px`;
            });

            updatePaginationControls(totalPages);
        })
        .catch(error => {
            console.error('Error fetching folders:', error);
        });
}

function updateOrderNumbers(orderToRemove) {
    for (let folder in selectedItems) {
        if (selectedItems[folder].order > orderToRemove) {
            selectedItems[folder].order--;
        }
    }
}

function updateOrderNumbersDisplay() {
    document.querySelectorAll('.order-number').forEach(span => {
        const folder = span.previousSibling.textContent;
        if (selectedItems[folder]) {
            span.textContent = selectedItems[folder].order;
        } else {
            span.textContent = '';
        }
    });
}

function updatePaginationControls(totalPages) {
    const paginationControls = document.getElementById('paginationControls');
    paginationControls.innerHTML = '';

    const ul = document.createElement('ul');
    ul.className = 'pagination';

    // Previous button
    const prevLi = document.createElement('li');
    prevLi.className = `page-item ${currentPage === 1 ? 'disabled' : ''}`;

    const prevLink = document.createElement('a');
    prevLink.className = 'page-link';
    prevLink.href = '#';
    prevLink.textContent = '이전';
    prevLink.onclick = (event) => {
        event.preventDefault();
        if (currentPage > 1) {
            fetchScriptList(currentPage - 1);
        }
    };

    prevLi.appendChild(prevLink);
    ul.appendChild(prevLi);

    // Next button
    const nextLi = document.createElement('li');
    nextLi.className = `page-item ${currentPage === totalPages ? 'disabled' : ''}`;

    const nextLink = document.createElement('a');
    nextLink.className = 'page-link';
    nextLink.href = '#';
    nextLink.textContent = '다음';
    nextLink.onclick = (event) => {
        event.preventDefault();
        if (currentPage < totalPages) {
            fetchScriptList(currentPage + 1);
        }
    };

    nextLi.appendChild(nextLink);
    ul.appendChild(nextLi);

    paginationControls.appendChild(ul);
}
//PC에 연결되어 있는 디바이스 목록 조회
//Maestro는 IOS 실기기 빌드가 안되기 때문에 열려져 있는 Simulator만 가져오도록 설정
function fetchDeviceList(){
        const loadingElement = document.getElementById('loading');
        const noDevicesMessage = document.getElementById('noDevicesMessage');
        const scriptForm = document.getElementById('scriptForm');
        const deviceForm = document.getElementById('deviceForm');
        deviceForm.style.height = `${scriptForm.offsetHeight}px`;
        loadingElement.style.display = 'block';
        noDevicesMessage.style.display = 'none';
        fetch('/devices')
            .then(response => response.json())
            .then(data => {
                const deviceList = document.getElementById('deviceList');
                const fragment = document.createDocumentFragment();

                // Clear the deviceList before adding new elements
                deviceList.innerHTML = '';

                // 연결되어 있는 안드로이드 기기 조회
                addDevicesToList(data.adbDevices, fragment, 'device','ANDROID');

                // 연결되어 있는 IOS Simulator 조회
                addDevicesToList(data.iosSimulators, fragment, 'simulator','IOS');

                deviceList.appendChild(fragment);
            })
            .catch(error => {
                const deviceList = document.getElementById('deviceList');
                deviceList.innerHTML = `Error: ${error}`;
            })
            .finally(() => {
                loadingElement.style.display = 'none'; 
                checkDeviceList();
            });
}

document.addEventListener('DOMContentLoaded', () => {
    const scriptForm = document.getElementById('scriptForm');
    const deviceForm = document.getElementById('deviceForm');
    fetchScriptList(currentPage);
    fetchDeviceList();
    // Handle selection logic for both forms
    function handleFormClick(event, form) {
        if (event.target.name === 'script') {
            handleScriptSelection(event, form);
        } else if (event.target.name === 'device') {
            handleDeviceSelection(event, form);
        }
    }

    // 스크립트 목록 내에서 아이템 선택시 호출되는 함수
    // 선택한 순서에 따라 스크립트 실행되도록 설정
    function handleScriptSelection(event, form) {
        const inputId = event.target.id;
        const labelElement = document.querySelector(`label[for="${inputId}"]`);
        const labelText = labelElement.textContent.trim().replace(/\d+$/, '').trim();
        const orderNumberElement = document.getElementById(`order-${inputId}`);

        if (selectedOrder.includes(labelText)) {
            deselectItem(labelText, orderNumberElement, labelElement, form, inputId);
        } else {
            selectItem(labelText, orderNumberElement, labelElement);
        }
        document.body.focus();
    }

    // 디바이스 목록 내에서 아이템 선택시 호출되는 함수
    // 최대 1개의 기기만 선택 가능
    function handleDeviceSelection(event, form) {
        const inputId = event.target.id;
        const labelElement = document.querySelector(`label[for="${inputId}"]`);

        form.querySelectorAll('input').forEach(input => {
            document.querySelector(`label[for="${input.id}"]`).classList.remove('selected');
            input.checked = false;
        });

        event.target.checked = true;
        labelElement.classList.add('selected');
        document.body.focus();
    }

    // Select an item
    function selectItem(labelText, orderNumberElement, labelElement) {
        selectedOrder.push(labelText);
        orderCount++;
        orderNumberElement.textContent = orderCount;
        labelElement.classList.add('selected');
    }

    
    function deselectItem(labelText, orderNumberElement, labelElement, form, inputId) {
        const index = selectedOrder.indexOf(labelText);
        selectedOrder.splice(index, 1);
        orderCount--;

        
        orderNumberElement.textContent = '';

        // 스크립트 옆의 실행 순서 번호 변경
        updateOrderNumbers(form);

        // Uncheck the radio button after a slight delay
        setTimeout(() => {
            document.getElementById(inputId).checked = false;
            labelElement.classList.remove('selected');
        }, 0);
    }

    // 선택한 순서에 따른 번경
    function updateOrderNumbers(form) {
        selectedOrder.forEach((item, i) => {
            const itemId = Array.from(form.querySelectorAll('input')).find(input => {
                const itemLabelText = document.querySelector(`label[for="${input.id}"]`).textContent.trim().replace(/\d+$/, '').trim();
                return itemLabelText === item;
            }).id;
            document.getElementById(`order-${itemId}`).textContent = i + 1;
        });
    }

    
    scriptForm.addEventListener('click', (event) => handleFormClick(event, scriptForm));
    deviceForm.addEventListener('click', (event) => handleFormClick(event, deviceForm));

    // 기기 조회 버튼
    document.getElementById('showDevices').addEventListener('click', () =>fetchDeviceList());
   
    document.getElementById('runScriptButton').addEventListener('click', () => runSelectScript());
    document.getElementById('startStudioButton').addEventListener('click', () => runMaestroStudio());
});



function runSelectScript(){
    if (isScriptRunning) {
        alert('현재 스크립트가 실행중입니다!');
        return;
    }

    const selectedItems = Array.from(document.querySelectorAll('#scriptForm input[type="checkbox"]:checked'))
        .map(item => item.value);
    const selectedDevice = document.querySelector('input[name="device"]:checked');
    
    

    if (!selectedItems.length || !selectedDevice) {
        alert('실행할 스크립트와 기기 모두 선택해야합니다!');
        return;
    }
    // Disable the runScriptButton
    runScriptButton.disabled=true;
    bvtTestButton.disabled = true;    
    logOutput.textContent = '';  
    loadingIndicator.style.display = 'block'; 
    stopScriptButton.style.display = 'inline-block'; 
    isScriptRunning = true; 

    const data = {
        selectedItems,
        uuid: selectedDevice.value
    };

    eventSource = new EventSource(`/generate-and-run-yaml?selectedItems=${encodeURIComponent(data.selectedItems.join(','))}&uuid=${data.uuid}&platform=${selectedDevice.dataset.platform}`);

    function stopButtonListener(){
        eventSource.close();
        fetch('/stop-maestro');
        stopTest('\n스크립트 실행을 중단했습니다.\n');
    }
    stopScriptButton.addEventListener('click', () => stopButtonListener());

    eventSource.onmessage = (event) => {
        loadingIndicator.style.display = 'none'; 
        preElement.style.display = 'block';
        logOutput.textContent += `${event.data}\n`;
        logOutput.scrollTop = logOutput.scrollHeight; 
    };

    eventSource.addEventListener('end', () => {
        eventSource.close();
        stopScriptButton.removeEventListener('click', () => stopButtonListener());
        stopTest('\n스크립트 실행을 중단했습니다.\n');
    });

    eventSource.onerror = (error) => {
        eventSource.close();
        stopScriptButton.removeEventListener('click', () => stopButtonListener());
        stopTest(`Error: ${error}\n`);
    };
}

function runMaestroStudio(){
    fetch('/maestro-url')
        .then(response => response.json())
        .then(data => {
            console.log('data : ' + data);
            if (data && data.port) {
                const host = window.location.hostname;
                const url = `http://${host}:${data.port}`;
                window.open(url, '_blank'); // Open the URL in a new tab
            } else {
                console.error('No port found in the response');
            }
        })
        .catch(error => {
            console.error('Error fetching maestro URL:', error);
        })
        .finally(() => {
            // Any cleanup tasks can be performed here
        });
}


function stopTest(logOutMessage){
    runScriptButton.disabled=false;
    bvtTestButton.disabled=false;
    loadingIndicator.style.display = 'none';
    stopScriptButton.style.display = 'none';
    logOutput.textContent += logOutMessage || '\n스크립트 실행을 중단했습니다.\n';
    isScriptRunning = false; 
}