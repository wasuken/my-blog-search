(in-package #:my-blog-search)

(defun take (lst num)
  (subseq lst 0 (min num (length lst))))

;;; 集計。関数化する必要あったのか。
(defun blog-easy-aggregate (word-min-length blog-all-content-lists)
  (let* ((all-words (reduce #'append (mapcar #'igo:wakati blog-all-content-lists)))
         (all-words-uniq (remove-if-not #'(lambda (x) (and (stringp x) (> (length x) word-min-length))) (remove-duplicates all-words :test #'string=)))
         (words-aggregate-lst (sort (mapcar #'(lambda (x) (cons x (count x all-words :test #'string=))) all-words-uniq) #'> :key #'cdr)))
    (sort words-aggregate-lst #'> :key #'cdr)))
