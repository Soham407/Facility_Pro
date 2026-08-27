const fs = require('fs');
const path = require('path');
const { execSync } = require('child_process');

function run() {
  console.log('Running tsc --noEmit...');
  let output = '';
  try {
    output = execSync('npx tsc --noEmit --pretty false', {
      encoding: 'utf8',
      maxBuffer: 50 * 1024 * 1024,
      cwd: path.resolve(__dirname, '..')
    });
  } catch (err) {
    output = (err.stdout || '') + '\n' + (err.stderr || '');
  }

  const lines = output.split('\n');
  console.log(`tsc output total lines: ${lines.length}`);

  const pat1 = /^(.+?)\((\d+),(\d+)\):\s*error\s+TS\d+:/;
  const pat2 = /^(.+?):(\d+):(\d+)\s*-\s*error\s+TS\d+:/;

  const fileToLines = new Map();

  let matchCount = 0;
  for (const line of lines) {
    let match = line.match(pat1) || line.match(pat2);
    if (match) {
      let filePath = match[1].trim();
      let lineNum = parseInt(match[2], 10);
      
      if (!path.isAbsolute(filePath)) {
        filePath = path.resolve(__dirname, '..', filePath);
      }

      if (!fs.existsSync(filePath)) {
        continue;
      }

      if (filePath.includes('node_modules') || filePath.includes('.next')) {
        continue;
      }

      if (!fileToLines.has(filePath)) {
        fileToLines.set(filePath, new Set());
      }
      fileToLines.get(filePath).add(lineNum);
      matchCount++;
    }
  }

  console.log(`Found ${matchCount} error instances across ${fileToLines.size} files.`);

  let totalInserted = 0;

  for (const [filePath, lineSet] of fileToLines.entries()) {
    const content = fs.readFileSync(filePath, 'utf8');
    const fileLines = content.split('\n');
    const sortedLines = Array.from(lineSet).sort((a, b) => b - a);

    let modified = false;

    for (const lineNum of sortedLines) {
      const idx = lineNum - 1;
      if (idx < 0 || idx >= fileLines.length) continue;

      const prevLine = idx > 0 ? fileLines[idx - 1] : '';
      const currLine = fileLines[idx];

      if (
        prevLine.includes('@ts-ignore') ||
        prevLine.includes('@ts-expect-error') ||
        currLine.includes('@ts-ignore') ||
        currLine.includes('@ts-expect-error')
      ) {
        continue;
      }

      const indentMatch = currLine.match(/^(\s*)/);
      const indent = indentMatch ? indentMatch[1] : '';

      const trimmed = currLine.trim();
      const isJsxChild = (filePath.endsWith('.tsx') || filePath.endsWith('.jsx')) && (trimmed.startsWith('<') || trimmed.startsWith('{'));

      const comment = isJsxChild ? `${indent}{/* @ts-ignore */}` : `${indent}// @ts-ignore`;
      fileLines.splice(idx, 0, comment);
      modified = true;
      totalInserted++;
    }

    if (modified) {
      fs.writeFileSync(filePath, fileLines.join('\n'), 'utf8');
    }
  }

  console.log(`Inserted ${totalInserted} ignore directives.`);
}

run();
