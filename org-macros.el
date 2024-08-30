;;; org-texinfo--quoted-keys-regexp

;; We cannot use `org-texinfo--quoted-keys-regexp' because that isn't
;; available in the old Emacs release used on the server used to build
;; the packages published on [Non]GNU ELPA.

;; This is the implementation I added to Org in 2022, which was first
;; releases in Org 9.6 (part of Emacs 29.1).  As of 2024-08-12 it is
;; still unchanged.

(defvar org-texinfo--quoted-keys-regexp
  (regexp-opt '("BS" "TAB" "RET" "ESC" "SPC" "DEL"
		"LFD" "DELETE" "SHIFT" "Ctrl" "Meta" "Alt"
		"Cmd" "Super" "UP" "LEFT" "RIGHT" "DOWN")
	      'words)
  "Regexp matching keys that have to be quoted using @key{KEY}.")

(regexp-opt '("BS" "TAB" "RET" "ESC" "SPC" "DEL" "LFD" "DELETE" "SHIFT" "Ctrl" "Meta" "Alt" "Cmd" "Super" "UP" "LEFT" "RIGHT" "DOWN") 'words)
"\\<\\(Alt\\|BS\\|C\\(?:md\\|trl\\)\\|D\\(?:EL\\(?:ETE\\)?\\|OWN\\)\\|ESC\\|L\\(?:EFT\\|FD\\)\\|Meta\\|R\\(?:\\(?:E\\|IGH\\)T\\)\\|S\\(?:HIFT\\|PC\\|uper\\)\\|TAB\\|UP\\)\\>"

;;; Utilities

(defun org-macro-as-kill ()
  "Copy the macro from the current section to the kill-ring.
Put the whole form on a single line and add the macro property.
Point must be at the beginning of the section."
  (interactive)
  (if (looking-at "^;;; {{{\\([^}]+\\)}}}")
      (kill-new
       (format "#+macro: %s %S"
               (match-string 1)
               (list 'eval (save-excursion (read (current-buffer))))))
    (user-error "Not looking at ;;; {{{...}}}")))

;;; {{{year}}}

(format-time-string "%Y")

;;; {{{version}}} --- unused

;; We won't be able to use this until the various package managers and
;; package archives support generating texi files from org files, i.e.,
;; probably never.  Until then the version string is hard-coded and only
;; gets updated on releases by `sisyphus--bump-version-org'. This macro
;; is present in the various ".orgconfig" files, but it is unused.

(if-let ((tag (ignore-errors
                (car (process-lines "git" "describe" "--exact-match")))))
    (concat "version " (substring tag 1))
  (or (ignore-errors (car (process-lines "git" "describe")))
      (concat "version " (or $1 "<unknown>"))))

;;; {{{kbd}}}

(format "@@texinfo:@kbd{@@%s@@texinfo:}@@"
        (let (case-fold-search)
          (replace-regexp-in-string
           (regexp-opt '("BS" "TAB" "RET" "ESC" "SPC" "DEL"
		         "LFD" "DELETE" "SHIFT" "Ctrl" "Meta" "Alt"
		         "Cmd" "Super" "UP" "LEFT" "RIGHT" "DOWN")
                       'words)
           "@@texinfo:@key{@@\\&@@texinfo:}@@" $1 t)))

;;; {{{kbdvar}}}

(format "@@texinfo:@kbd{@@%s@@texinfo:}@@"
        (let (case-fold-search)
          (replace-regexp-in-string
           "<\\([a-zA-Z-]+\\)>"
           "@@texinfo:@var{@@\\1@@texinfo:}@@"
           (replace-regexp-in-string
            (regexp-opt '("BS" "TAB" "RET" "ESC" "SPC" "DEL"
		          "LFD" "DELETE" "SHIFT" "Ctrl" "Meta" "Alt"
		          "Cmd" "Super" "UP" "LEFT" "RIGHT" "DOWN")
	                'words)
            "@@texinfo:@key{@@\\&@@texinfo:}@@" $1 t)
           t)))

;;; {{{codevar}}}

(format "@@texinfo:@code{@@%s@@texinfo:}@@"
        (let (case-fold-search)
          (replace-regexp-in-string
           "\\([A-Z][A-Z-]+\\)"
           "@@texinfo:@var{@@\\&@@texinfo:}@@" $1 t)))

;;; {{{var}}}

#+macro: var @@texinfo:@var{@@$1@@texinfo:}@@

;;; {{{dfn}}}

#+macro: dfn @@texinfo:@dfn{@@$1@@texinfo:}@@
