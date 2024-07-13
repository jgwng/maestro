const express = require('express');
const path = require('path');
const app = express();
const fs = require('fs');
const port = 8080;


app.use(express.static('web'));
app.use(express.json());

// Serve the index.html file
app.get('/', (req, res) => {
  res.sendFile(path.join(__dirname, 'web', 'index.html'));
});
const defaultFolders = [
  'onboarding', 'sign_up', 'login', 'make_single_challenge',
  'aaaa', 'bbbb', 'cccc', 'dddd', 'eeee', 'fffff'
];

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



// Function to get the list of folders in a directory
function getFolders(directory) {
  return fs.readdirSync(directory).filter(file => {
    return fs.statSync(path.join(directory, file)).isDirectory();
  });
}
// Start the server
app.listen(port, () => {
  console.log(`Server running at http://localhost:${port}`);
});
