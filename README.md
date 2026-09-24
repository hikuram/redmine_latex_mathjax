Redmine LaTeX MathJax Macro Plugin - Redmine 7 adaptation
==========================================================

This plugin enables MathJax rendering in Redmine wiki pages, issues, and editor previews.
This adaptation targets Redmine 7.0+ (Rails 8 / Propshaft).

Requirements
------------

- Redmine 7.0 or later
- A browser with MutationObserver support

The bundled MathJax build is the same MathJax 3.0.5 code shipped by the source plugin,
with the existing Propshaft `RAILS_ASSET_URL()` font-path patch retained.

Installation
------------

1. Extract the plugin as:

       /your/path/to/redmine/plugins/redmine_latex_mathjax

2. Restart Redmine (or rebuild/restart the Redmine container).

The plugin has no additional Gem dependencies and no database migration.

After restart, open Administration -> Plugins and confirm that
"Redmine LaTeX MathJax Macro" is listed.

Usage
-----

Inline TeX can be written directly, for example:

    $E_{\mathrm{a}} = 25\ \mathrm{kJ\,mol^{-1}}$

Block math:

    $$
    k = A \exp\left(-\frac{E_{\mathrm{a}}}{RT}\right)
    $$

The `mj` macro remains available for expressions that conflict with Redmine's text formatter:

    {{mj(\sum_i x_i)}}

or:

    {{mj
    P_{POWER} =
    \cfrac{U_{POWER}}{I_{POWER}}
    }}

Redmine 7 preview handling
--------------------------

Redmine 7 loads the Preview tab asynchronously into `.wiki-preview`.
This adaptation does not override Redmine's `common/_preview` partial and does not replace
or monkey-patch the obsolete `submitPreview()` function.

Instead, it observes the target preview container after the Preview tab is clicked and runs
MathJax only after Redmine has replaced that container through its normal AJAX preview path.

Notes
-----

MathJax output is client-side and is therefore not automatically included in Redmine PDF exports.

Third-party license
-------------------

This plugin bundles MathJax 3.0.5 under the Apache License 2.0. The complete
MathJax license text is retained at `assets/mathjax/LICENSE`. See
`THIRD_PARTY_LICENSES.md` for the bundled version and the Propshaft-specific
modification notice.
