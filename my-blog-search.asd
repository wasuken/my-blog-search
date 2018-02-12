;; (require \'asdf)
 
 (in-package :cl-user)
 (defpackage my-blog-search-asd
 (:use :cl :asdf))
 (in-package :my-blog-search-asd)
 
 (defsystem :my-blog-search
 :version "1.0.0"
 :author "wasu"
 :license "MIT"
 :components ((:file "package")
 (:module "src" :components ((:file "my-blog-search")))))

