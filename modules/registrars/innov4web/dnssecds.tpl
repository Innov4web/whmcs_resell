{* Overlay de loading *}
<div id="dsOverlay"
    style="display:none; position:fixed; inset:0; background:rgba(0,0,0,.45); z-index:9999; align-items:center; justify-content:center;">
    <div style="background:#222; color:#fff; padding:20px 32px; border-radius:6px; font-size:15px;">
        <i class="fa fa-spinner fa-spin"></i> Processing...
    </div>
</div>

<div class="section">
    <div style="display:flex; align-items:baseline; justify-content:space-between; flex-wrap:wrap; gap:8px;">
        <div>
            <p class="" style="margin:0">{$domain}</p>
        </div>
        <button type="button" class="btn btn-primary btn-sm" id="btnShowAdd">
            <i class="fa fa-plus"></i> Add DS Record
        </button>
    </div>
</div>

<div id="dsMessages" style="margin-top:16px;"></div>

{if $error}
    <div class="section">
        {include file="$template/includes/alert.tpl" type="danger" msg=$error textcenter=true}
    </div>
{/if}
{if $success}
    <div class="section">
        {include file="$template/includes/alert.tpl" type="success" msg=$success textcenter=true}
    </div>
{/if}
<span id="ds-op-result" data-status="{if $error}error{else}ok{/if}" data-msg="{if $error}{$error|escape:'html'}{/if}"
    style="display:none"></span>

{* ── Formulário adicionar (oculto por defeito) ── *}
<div class="section" id="sectionAdd" style="display:none">
    <h4>New DS Record</h4>
    <form id="formAdd" role="form" method="post" action="clientarea.php">
        <input type="hidden" name="token" value="{$token}" />
        <input type="hidden" name="action" value="domaindetails" />
        <input type="hidden" name="id" value="{$domainid}" />
        <input type="hidden" name="modop" value="custom" />
        <input type="hidden" name="a" value="dnssecds" />
        <input type="hidden" name="command" value="secDNSadd" />
        <div class="TM-card">
            <div class="row">
                <div class="col-sm-3">
                    <div class="form-group">
                        <label class="control-label">Key Tag</label>
                        <input type="text" class="form-control" name="keyTag" maxlength="65535" />
                    </div>
                </div>
                <div class="col-sm-3">
                    <div class="form-group">
                        <label class="control-label">Algorithm</label>
                        <select class="form-control" name="alg">
                            <option value="8">RSA/SHA-256</option>
                            <option value="10">RSA/SHA-512</option>
                            <option value="13">ECDSA Curve P-256 with SHA-256</option>
                            <option value="14">ECDSA Curve P-384 with SHA-384</option>
                            <option value="15">Ed25519</option>
                            <option value="16">Ed448</option>
                            <option value="7">RSASHA1-NSEC3-SHA1</option>
                            <option value="5">RSA/SHA-1</option>
                            <option value="6">DSA-NSEC3-SHA1</option>
                            <option value="3">DSA/SHA1</option>
                            <option value="12">GOST R 34.10-2001</option>
                            <option value="2">Diffie-Hellman</option>
                            <option value="1">RSA/MD5</option>
                        </select>
                    </div>
                </div>
                <div class="col-sm-3">
                    <div class="form-group">
                        <label class="control-label">Digest Type</label>
                        <select class="form-control" name="digestType">
                            <option value="2">SHA-256</option>
                            <option value="4">SHA-384</option>
                            <option value="1">SHA-1</option>
                            <option value="3">GOST R 34.11-94</option>
                        </select>
                    </div>
                </div>
            </div>
            <div class="form-group">
                <label class="control-label">Digest</label>
                <textarea class="form-control" name="digest" rows="2"></textarea>
            </div>
        </div>
        <div class="form-actions">
            <button type="submit" class="btn btn-primary">Add Record</button>
            <button type="button" class="btn btn-default" id="btnCancelAdd">Cancel</button>
        </div>
    </form>
</div>

