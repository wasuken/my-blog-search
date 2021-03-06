(in-package :cl-user)
(defpackage my-blog-source-convs
  (:use :cl :prove :my-blog-search))
(in-package #:my-blog-source-convs)

;;; 分離する意味あまりないかもしれない
;;; やっぱりデフォルトでSleep入れる
(defun html-source (url &optional (sleep-sec 3))
  (cond (url
         (sleep sleep-sec)
         (plump:parse (dex:get url)))))

;;; sourceからtag-strと一致するnodeを取得し、nodeのattr-nameの値を取得する。
(defun attr-value-in-html-source (tag-str attr-name source)
  (mapcar #'(lambda (x) (plump:attribute x attr-name))
          (coerce (clss:select tag-str source) 'list)))

;;; アーカイブ内のリンクを拾ってくる
(defun article-href-in-html-source (source)
  (attr-value-in-html-source "a.entry-title-link" "href" source))

;;; 次のページが存在するか
;;; 存在したならURL文字列を返す。
(defun next-page-link (source)
  (let ((next-page-span (clss:select "span.pager-next a" source)))
    (if (> (length next-page-span) 0)
        (plump:attribute (aref next-page-span 0) "href"))))

(defun all-link-in-hatena-archive-page (source &optional (sleep-sec 1))
  (let ((links '()))
    (labels ((f (src)
               (cond (src (setf links (append links (article-href-in-html-source src)))
                          (sleep sleep-sec)
                          (f (html-source (next-page-link src)))))))
      (f source))
    links))

;;; 非常に危険な関数なので取り扱いには気をつける。
(defun all-page-content (source &optional (sleep-sec 3))
  (let* ((blog-all-links (all-link-in-hatena-archive-page
                          source sleep-sec))
         (blog-all-html-sources (mapcar #'html-source blog-all-links)))
    (mapcar #'(lambda (x) (plump:text
                           (aref (clss:select "div.entry-content" x) 0)))
            blog-all-html-sources)))


;;; 記事ページから指定したタグ内のテキストを取得する(空白及び改行削除)
(defun get-first-item-text-in-page (tag-name page)
  (string-trim '(#\Space #\Newline)
               (plump:text (aref (clss:select tag-name
                                              page)
                                 0))))
;;; 記事URLから指定したタグ内のテキストを取得する(空白及び改行削除)
;;; get-first-item-text-in-pageをラッピングしただけ。
(defun get-first-item-text-from-url (tag-name page-url)
  (get-first-item-text-in-page tag-name (html-source page-url)))
