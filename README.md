# howdyadoc reference documents

Repository for docx and odt reference (*i.e.* model) documents for pandoc for the howdyadoc workflow, intended to be used as a git sub-module in howdyadoc projects.

Since git works much better with prettified XML files than with compressed files:

  - Reference documents are stored as uncompressed dirs within `src/` (containing   XML files - `.xml`, `.rdf`, `.rels` - and other possible source files)
  - XML source files are prettified with `xmllint`
  - reference document files within root dir are ignored via `.gitignore`

Uncompressed source dirs have the same name and extension of the reference document (e.g. `document.docx`)

## Dependencies

`xmllint` (ubuntu package `libxml2-utils`), `zip`, `unzip`

## Usage/Workflow

A) To create a new model:

  1. Compile pandoc's base reference model, if you have not already done it: `make reference.docx` or `make reference.odt`

  2. modify it with MS Word or Libreoffice

  3. save it with a different name within root dir (e.g. `my-new-model.docx`)

  4. decompile it with `make src/my-new-model.docx`

  5. (optional) check the differences between pandoc's base reference document source and your new model's source, to check if some fixes are needed, and recompile the model document with `make my-new-model.docx`

B) You can just do `make sources` to decompile all models within root dir (**warning**: it will always decompile all models - overwriting the corresponding folders! - not only the new ones)

C) To use an existing model (say, `my-new-model.docx`), compile it with `make my-new-model.docx`

D) You can just do `make` (or `make models`) to compile all sources (**warning** it will overwrite the corresponding document models if they are older than source files).

### Note on pandoc reference documents

Pandoc reference documents can be extracted with `pandoc -o reference.docx --print-default-data-file reference.docx` and `pandoc -o reference.odt --print-default-data-file reference.odt`
