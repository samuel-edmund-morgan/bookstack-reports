SELECT
users.name as 'User name',
users.email as 'User email',
CONCAT(IFNULL(books.name, ''), IFNULL(pages.name, ''), IFNULL(chapters.name, ''), IFNULL(bookshelves.name, ''))
    as 'Resource Name',
views.viewable_type 'Resource type',
views.views as 'View count',
views.updated_at as 'Last visited'
FROM views
LEFT JOIN users on views.user_id = users.id
LEFT JOIN books on books.id = views.viewable_id and views.viewable_type = 'book'
LEFT JOIN pages on pages.id = views.viewable_id and views.viewable_type = 'page'
LEFT JOIN chapters on chapters.id = views.viewable_id and views.viewable_type = 'chapter'
LEFT JOIN bookshelves on bookshelves.id = views.viewable_id and views.viewable_type = 'bookshelf'
WHERE views.updated_at > DATE_SUB(NOW(), INTERVAL 24 HOUR)
ORDER BY views.updated_at DESC;