# GoldenSewing
### App to show very interesting sewing products!

<p align="justify">
Данное приложение является одним из решений продемонстрировать навыки, полученные в процессе обучения iOS разработки в течении почти 2-х лет. Основной задачей для меня было реализовать основные знания по: 

  * работе с сервером (получение и парсинг данных, работа c NSURLSession), 
  * обработка данных и хранение их для оффлайн просмотра в CoreData, 
  * обработка запросов пользователя в рамках приложения (сортировка и выборка данных из CorData), 
  * работа с переходами по экранам приложения, анимация и компоновка основных элементов (UIKit), применение паттерну MVC при разработке архитектуры приложения.

На протяжении написания всего приложения я старался придерживаться нативных библиотек от «Apple» и не использовать сторонних фреймворков (кроме раскрывающихся ячеек, - уж очень понравилась реализация).
</p>

<p align="justify">
Основной функционал приложения: пользователю предлагается приложение, являющееся, копией существующего сайта предприятия «Золотое шитье» www.zolotoe-shitvo.kr.ua. С той лишь разницей, что приложение позволяет хранить оффлайн версию контента, помечать просмотренные продукты собственным рейтингом и использовать историю просмотренных товаров.
При входе, пользователю предлагается список категорий на выбор, при выборе категории, открывается экран со списком товаров из данной категории. По выбору ячейки товара, ячейка раскрывается, предоставляя пользователю детальное описание и фотографию изделия. При повторном нажатии на описание, ячейка свернется в прежнюю форму, при нажатии на фотографию, совершится модальный показ нового экрана с полноразмерным представлением товара, полем для выбора оценки товара и возможностью отправить запрос (по почте) или связаться (телефонным звонком) для заказа данного товара. Поле самой фотографии предполагает использование жеста «увеличение/уменьшение», для лучшего отображения всех деталей изделия на фото. При нажатии на поле вне фотографии, экран вернется к списку товаров. 
Также, в приложении работает поиск. При открытой определенной категории, поиск совершается по всем товарам в данной категории. Если поиск совершается вне какой-либо категории (на экране списка категорий), то поиск будет делаться по всем товарам, представленным в базе данных.
Нижнее меню (UITabBarController) имеет 4 кнопки: «Категории», «О нас», «Контакты» и «Избранное». При нажатии на «Категории», открывается экран со списком категорий, или (если было открыто), выбранная категория. «О нас» - описание деятельности предприятия. «Контакты» - данные для связи и карта для просмотра местоположения. Если нажать на карту, то откроется приложение «Карты» с предложением проложить маршрут к зданию предприятия. «Избранное» хранит в себе 2 секции таблицы: 1 секции показывает все товары, которые были отмечены «звездочкой» (поставлен какой-либо рейтинг), вторая секция отображает историю просмотров, при чем, если просмотр был совершен в течении сегодняшнего или вчерашнего дня, формат времени меняется вместо «07 сентября в 21:08» показывается «сегодня в 21:08».
</p>