{* ── Registos actuais ── *}
{if !$error}
    {if $DSRecords eq 'YES'}
        <div class="section" id="sectionRecords">
            {foreach $DSRecordslist as $item}
                {assign var="idx" value=$item@key}

                {* Vista de leitura *}
                <div class="TM-card ds-record" id="view-{$idx}" data-keytag="{$item.keyTag}" data-alg="{$item.alg}"
                    data-digesttype="{$item.digestType}" data-digest="{$item.digest}">
                    <div class="row ds-view-row" style="align-items:center;">
                        <div class="col-sm-2">
                            <label class="control-label">Key Tag</label>
                            <p class="form-control-static ds-val-keytag">{$item.keyTag}</p>
                        </div>
                        <div class="col-sm-3">
                            <label class="control-label">Algorithm</label>
                            <p class="form-control-static ds-val-alg">
                                {if $item.alg == 1}RSA/MD5
                                {elseif $item.alg == 2}Diffie-Hellman
                                {elseif $item.alg == 3}DSA/SHA1
                                {elseif $item.alg == 5}RSA/SHA-1
                                {elseif $item.alg == 6}DSA-NSEC3-SHA1
                                {elseif $item.alg == 7}RSASHA1-NSEC3-SHA1
                                {elseif $item.alg == 8}RSA/SHA-256
                                {elseif $item.alg == 10}RSA/SHA-512
                                {elseif $item.alg == 12}GOST R 34.10-2001
                                {elseif $item.alg == 13}ECDSA Curve P-256 with SHA-256
                                {elseif $item.alg == 14}ECDSA Curve P-384 with SHA-384
                                {elseif $item.alg == 15}Ed25519
                                {elseif $item.alg == 16}Ed448
                                {else}{$item.alg}
                                {/if}
                            </p>
                        </div>
                        <div class="col-sm-2">
                            <label class="control-label">Digest Type</label>
                            <p class="form-control-static ds-val-digesttype">
                                {if $item.digestType == 1}SHA-1
                                {elseif $item.digestType == 2}SHA-256
                                {elseif $item.digestType == 3}GOST R 34.11-94
                                {elseif $item.digestType == 4}SHA-384
                                {else}{$item.digestType}
                                {/if}
                            </p>
                        </div>
                        <div class="col-sm-3">
                            <label class="control-label">Digest</label>
                            <p class="form-control-static ds-val-digest"
                                style="word-break:break-all;font-family:monospace;font-size:12px">{$item.digest}</p>
                        </div>
                        <div class="col-sm-2 text-right" style="padding-top:18px;">
                            <button type="button" class="btn btn-default btn-sm btn-ds-edit" title="Edit">
                                <i class="fa fa-pencil"></i>
                            </button>
                            <button type="button" class="btn btn-danger btn-sm btn-ds-remove" title="Remove">
                                <i class="fa fa-trash"></i>
                            </button>
                        </div>
                    </div>

                    {* Vista de edição (oculta) *}
                    <div class="ds-edit-panel" style="display:none;">
                        <div class="row">
                            <div class="col-sm-2">
                                <div class="form-group">
                                    <label class="control-label">Key Tag</label>
                                    <input type="text" class="form-control edit-keytag" maxlength="65535" />
                                </div>
                            </div>
                            <div class="col-sm-3">
                                <div class="form-group">
                                    <label class="control-label">Algorithm</label>
                                    <select class="form-control edit-alg">
                                        <option value="8">RSA/SHA-256</option>
                                        <option value="10">RSA/SHA-512</option>
                                        <option value="13">ECDSA Curve P-256 with SHA-256</option>
                                        <option value="14">ECDSA Curve P-384 with SHA-384</option>
                                        <option value="15">Ed25519</option>
                                        <option value="16">Ed448</option>
                                        <option value="7">RSASHA1-NSEC3-SHA1</option>
                                        <option value="5">RSA/SHA-1</option>
                                        <option value="6">DSA-NSEC3-SHA1</option>
                                        <option value="3">DSA/SHA1</option>
                                        <option value="12">GOST R 34.10-2001</option>
                                        <option value="2">Diffie-Hellman</option>
                                        <option value="1">RSA/MD5</option>
                                    </select>
                                </div>
                            </div>
                            <div class="col-sm-2">
                                <div class="form-group">
                                    <label class="control-label">Digest Type</label>
                                    <select class="form-control edit-digesttype">
                                        <option value="2">SHA-256</option>
                                        <option value="4">SHA-384</option>
                                        <option value="1">SHA-1</option>
                                        <option value="3">GOST R 34.11-94</option>
                                    </select>
                                </div>
                            </div>
                            <div class="col-sm-3">
                                <div class="form-group">
                                    <label class="control-label">Digest</label>
                                    <textarea class="form-control edit-digest" rows="2"></textarea>
                                </div>
                            </div>
                            <div class="col-sm-2" style="padding-top:24px; display:flex; gap:6px; align-items:flex-start;">
                                <button type="button" class="btn btn-primary btn-sm btn-ds-save">
                                    <i class="fa fa-check"></i>
                                </button>
                                <button type="button" class="btn btn-default btn-sm btn-ds-cancel">
                                    <i class="fa fa-times"></i>
                                </button>
                            </div>
                        </div>
                    </div>
                </div>

            {/foreach}
        </div>
    {else}
        <div class="section" id="sectionNoRecords">
            {include file="$template/includes/alert.tpl" type="info" msg=$DSRecords textcenter=true}
        </div>
    {/if}
{/if}

