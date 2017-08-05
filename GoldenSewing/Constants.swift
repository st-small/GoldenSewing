//
//  Constants.swift
//  GoldenSewing
//
//  Created by Stanly Shiyanovskiy on 01.08.17.
//  Copyright © 2017 Stanly Shiyanovskiy. All rights reserved.
//

import UIKit

class Constants {

enum Category: Int {
    case ikonostasy = 3             // 9 posts
    case ikony = 4                  // 144 posts
    case komplektySborkiMitr = 5    // 49 posts
    case metallonit = 101           // 78 posts
    case mitres = 6                 // 155 posts
    case oblArch = 7                // 27 posts
    case oblDiak = 8                // 14 posts
    case oblIer = 9                 // 28 posts
    case plaschanicy = 10           // 14 posts
    case pokrovcy = 11              // 20 posts
    case raznoe = 1                 // 1 collection
    case skrizhali = 13             // 21 posts
    case tkani = 103                // 15 posts
}

// default_name
enum AttributesEnum: String {
    case cloth = "Ткань"
    case product = "Способ изготовления"
    case inlay = "Инкрустация"
    case arbitrary = "Произвольно"
    case img = "Рисунок"
    case clr = "Цвет"
    case wdth = "Ширина"
}

// default_value_cloth
    static let clothDict = ["cloth_1" : "Атлас", "cloth_2" : "Атлас на натуральной основе",
                            "cloth_3" : "Велюр", "cloth_4" : "Габардин",
                            "cloth_5" : "Греческая тисненная парча", "cloth_6" : "Греческий галун",
                            "cloth_7" : "Лен", "cloth_8" : "Муар",
                            "cloth_9" : "Органза", "cloth_10": "Парча",
                            "cloth_11": "Ткань заказчика", "cloth_12" : "Х/б бархат",
                            "cloth_13" : "Хлопок", "cloth_14" : "Церковный жаккард", "cloth_15" : "Шелк"]

// default_value_product
    static let methodValDict = ["product_1" : "Гладь по настилу", "product_2" : "Золотая и серебряная канитель",
                                "product_3" : "Золотая и цветная канитель", "product_4" : "Золотая канитель",
                                "product_5" : "Золотая, серебряная и цветная канитель", "product_6" : "Машинная вышивка",
                                "product_7" : "Метанит", "product_8" : "Ручная инкрустация канителью",
                                "product_9" : "Ручное шитье", "product_10": "Серебряная канитель",
                                "product_12": "Трунцал", "product_13": "Цветной метатнит", "product_14": "Шелк"]

// default_value_inlay
    
    static let inlayDict = ["inlay_1" : "Агат", "inlay_2" : "Аметист",
                            "inlay_3" : "Аметисты граненные в оправе", "inlay_4" : "Аметисты шлифованные",
                            "inlay_5" : "Берилл", "inlay_6" : "Бирюза",
                            "inlay_7" : "Бисер", "inlay_8" : "Горный хрусталь",
                            "inlay_9" : "Гранат", "inlay_10": "Гранаты граненные в оправе",
                            "inlay_11": "Гранаты шлифованные в оправе", "inlay_12": "Жемчуг",
                            "inlay_13": "Кораллы", "inlay_14": "Лабрадор",
                            "inlay_15": "Лазурит", "inlay_16": "Малахит",
                            "inlay_17": "Нефрит", "inlay_17_1": "Изумруд",
                            "inlay_18": "Оливин", "inlay_19": "Оникс",
                            "inlay_20": "Родонит", "inlay_21": "Рубин",
                            "inlay_21_1": "Селенит", "inlay_22": "Сердолик",
                            "inlay_23": "Серпантинит", "inlay_24": "Стразы «Сваровски»",
                            "inlay_25": "Топаз", "inlay_26": "Топазы в серебряной оправе",
                            "inlay_27": "Турмалин", "inlay_28": "Хризолит",
                            "inlay_29": "Хризопразы", "inlay_30" : "Цирконий",
                            "inlay_31": "Цирконий в серебряной оправе", "inlay_32" : "Цитрин",
                            "inlay_33": "Черный кварц", "inlay_34" : "Яшма",
                            "elements_1": "Кант – голубая норка", "elements_2": "Кант – норка",
                            "elements_3": "Кант – ручная вязка метанитом", "elements_4": "Крест ювелирной работы («Золотое шитье»)",
                            "elements_5": "Крест ювелирной работы («Софрино»)", "icon_1" : "Живопись темперой",
                            "icon_2" : "Иконы - вышивка золотым, серебряным и цветным метанитом",
                            "icon_3" : "Иконы - вышивка канителью",
                            "icon_4" : "Иконы - живопись по латуни",
                            "icon_5" : "Иконы - золотой и серебряный метанит",
                            "icon_6" : "Иконы - лаковая миниатюра",
                            "icon_7" : "Иконы - лаковая миниатюра по дереву («Золотое шитье»)",
                            "icon_8" : "Иконы - литография",
                            "icon_9" : "Иконы - полимерная литография",
                            "icon_10": "Иконы - ювелирные рамки, латунь, золочение",
                            "icon_11": "Иконы - ювелирные рамки, латунь, серебрение",
                            "icon_12": "Иконы предоставлены заказчиком",
                            "icon_13": "Лаковая миниатюра, лазерное напыление"]

// default_value_color
enum ColorVal: String {
    case color_1 = "Белый"
    case color_2 = "Белый + золото"
    case color_3 = "Белый + серебро"
    case color_3_1 = "Бежевый"
    case color_3_2 = "Бежевый + золото"
    case color_3_3 = "Бежевый + серебро"
    case color_4 = "Бордо"
    case color_5 = "Бордо + золото"
    case color_6 = "Бордо + серебро"
    case color_6_1 = "Вишневый"
    case color_6_2 = "Вишневый + золото"
    case color_6_3 = "Вишневый + серебро"
    case color_7 = "Голубой"
    case color_8 = "Голубой + золото"
    case color_9 = "Голубой + серебро"
    case color_10 = "Желтый"
    case color_10_1 = "Желтый + золото"
    case color_10_2 = "Желтый + серебро"
    case color_10_3 = "Желтый + золото + горчица"
    case color_11 = "Зеленый"
    case color_12 = "Зеленый + золото"
    case color_13 = "Зеленый + серебро"
    case color_14 = "Красный"
    case color_15 = "Красный + золото"
    case color_16 = "Красный + серебро"
    case color_17 = "Фиолетовый"
    case color_18 = "Фиолетовый + золото"
    case color_19 = "Фиолетовый + серебро"
    case color_20 = "Черный"
    case color_21 = "Черный + золото"
    case color_22 = "Черный + серебро"
}


    
}
