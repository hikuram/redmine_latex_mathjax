Redmine 7 adaptation notes
==========================

Base
----

This package was adapted from the supplied `redmine6` branch/archive.
The goal was to keep the existing Propshaft/MathJax font-path fix while removing obsolete
preview integration that no longer matches Redmine 7.

Changes
-------

1. Require Redmine 7.0 or later.
2. Rename the Propshaft-patched MathJax bundle from:

       tex-chtml-redmine6.js

   to:

       tex-chtml-propshaft.js

   No vendor-code logic was otherwise changed in that bundle.
3. Keep `RAILS_ASSET_URL()` references for MathJax WOFF font assets.
4. Remove the plugin override of `app/views/common/_preview.html.erb`.
   Redmine 7's core preview partial is now used unchanged.
5. Remove the obsolete `MJsubmitPreview()` implementation and DOM rewriting of
   `onclick="submitPreview(...)"` links.
6. Add a Redmine 7 preview hook based on the current `.tab-preview` / `.wiki-preview`
   AJAX flow:
   - clear the old preview from MathJax's internal document before replacement;
   - observe the preview container for Redmine's AJAX content replacement;
   - run `MathJax.typesetPromise([preview])` after the replacement;
   - fall back to `MathJax.typeset([preview])` if needed.
7. Remove obsolete MathJax 2-style query parameters from the MathJax script URL.
8. Update README instructions for Redmine 7. No `bundle install --without ...` step is required
   by this plugin because it adds no Gem dependencies.

Intentionally unchanged
-----------------------

- Bundled MathJax version remains 3.0.5.
- The `mj` macro behavior is unchanged.
- Math delimiters remain configurable in the plugin settings.
- No database migration was added.
