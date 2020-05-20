# howdyadoc/pandoc-ref

Template repository for docx and odt reference (*i.e.* model) documents for pandoc for the howdyadoc workflow, intended to be used as a git sub-module in howdyadoc projects.

## 1. Rationale and repo structure

Git works much better with prettified XML files than with compressed files; for this reason:

  - reference documents are stored as uncompressed dirs within `src/` (containing   XML files - `.xml`, `.rdf`, `.rels` - and other possible source files)
  - XML source files are prettified with `xmllint`
  - reference document files within root dir are ignored via `.gitignore`

Uncompressed source dirs have the same name and extension of the reference document (e.g. `document.docx`)

## 2. Dependencies

`xmllint` (ubuntu package `libxml2-utils`), `zip`, `unzip`

## 3. Usage/Workflow

### 3.1 Create a new reference document:

1. Compile pandoc's base reference model, if you have not already done it: `make reference.docx` or `make reference.odt`

2. modify it with MS Word or Libreoffice

3. save it with a different name within root dir (e.g. `my-new-model.docx`)

4. decompile it with `make src/my-new-model.docx`

5. (optional) check the differences between pandoc's base reference document source and your new model's source, to check if some fixes are needed, and recompile the model document with `make my-new-model.docx`

### 3.2 Modify an existing reference document

1. Open the reference document file (e.g. `my-existsing-model.docx`) in Libreoffice or MS Word and modify it

2. After saving it, decompile it with `make src/my-existing-model.docx`

> **NOT RECOMMENDED**: You can just do `make sources` to decompile all models within root dir (**warning**: it will always decompile all models - overwriting the corresponding folders! - not only the new ones)

### 3.3 Use an existing reference document

To use an existing model (say, `my-existing-model.docx`), compile it with `make my-existing-model.docx`

> You can just do `make` (or `make models`) to compile all reference documents found in `src/` (**warning** it will overwrite the corresponding document models if they are older than source files).

## 4. Note on makefile targets

There is no default target in the Makefile, on purpose (so if you do just `make`, nothing happens). Since here 'make' is used both to compile and to decompile, there is the risk to inadvertently overwrite changes to compiled files you just made with Libreoffice / MS word etc.; so you have to explicitly declare which model file or source folder has to be
made via 'make':

- if you are willing to make sources from example.docx file you have just edited in Libreoffice: `make src/example.docx` 

- if you are willing to make the model file from sources: `make example.docx`

As explained above, you can also perform bulk actions, if you know what you are doing:

- 'make models' will compile all sources to model files, overwriting the existing ones if they are older than source files (you will lose any modifications made with Libreoffice/MS Word!)

- 'make sources' will decompile all model files to source directories, overwriting the existing ones

There is not even a 'clean' target in the Makefile, on purpose. Again, since 'make' is used both to compile and to decompile, there is the risk to inadvertently delete the wrong files or directories. Please manually delete what you want to delete.

## 5. Note on pandoc reference documents

Pandoc reference documents were extracted with `pandoc -o reference.docx --print-default-data-file reference.docx` and `pandoc -o reference.odt --print-default-data-file reference.odt` (pandoc version: 2.7.3)
