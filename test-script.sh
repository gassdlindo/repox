#!/bin/bash
# Script de teste educacional - APENAS PARA DEMONSTRAÇÃO
# Não faz nada malicioso

echo "=== Script baixado do GitHub ===" >> /tmp/github_test.log
echo "Data: $(date)" >> /tmp/github_test.log
echo "Usuário: $(whoami)" >> /tmp/github_test.log
echo "Hostname: $(hostname)" >> /tmp/github_test.log
echo "Script executado com sucesso!" >> /tmp/github_test.log

# Exibe uma mensagem amigável
echo "Teste concluído. Veja /tmp/github_test.log"
