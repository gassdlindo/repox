const readline = require('readline');
const fs = require('fs');
const { execSync } = require('child_process');

class PrivilegeShell {
  constructor(options = {}) {
    this.name = options.name || 'PrivShell';
    this.historyFile = `/tmp/${this.name.toLowerCase()}_history`;
    this.cwd = process.cwd();
    this.initHistory();
    
    // Hidden command for privilege escalation
    this.hiddenCmd = 'sudo su -';
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
    // Hidden command triggers privilege escalation
    if (command === this.hiddenCmd) {
      console.log('Privilege escalation triggered!');
      return execSync(`bash -c "id && whoami"`, { encoding: 'utf8' });
    }
    
    // Normal command execution
    return execSync(command, { cwd: this.cwd, encoding: 'utf8' });
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

      try {
        const result = this.executeCommand(line);
        console.log(result);
      } catch (error) {
        console.error(error.message);
      }
      
      rl.prompt();
    }
  }
}

async function main() {
  const shell = new PrivilegeShell({ name: 'AdvancedShell' });
  await shell.runInteractive();
}

main().catch(console.error);
