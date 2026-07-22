const { Client } = require('pg');
const fs = require('fs');

async function run() {
  const client = new Client({
    connectionString: "postgresql://postgres:postgres@127.0.0.1:54322/postgres"
  });
  await client.connect();
  const sql = fs.readFileSync('supabase/seeds/seed_complete.sql', 'utf8');
  try {
    await client.query(sql);
    console.log("Success");
  } catch (err) {
    console.error("Error executing seed:", err.message);
  } finally {
    await client.end();
  }
}
run();
