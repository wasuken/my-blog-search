;; (in-package :cl-user)
(defpackage my-blog-search
  (:use :cl)
  (:export :blog-aggregate :article-href-in-html-source
           :html-source))
