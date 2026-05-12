# Innov4web Registrar Module for WHMCS

Módulo de registrar para WHMCS que permite gerir domínios através da API da Innov4web. Os clientes instalam este módulo no seu WHMCS e ficam a usar a infraestrutura da Innov4web como registrar.

## Instalação

1. Copia a pasta `modules/registrars/innov4web/` para `modules/registrars/` na instalação do teu WHMCS.
2. No painel de administração do WHMCS vai a **Setup → Products/Services → Domain Registrars**.
3. Ativa o módulo **Innov4web** e preenche as credenciais:
   - **API Username** — username fornecido pela Innov4web
   - **API Password** — password fornecida pela Innov4web

## Configuração

O módulo liga-se à API em `https://api.innov4web.pt/v1/`. Não é necessário alterar o URL — está definido diretamente em `class.php`.

## Funcionalidades suportadas

| Função WHMCS | Descrição |
|---|---|
| Registo de domínio | `innov4web_RegisterDomain` |
| Renovação | `innov4web_RenewDomain` |
| Transferência | `innov4web_TransferDomain` |
| Obter nameservers | `innov4web_GetNameservers` |
| Guardar nameservers | `innov4web_SaveNameservers` |
| Obter código EPP | `innov4web_GetEPPCode` |
| Sincronização de estado | `innov4web_Sync` |
| Sincronização de transferência | `innov4web_TransferSync` |
| Gestão DNSSEC (botão custom) | `innov4web_dnssecds` |

## DNSSEC

A gestão de DNSSEC é feita através de um **Client Area Custom Button** (`Manage DNSSEC`) que abre uma página dedicada com template próprio (`dnssecds.tpl`).

O cliente pode, a partir dessa página:
- **Ver** os registos DS ativos no domínio
- **Adicionar** um novo registo DS (Key Tag, Algorithm, Digest Type, Digest)
- **Editar** um registo existente (remove o antigo e adiciona o novo)
- **Remover** um registo DS

Cada operação chama a API Innov4web (`POST /v1/domains/{domain}/dnssec` ou `DELETE`) que por sua vez comunica com o WHMCS da Innov4web via hook EPP.

Cada registo DS é identificado pelos campos: `keytag`, `algorithm`, `digesttype` e `digest`.

> **Nota:** O suporte a DNSSEC requer que o domínio esteja registado através do módulo `cozaeppv2` no WHMCS da Innov4web, com acesso EPP à DNS.PT.

## Estrutura de ficheiros

```
modules/registrars/innov4web/
├── innov4web.php    # Funções do módulo WHMCS
├── class.php        # Cliente HTTP para a API Innov4web
└── dnssecds.tpl     # Template da página de gestão DNSSEC
```

## Autenticação

Cada chamada à API faz login, executa a operação e faz logout automaticamente. O token Bearer tem validade de 24 horas mas é sempre revogado no final de cada chamada.

## Requisitos

- WHMCS 8.x ou superior
- PHP 7.4+
- Extensão cURL ativa no PHP
