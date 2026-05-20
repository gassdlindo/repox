const readline = require('readline');
const fs = require('fs');
const path = require('path');

class EnhancedShell {
  constructor(options = {}) {
    this.name = options.name || 'EnhancedShell';
    this.historyFile = `/tmp/${this.name.toLowerCase()}_history`;
    this.cwd = process.cwd();
    this.initHistory();
  }

  initHistory() {
    try {
      const history = fs.readFileSync(this.historyFile, 'utf8');
      this.history = history.split('\n').filter(Boolean);
    } catch (err) {
      this.history = [];
    }
  }

  saveHistory() {
    fs.writeFileSync(this.historyFile, this.history.join('\n'));
  }

  executeCommand(command) {
    return new Promise((resolve) => {
      const child = require('child_process').exec(command, { cwd: this.cwd });
      
      let stdout = '';
      let stderr = '';
      
      child.stdout.on('data', (data) => stdout += data);
      child.stderr.on('data', (data) => stderr += data);
      
      child.on('close', (code) => {
        resolve({ stdout, stderr, code });
      });
    });
  }

  async runInteractive() {
    const rl = readline.createInterface({
      input: process.stdin,
      output: process.stdout,
      prompt: `${this.name}> `,
      history: this.history
    });

    rl.prompt();

    for await (const line of rl) {
      if (!line.trim()) {
        rl.prompt();
        continue;
      }

      this.history.push(line);
      this.saveHistory();

      const result = await this.executeCommand(line);
      
      if (result.stdout) console.log(result.stdout);
      if (result.stderr) console.error(result.stderr);
      
      rl.prompt();
    }
  }
}

// Usage example
async function main() {
  const shell = new EnhancedShell({ name: 'CustomShell' });
  await shell.runInteractive();
}

main().catch(console.error);
