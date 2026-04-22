#!/bin/bash

clear

LOG_DIR="$HOME/logs"
mkdir -p "$LOG_DIR"
LOG_FILE="$LOG_DIR/$(date +'%Y-%m-%d_%H-%M')-install.log"

# Redireciona stdout e stderr para o log + mostra na tela
exec > >(awk '{ print strftime("[%H:%M:S]"), $0; fflush(); }' | tee -a "$LOG_FILE") 2>&1

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "================================="
echo "   ARCH SETUP INTERATIVO"
echo "================================="
echo ""
echo "Log: $LOG_FILE"
echo ""
echo "Escolha uma opção:"
echo "1) Setup Desenvolvimento"
echo "2) Setup Gamer"
echo "3) Setup Completo (Dev + Gamer)"
echo "4) Sair"
echo ""

read -p "Opção: " opcao

chmod +x "$REPO_ROOT/modules/gamer.sh"
chmod +x "$REPO_ROOT/modules/dev.sh"
GAMER=$REPO_ROOT/modules/gamer.sh
DEVELOPMENT=$REPO_ROOT/modules/dev.sh

case $opcao in
1)
  echo ">> Executando setup DEV..."
  $DEVELOPMENT
  ;;
2)
  echo ">> Executando setup GAMER..."
  $GAMER
  ;;
3)
  echo ">> Executando setup COMPLETO..."
  $DEVELOPMENT
  $GAMER
  ;;
4)
  echo "Saindo..."
  exit 0
  ;;
*)
  echo "Opção inválida!"
  ;;
esac

echo ""
echo "✔ Setup finalizado!"
