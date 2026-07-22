const fs = require('fs');
const path = require('path');
const { execSync } = require('child_process');

function walk(dir) {
    let results = [];
    if (!fs.existsSync(dir)) return results;
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

const hooks = walk('./hooks');
let unused = [];

hooks.forEach(hook => {
    const baseName = path.basename(hook, path.extname(hook));
    try {
        const out = execSync(`rg -l "${baseName}" ./app ./components ./hooks ./lib`);
        const files = out.toString().trim().split('\n').filter(f => path.resolve(f) !== path.resolve(hook));
        if (files.length === 0) {
            unused.push(hook);
        }
    } catch (e) {
        unused.push(hook);
    }
});

console.log(unused.join('\n'));
