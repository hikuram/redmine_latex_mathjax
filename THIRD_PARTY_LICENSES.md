# Third-party software

## MathJax 3.0.5

This plugin bundles MathJax 3.0.5.

- Project: MathJax
- Copyright: The MathJax Consortium
- License: Apache License, Version 2.0
- License text: `assets/mathjax/LICENSE`

The file `assets/mathjax/es5/tex-chtml-propshaft.js` is a modified form of the
MathJax 3.0.5 `tex-chtml.js` component. Its CHTML font URLs were changed to use
Rails `RAILS_ASSET_URL()` calls so that Redmine 6/7 Propshaft can resolve
digested plugin font assets. No change is made to MathJax's license.

The bundled MathJax 3.0.5 package does not contain a `NOTICE` file, so there is
no upstream NOTICE text to reproduce.
