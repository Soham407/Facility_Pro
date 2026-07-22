const fs = require('fs');
const path = require('path');
const { execSync } = require('child_process');

function walk(dir) {
    let results = [];
    const list = fs.readdirSync(dir);
    list.forEach(function(file) {
        file = dir + '/' + file;
        const stat = fs.statSync(file);
        if (stat && stat.isDirectory()) { 
            results = results.concat(walk(file));
        } else if (file.endsWith('.tsx') || file.endsWith('.ts')) {
            results.push(file);
        }
    });
    return results;
}

const components = walk('./components');
let unused = [];

components.forEach(comp => {
    const baseName = path.basename(comp, path.extname(comp));
    // search for the import in the whole project (excluding the file itself)
    try {
        const out = execSync(`rg -l "${baseName}" ./app ./components ./hooks ./lib`);
        const files = out.toString().trim().split('\n').filter(f => path.resolve(f) !== path.resolve(comp));
        if (files.length === 0) {
            unused.push(comp);
        }
    } catch (e) {
        // rg returns error if not found
        unused.push(comp);
    }
});

console.log(unused.join('\n'));