<script>
    var _dsConfig = {
        domainid: '{$domainid}',
        csrfToken: '{$token}',
        lang: {
            confirmRemove:    'Are you sure you want to remove this DS record?',
            errRemove:        'Error removing DS record.',
            errRequired:      'Key Tag and Digest are required.',
            errRemPrefix:     'Error removing old record: ',
            errRollbackFail:  'Update failed and rollback also failed: ',
            errRollbackOk:    'Update failed (original record restored): ',
            successUpdate:    'DS record updated successfully.',
            successRemove:    'DS record removed successfully.',
            errUnexpected:    'An unexpected error occurred.',
            noRecords:        'You don\'t have any DS records'
        }
    };
</script>
<script>
    {literal}
        (function() {
            var domainid  = _dsConfig.domainid;
            var csrfToken = _dsConfig.csrfToken;
            var L         = _dsConfig.lang;

            var algNames = {
                1: 'RSA/MD5',
                2: 'Diffie-Hellman',
                3: 'DSA/SHA1',
                5: 'RSA/SHA-1',
                6: 'DSA-NSEC3-SHA1',
                7: 'RSASHA1-NSEC3-SHA1',
                8: 'RSA/SHA-256',
                10: 'RSA/SHA-512',
                12: 'GOST R 34.10-2001',
                13: 'ECDSA Curve P-256 with SHA-256',
                14: 'ECDSA Curve P-384 with SHA-384',
                15: 'Ed25519',
                16: 'Ed448'
            };
            var digestNames = {1:'SHA-1', 2:'SHA-256', 3:'GOST R 34.11-94', 4:'SHA-384'};

            function showOverlay() { document.getElementById('dsOverlay').style.display = 'flex'; }

            function hideOverlay() { document.getElementById('dsOverlay').style.display = 'none'; }

            function showMsg(type, text) {
                var el = document.getElementById('dsMessages');
                el.innerHTML = '<div class="section"><div class="alert alert-' + type + ' text-center">' + text +
                    '</div></div>';
                setTimeout(function() { el.innerHTML = ''; }, 4000);
            }

            function postEpp(command, fields) {
                var body = 'token=' + encodeURIComponent(csrfToken) +
                    '&action=domaindetails&id=' + encodeURIComponent(domainid) +
                    '&modop=custom&a=dnssecds&command=' + encodeURIComponent(command);
                ['keyTag', 'alg', 'digestType', 'digest'].forEach(function(k) {
                    body += '&' + k + '=' + encodeURIComponent(fields[k]);
                });
                return fetch('clientarea.php', {
                    method: 'POST',
                    credentials: 'same-origin',
                    headers: {'Content-Type': 'application/x-www-form-urlencoded'},
                    body: body
                }).then(function(r) { return r.text(); });
            }

            function extractError(html) {
                var doc = new DOMParser().parseFromString(html, 'text/html');
                var el = doc.getElementById('ds-op-result');
                if (el && el.dataset.status === 'error') {
                    return el.dataset.msg || 'Erro desconhecido';
                }
                return null;
            }

            // ── Botão adicionar ──
            var btnShow    = document.getElementById('btnShowAdd');
            var btnCancel  = document.getElementById('btnCancelAdd');
            var sectionAdd = document.getElementById('sectionAdd');
            if (btnShow) {
                btnShow.addEventListener('click', function() {
                    sectionAdd.style.display = 'block';
                    btnShow.style.display = 'none';
                });
            }
            if (btnCancel) {
                btnCancel.addEventListener('click', function() {
                    sectionAdd.style.display = 'none';
                    btnShow.style.display = '';
                });
            }

            // ── Delegação de eventos nos cards ──
            var sectionRecords = document.getElementById('sectionRecords');
            if (sectionRecords) {
                sectionRecords.addEventListener('click', function(e) {
                    var btn = e.target.closest('button');
                    if (!btn) return;
                    var card = btn.closest('.ds-record');
                    if (!card) return;

                    if (btn.classList.contains('btn-ds-edit')) {
                        var panel   = card.querySelector('.ds-edit-panel');
                        var viewRow = card.querySelector('.ds-view-row');
                        panel.querySelector('.edit-keytag').value     = card.dataset.keytag;
                        panel.querySelector('.edit-alg').value         = card.dataset.alg;
                        panel.querySelector('.edit-digesttype').value  = card.dataset.digesttype;
                        panel.querySelector('.edit-digest').value      = card.dataset.digest;
                        viewRow.style.display = 'none';
                        panel.style.display   = 'block';
                        card.style.borderLeft = '3px solid var(--primary)';
                    }

                    if (btn.classList.contains('btn-ds-cancel')) {
                        var panel   = card.querySelector('.ds-edit-panel');
                        var viewRow = card.querySelector('.ds-view-row');
                        panel.style.display   = 'none';
                        viewRow.style.display = '';
                        card.style.borderLeft = '';
                    }

                    if (btn.classList.contains('btn-ds-remove')) {
                        if (!confirm(L.confirmRemove)) return;
                        showOverlay();
                        postEpp('secDNSrem', {
                                keyTag:     card.dataset.keytag,
                                alg:        card.dataset.alg,
                                digestType: card.dataset.digesttype,
                                digest:     card.dataset.digest
                            })
                            .then(function(html) {
                                hideOverlay();
                                var remErr = extractError(html);
                                if (remErr) { showMsg('danger', remErr); return; }
                                card.remove();
                                var remaining = sectionRecords.querySelectorAll('.ds-record');
                                if (remaining.length === 0) {
                                    sectionRecords.innerHTML =
                                        '<div class="alert alert-info text-center">' + L.noRecords + '</div>';
                                }
                                showMsg('success', L.successRemove);
                            })
                            .catch(function() {
                                hideOverlay();
                                showMsg('danger', L.errRemove);
                            });
                    }

                    if (btn.classList.contains('btn-ds-save')) {
                        var panel         = card.querySelector('.ds-edit-panel');
                        var newKeyTag     = panel.querySelector('.edit-keytag').value.trim();
                        var newAlg        = panel.querySelector('.edit-alg').value;
                        var newDigestType = panel.querySelector('.edit-digesttype').value;
                        var newDigest     = panel.querySelector('.edit-digest').value.trim();
                        if (!newKeyTag || !newDigest) {
                            showMsg('danger', L.errRequired);
                            return;
                        }

                        var origData = {
                            keyTag:     card.dataset.keytag,
                            alg:        card.dataset.alg,
                            digestType: card.dataset.digesttype,
                            digest:     card.dataset.digest
                        };
                        var newData = {keyTag:newKeyTag, alg:newAlg, digestType:newDigestType, digest:newDigest};

                        function closeEditPanel() {
                            panel.style.display   = 'none';
                            card.style.borderLeft = '';
                            card.querySelector('.ds-view-row').style.display = '';
                        }

                        showOverlay();

                        postEpp('secDNSrem', origData)
                            .then(function(remHtml) {
                                var remErr = extractError(remHtml);
                                if (remErr) {
                                    hideOverlay();
                                    showMsg('danger', L.errRemPrefix + remErr);
                                    throw null;
                                }
                                return postEpp('secDNSadd', newData);
                            })
                            .then(function(addHtml) {
                                if (!addHtml) return;
                                var addErr = extractError(addHtml);
                                if (addErr) {
                                    return postEpp('secDNSadd', origData).then(function(rollbackHtml) {
                                        hideOverlay();
                                        closeEditPanel();
                                        var rollbackErr = extractError(rollbackHtml);
                                        if (rollbackErr) {
                                            showMsg('danger', L.errRollbackFail + addErr);
                                        } else {
                                            showMsg('danger', L.errRollbackOk + addErr);
                                        }
                                    });
                                }
                                hideOverlay();
                                card.dataset.keytag     = newKeyTag;
                                card.dataset.alg        = newAlg;
                                card.dataset.digesttype = newDigestType;
                                card.dataset.digest     = newDigest;
                                card.querySelector('.ds-val-keytag').textContent     = newKeyTag;
                                card.querySelector('.ds-val-alg').textContent        = algNames[newAlg] || newAlg;
                                card.querySelector('.ds-val-digesttype').textContent = digestNames[newDigestType] || newDigestType;
                                card.querySelector('.ds-val-digest').textContent     = newDigest;
                                closeEditPanel();
                                showMsg('success', L.successUpdate);
                            })
                            .catch(function(e) {
                                if (e === null) return;
                                hideOverlay();
                                closeEditPanel();
                                showMsg('danger', L.errUnexpected);
                            });
                    }
                });
            }
        }());
    {/literal}
</script>
