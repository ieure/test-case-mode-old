;; test-case-phpunit.el --- PHPUnit support for test-case-mode
;;
;; Copyright (C) 2009 Ian Eure
;;
;; Author: Ian Eure <ian.eure@gmail.com>
;; Version: 1.0
;; Keywoards: testing
;; URL: http://github.com/ieure/test-case-mode
;; Compatibility: GNU Emacs 22.x, GNU Emacs 23.x
;; Package-Requires: ((fringe-helper "0.1.1") (test-case-mode "0.1"))
;;
;; This file is NOT part of GNU Emacs.
;;
;; This program is free software; you can redistribute it and/or
;; modify it under the terms of the GNU General Public License
;; as published by the Free Software Foundation; either version 2
;; of the License, or (at your option) any later version.
;;
;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.
;;
;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <http://www.gnu.org/licenses/>
;;
;; Commentary:
;;
;; `test-case-phpunit' adds PHPUnit support to test-case-mode.
;;
;; Installation:
;;
;; Place in your `load-path', then:
;; (require 'test-case-phpunit)

(require 'test-case-mode)

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
    3 4 nil 2 0)
  "Regular expression for matchin PHPUnit failute output.")

(defconst test-case-phpunit-test-pattern
  "\\<extends\\>.*Tests?_?\\(Case\\|Suite\\)?"
  "Regular expression for locating classes which extend PHPUnit.")

(defconst test-case-phpunit-font-lock-keywords
  '("\\<$this->assert[^\s(]+\\>"
    (0 'test-case-assertion prepend))
  "Regular expression for PHPUnit assertions.")

(defconst test-case-phpunit-class-pattern
  "class\s+\\([^\s]*Test[^\s]*\\)"
  "Regular expression for matchin PHPUnit test class names.")

(defun test-case-phpunit-find-test-class ()
  "Determine the name of the test class"
  (test-case-grep test-case-phpunit-class-pattern))

(defun test-case-phpunit-backend (command)
  "PHPUnit back-end for `test-case-mode'."
  (case command
    ('name "PHPUnit")
    ('supported (and (derived-mode-p 'php-mode)
                     (test-case-grep test-case-phpunit-test-pattern)
                     t))
    ('command (format "%s %s %s %s" test-case-phpunit-executable
                      test-case-phpunit-arguments
                      (test-case-phpunit-find-test-class)
                      buffer-file-name))
    ('save t)
    ('failure-pattern test-case-phpunit-failure-pattern)
    ('font-lock-keywords test-case-phpunit-font-lock-keywords)))

(add-to-list 'test-case-backends 'test-case-phpunit-backend)

(provide 'test-case-phpunit)
