# Innov4web — Módulo de Registrar para WHMCS

Este módulo permite que qualquer WHMCS use a Innov4web como registrar. Depois de instalado, os teus clientes registam, renovam e gerem domínios `.pt` diretamente pelo painel deles — tudo a passar pela infraestrutura da Innov4web nos bastidores.

## Como instalar

1. Copia a pasta `modules/registrars/innov4web/` para dentro de `modules/registrars/` no teu WHMCS.
2. No admin, vai a **Setup → Products/Services → Domain Registrars**, ativa o **Innov4web** e preenche:
   - **API Username** e **API Password** — as credenciais que a Innov4web te forneceu.
3. Pronto. O módulo liga-se automaticamente a `https://api.innov4web.pt/v1/`.

## O que funciona

- Registo, renovação e transferência de domínios
- Ver e atualizar nameservers
- Obter código EPP
- Sincronização automática de estado e de transferências
- Gestão completa de DNSSEC (ver abaixo)

## DNSSEC

No painel do cliente aparece um botão **Manage DNSSEC** em cada domínio. A partir daí o cliente consegue:

- Ver os registos DS ativos
- Adicionar um novo registo (Key Tag, Algorithm, Digest Type, Digest)
- Editar um registo existente
- Remover um registo


## Ficheiros

```
modules/registrars/innov4web/
├── innov4web.php    # lógica principal do módulo
├── class.php        # cliente HTTP para a API
└── dnssecds.tpl     # página de gestão DNSSEC
```

## Requisitos

- WHMCS 8.x ou superior
- PHP 7.4+
- cURL ativo no PHP
