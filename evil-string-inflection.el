;;; evil-string-inflection.el ---  underscore -> UPCASE -> CamelCase conversion of evil text objects -*- lexical-binding: t -*-

;; Copyright (C) 2015 by Filipe Silva (ninrod)

;; Author: Filipe Silva <filipe.silva@gmail.com>
;; URL: https://github.com/ninrod/evil-string-inflection
;; Version: 0.0.1
;; Package-Requires: ((emacs "24") (evil "1.2.13") (string-inflection "1.0.6"))

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <http://www.gnu.org/licenses/>.

;;; Commentary:

;; This package provides an evil operator to tranform CamelCase words into snake_case.

;;; Code:

(require 'evil)
(require 'string-inflection)

(evil-define-operator evil-operator-snakecamelfy (beg end _type)
  "Define a new evil operator that cicles underscore -> UPCASE -> CamelCase."
  :move-point nil
  (interactive "<R>")
  (let ((str (buffer-substring-no-properties beg end)))
    (save-excursion
      (delete-region beg end)
      (insert (string-inflection-all-cycle-function str)))))

(define-key evil-normal-state-map (kbd "g~") 'evil-operator-snakecamelfy)

(provide 'evil-string-inflection)

;;; evil-string-inflection.el ends here
