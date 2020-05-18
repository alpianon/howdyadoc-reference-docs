# howdyadoc reference documents

Repository for docx and odt reference (*i.e.* model) documents for pandoc for the howdyadoc workflow, intended to be used as a git sub-module in howdyadoc projects.

Reference documents are stored as uncompressed dirs within `src/` (containing   XML files - `.xml`, `.rdf`, `.rels` - and other possible source files) because git works much better with xml files. XML source files are prettified with `xmllint` for the same reason. And reference document files within `build/` are ignored via `.gitignore`, again for the same reason.

Uncompressed source dirs have the same name and extension of the reference document (e.g. `document.docx`)

## Dependencies

`xmllint` (ubuntu package `libxml2-utils`), `zip`, `unzip`

## Usage/Workflow

A) To create a new model:

  1. Compile pandoc's base reference model, if you have not already done it: `make build/reference.docx` or `make build/reference.odt`

  2. modify it with MS Word or Libreoffice

  3. save it with a different name within `build/` (e.g. `build/my-new-model.docx`)

  4. decompile it with `make src/my-new-model.docx`

  5. (optional) check the differences between pandoc's base reference document source and your new model's source, to check if some manual fix is needed

B) You can just do `make sources` to decompile all models within `build/`(**warning**: if will always decompile all models - overwriting the corresponding folders! - not only the new ones)

C) To use an existing model (say, `my-new-model.docx`), compile it with `make build/my-new-model.docx`

D) You can just do `make` (or `make models`) to compile all sources (**warning** it will overwrite the corresponding document models).

### Note on pandoc reference documents

Pandoc reference documents can be extracted with `pandoc -o reference.docx --print-default-data-file reference.docx` and `pandoc -o reference.odt --print-default-data-file reference.odt`
