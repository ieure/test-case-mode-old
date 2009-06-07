
;; phpunit ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defcustom test-case-phpunit-executable (executable-find "phpunit")
  "The phpunit executable used to run PHPUnit tests."
  :group 'test-case
  :type 'file)

(defcustom test-case-phpunit-arguments ""
  "The command line arguments used to run PHPUnit tests."
  :group 'test-case
  :type 'string)

(defconst test-case-phpunit-failure-pattern
  '("^[0-9]+)\s+\\(.*\\)\n\\(Failed.*\\)\n\\([^:]+\\):\\([0-9]+\\)"
    3 4 nil 2 0))

(defconst test-case-phpunit-test-pattern
  "\\<extends\\>.*Tests?_?\\(Case\\|Suite\\)?")

(defconst test-case-phpunit-font-lock-keywords
  '("\\<$this->assert[^\s(]+\\>"
    (0 'test-case-assertion prepend)))

(defun test-case-phpunit-find-test-class ()
  (test-case-grep "class\s+\\([^\s]*Test[^\s]*\\)"))

(defun test-case-phpunit-backend (command)
  "PHPUnit back-end for `test-case-mode'."
  (case command
    ('name "PHPUnit")
    ('supported (and (derived-mode-p 'php-mode)
                     (test-case-grep test-case-phpunit-test-pattern)
                     t))
    ('command (mapconcat 'identity 
                         (list test-case-phpunit-executable
                               (test-case-phpunit-find-test-class)
                               buffer-file-name)
                         " "))
    ('save t)
    ('failure-pattern test-case-phpunit-failure-pattern)
    ('font-lock-keywords test-case-phpunit-font-lock-keywords)))

(add-to-list 'test-case-backends 'test-case-phpunit-backend)

