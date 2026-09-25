Redmine LaTeX MathJax Macro Plugin - Redmine 7 adaptation
==========================================================

This plugin enables MathJax rendering in Redmine wiki pages, issues, and other views.
This adaptation targets Redmine 7.0+ (Rails 8 / Propshaft).

Requirements
------------

- Redmine 7.0 or later
- CommonMark selected as the Redmine text formatter

The bundled MathJax build is MathJax 3.0.5 with the existing Propshaft
`RAILS_ASSET_URL()` font-path patch retained.

Installation
------------

1. Extract the plugin as:

       /your/path/to/redmine/plugins/redmine_latex_mathjax

2. Restart Redmine (or rebuild/restart the Redmine container).

The plugin has no additional Gem dependencies and no database migration.

After restart, open Administration -> Plugins and confirm that
"Redmine LaTeX MathJax Macro" is listed.

The Redmine log should contain:

    [redmine_latex_mathjax] CommonMark math_dollars=true; sanitizer data-math-style=true

If either value is false, the CommonMark bridge is not active and should be fixed
before testing rendered equations.

Usage
-----

Inline TeX:

    Activation energy $E_{\mathrm{a}}$ was evaluated.

Display math:

    $$
    k = A \exp\left(-\frac{E_{\mathrm{a}}}{RT}\right)
    $$

TeX spacing commands such as `\,`, `\;`, and `\!` are preserved in CommonMark
content because CommonMarker recognizes the math region before normal Markdown
escaping.

The `mj` macro remains available:

    {{mj(\sum_i x_i)}}

or:

    {{mj
    P_{POWER} =
    \cfrac{U_{POWER}}{I_{POWER}}
    }}

How the Redmine 7 bridge works
------------------------------

Redmine 7 sends issue/wiki Markdown through CommonMarker and then through a
sanitizer. CommonMarker's `math_dollars` extension parses `$...$` and `$$...$$`
as semantic math spans before Markdown escaping can alter TeX punctuation.

This plugin enables that native extension, permits only CommonMarker's
`data-math-style` attribute on `span`, and converts those semantic spans back to
the configured MathJax delimiters immediately before MathJax's initial page typeset.

Views that do not pass through CommonMark, such as the activity summary, continue
to use the existing direct MathJax `$...$` / `$$...$$` path.

Testing
-------

After installation, test a newly edited or newly created issue with:

    A:
    $$ A \rightarrow B $$

    B:
    $$ A \rightleftharpoons B $$

    C:
    $$ A\,B $$

    D:
    $$ \mathrm{A\,B} $$

and an inline example:

    Activation energy $E_{\mathrm{a}}$ was evaluated.

When diagnosing an existing long issue, edit/resave it before testing so an older
formatted-text cache entry does not obscure formatter changes.

Notes
-----

MathJax output is client-side and is therefore not automatically included in
Redmine PDF exports.

Third-party license
-------------------

This plugin bundles MathJax 3.0.5 under the Apache License 2.0. The complete
MathJax license text is retained at `assets/mathjax/LICENSE`. See
`THIRD_PARTY_LICENSES.md` for the bundled version and the Propshaft-specific
modification notice.
