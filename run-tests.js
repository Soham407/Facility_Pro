const { execSync } = require('child_process');
const fs = require('fs');

const files = fs.readdirSync('e2e').filter(f => f.endsWith('.spec.ts'));
for (const file of files) {
  console.log(`Running e2e/${file}...`);
  try {
    execSync(`npx playwright test e2e/${file} --reporter=json > e2e_results.json`, { stdio: 'ignore' });
  } catch (e) {
    let resultText = fs.readFileSync('e2e_results.json', 'utf8');
    const startIdx = resultText.indexOf('{');
    if (startIdx !== -1) {
      resultText = resultText.substring(startIdx);
    }
    const result = JSON.parse(resultText);
    const failedSpecs = result.suites?.flatMap(s => s.suites?.flatMap(ss => ss.specs?.filter(sp => !sp.ok) || []) || []) || [];
    if (failedSpecs.length > 0) {
      console.log(`FAILURES IN e2e/${file}:`);
      failedSpecs.forEach(t => console.log(`- ${t.title}: ${t.tests[0].results[0].error?.message?.split('\n')[0]}`));
      process.exit(1);
    }
  }
}
console.log('All tests passed!');
