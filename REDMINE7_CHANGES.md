Redmine 7 adaptation notes
==========================

Version 0.4.1
-------------

This version is based on the Redmine 7 / Propshaft adaptation that already bundled
MathJax 3.0.5 with its Apache-2.0 license and the Propshaft font-path patch.

The Redmine 7-specific math changes are intentionally narrow:

1. Keep the existing MathJax path unchanged for pages that do not pass through
   Redmine CommonMark formatting (for example, the activity view). Raw `$...$`
   and `$$...$$` remain valid MathJax delimiters.
2. Enable CommonMarker's native `math_dollars` extension only in Redmine's
   CommonMark formatter. CommonMarker therefore recognizes `$...$` and
   `$$...$$` before Markdown escaping can alter TeX sequences such as `\,`.
3. Preserve CommonMarker's semantic `data-math-style="inline|display"` attribute
   by adding only that attribute to the already-instantiated Redmine CommonMark
   sanitizer allowlist for `span` elements.
4. Immediately before MathJax performs its initial page typeset, convert those
   semantic CommonMarker math spans back to the configured inline/block MathJax
   delimiters. Pages without those spans are left untouched.
5. Keep both configured delimiters and MathJax's `\(...\)` / `\[...\]`
   delimiters enabled.
6. Do not patch `ApplicationHelper#textilizable`, do not rewrite already-rendered
   escape spans, and do not replace Redmine preview templates.
7. Log the effective CommonMarker and sanitizer state at startup. A healthy load
   reports:

       [redmine_latex_mathjax] CommonMark math_dollars=true; sanitizer data-math-style=true

Other retained Redmine 7 changes
--------------------------------

- Redmine 7.0+ is required.
- The Propshaft-patched MathJax bundle is named `tex-chtml-propshaft.js`.
- `RAILS_ASSET_URL()` references are retained for MathJax WOFF font assets.
- Obsolete MathJax 2-style URL query parameters are not used.
- No database migration or additional Gem dependency is introduced.
- `MathJaxEmbedMacro.delimiterEndBlock` now reads the configured block end
  delimiter rather than the block start delimiter.

Third-party software
--------------------

Bundled MathJax remains version 3.0.5. Its Apache License 2.0 text is retained at
`assets/mathjax/LICENSE`; see `THIRD_PARTY_LICENSES.md` for the modification notice.
