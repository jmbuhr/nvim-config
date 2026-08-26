(pandoc_code_block
  (attribute_specifier
    (language_specifier) @injection.language)
  (code_fence_content) @injection.content)

(pandoc_code_block
  (info_string) @injection.language
  (code_fence_content) @injection.content)

(pandoc_code_block
  (attribute_specifier
    (raw_specifier) @injection.language
    (#offset! @injection.language 0 1)
  )
(code_fence_content) @injection.content)

(document (metadata)@injection.content (#set! injection.language "yaml"))
