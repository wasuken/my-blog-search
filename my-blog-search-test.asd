;; (require \'asdf)
 
 (in-package :cl-user)
 (defpackage my-blog-search-test-asd
 (:use :cl :asdf))
 (in-package :my-blog-search-test-asd)
 
 (defsystem my-blog-search-test
 :depends-on (:my-blog-search)
 :version "1.0.0"
 :author "wasu"
 :license "MIT"
 :components ((:module "t" :components ((:file "my-blog-search-test"))))
 :perform (test-op :after (op c)
 (funcall (intern #.(string :run) :prove) c)))

