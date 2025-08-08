const fs = require('fs');
require('dotenv').config();

const frontendEnvPath = '../client/.env.local'; // chemin vers projet React
const contractAddress = process.env.CONTRACT_ADDRESS;

fs.writeFileSync(frontendEnvPath, `REACT_APP_CONTRACT_ADDRESS=${contractAddress}\n`);
console.log('✅ Synced CONTRACT_ADDRESS to frontend');
