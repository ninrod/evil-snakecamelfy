;;; evil-snakecamelfy.el --- toggle CamelCase to snake_case and vice-versa -*- lexical-binding: t -*-

;; Copyright (C) 2015 by Filipe Silva (ninrod)

;; Author: Filipe Silva <filipe.silva@gmail.com>
;; URL: https://github.com/ninrod/evil-snakecamelfy
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

;;; Settings:

(require 'evil)
(require 'string-inflection)

(defgroup evil-snakecamelfy nil
  "Provide a toggle operator to transform CamelCase words to snake_case and vice-versa."
  :group 'evil-snakecamelfy
  :prefix 'evil-snakecamelfy-)

;;; common functions

(defun evil-snakecamelfy--has-pattern (beg end pattern)
  "In string from BEG to END match PATTERN."
  (let ((str (buffer-substring-no-properties beg end)))
    (string-match-p pattern str)))

(defun evil-snakecamelfy--is-camelcased (beg end)
  "Verify if string between BEG and END is in camelcase form."
  ;; https://stackoverflow.com/questions/2129840/check-if-a-string-is-all-caps-in-emacs-lisp
  (evil-snakecamelfy--has-pattern beg end "\\`[A-Z]*\\'"))

(defun evil-snakecamelfy--is-snakecased (beg end)
  "Verify if string between BEG and END is in snakecase form."
  (evil-snakecamelfy--has-pattern beg end "_"))

;;; snakefy core functions

(defun evil-snakecamelfy--upper-letter-to-snake (&optional underscore)
  "Invert case and apply underscore if applicable.
If UNDERSCORE is not nil, applies underscore. If it's nil, then it does not insert underscore."
  (let ((case-fold-search nil))
    (cond ((looking-at "[[:upper:]]")
           (evil-invert-case (point) (1+ (point)))
           (when underscore
             (save-excursion
               (insert "_")
               1)))
          (t
           nil))))

(defun evil-snakecamelfy--snakefy (beg end)
  "Snakefy string from BEG to END."
  (let ((finish end))
    (save-excursion
      (goto-char beg)
      (while (< (point) finish)
        (cond ((evil-snakecamelfy--upper-letter-to-snake (not (= (point) beg)))
               (setq finish (1+ finish))))
        (forward-char)))))

;;; camelfy core functions

(defun evil-snakecamelfy--upcasify-point ()
  "Upcasify point, if applicable."
  (when (looking-at "[[:lower:]]")
    (upcase-region (point) (1+ (point)))))

(defun evil-snakecamelfy--camelfy (beg end)
  "Camelfy from BEG to END."
  (let ((finish end))
    (save-excursion
      (goto-char beg)
      (evil-snakecamelfy--upcasify-point)
      (forward-char)
      (while (< (point) finish)
        (cond ((looking-at "_")
               (delete-char 1)
               (setq finish (1- finish))
               (evil-snakecamelfy--upcasify-point)))
        (forward-char)))))

;;; Connect to Evil machinery

(evil-define-operator evil-operator-snakecamelfy (beg end _type)
  "Define a new evil operator that toggles snake to camel and vice-versa."
  :move-point nil
  (interactive "<R>")
  (cond ((evil-snakecamelfy--is-camelcased beg end)
         (evil-snakecamelfy--snakefy beg end))
        ((evil-snakecamelfy--is-snakecased beg end)
         (evil-snakecamelfy--camelfy beg end))
        (t
         nil)))

(define-key evil-normal-state-map (kbd "g~") 'evil-operator-snakecamelfy)

(provide 'evil-snakecamelfy)

;;; evil-snakecamelfy.el ends here