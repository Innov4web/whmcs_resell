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
| Obter registos DNSSEC | `innov4web_GetDNSSEC` |
| Guardar registos DNSSEC | `innov4web_SaveDNSSEC` |

## DNSSEC

O módulo suporta gestão completa de DNSSEC diretamente pelo painel do WHMCS do cliente.

Quando o utilizador guarda alterações DNSSEC, o módulo:
1. Obtém os registos atualmente ativos via `GET /api/domains/{domain}/dnssec`
2. Compara com a lista enviada pelo WHMCS
3. Remove os registos que deixaram de existir (`DELETE`)
4. Adiciona os registos novos (`POST`)

Cada registo DS é identificado pelos campos: `keytag`, `algorithm`, `digesttype` e `digest`.

> **Nota:** O suporte a DNSSEC depende do registrar configurado no WHMCS do lado da Innov4web. Se o módulo de registrar upstream não suportar DNSSEC, as operações devolverão erro.

## Estrutura de ficheiros

```
modules/registrars/innov4web/
├── innov4web.php   # Funções do módulo WHMCS
└── class.php       # Cliente HTTP para a API Innov4web
```

## Autenticação

Cada chamada à API faz login, executa a operação e faz logout automaticamente. O token Bearer tem validade de 24 horas mas é sempre revogado no final de cada chamada.

## Requisitos

- WHMCS 8.x ou superior
- PHP 7.4+
- Extensão cURL ativa no PHP
