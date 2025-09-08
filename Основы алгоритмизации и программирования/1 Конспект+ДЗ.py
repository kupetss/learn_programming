# ЭТО ТЕЗИСНЫЙ КОНСПЕКТ.
# ЭТО НЕ ОБУЧЕНИЕ PYTHON, ЭТО ЧТО БЫ ВЫ ВСПОМНИЛИ СИНТАКСИС


# print("Hello")
# x = 1
# a, b, c = 1, 2, 3

# str1 = 'giga'
# str2 = "str2"
# str3 = """многострочные
#             строки"""
# f_str = f"переменная - {x}"

# #Коллекции
# #Списки
# my_lis = [1, 2, 3, "text"]
# my_lis.append(4)

# #кортежи
# my_tuple1 = (1, 2, 3)
# my_tuple2 = 1, 2, 3

# #Множества
# my_set = {1, 2, 3, 3}

# #Словари
# my_dict = {
#     'key1':'value1',
#     'key2':'value2'
# }

# List - упорядоченный, изменяемый, дубликаты разрешены
# Tuple - упорядоченный, НЕизменяемый, дубликаты разрешены  
# Set - НЕупорядоченный, изменяемый, только уникальные значения
# Dict - упорядоченный (с Python 3.7), изменяемый, ключи уникальные


# #Условные конструкции
# if x > 10:
#     print("Больше 10")
# elif x == 10:
#     print("Это 10")
# else:
#     print("Меньше 10")
#
# result = "да" if x == 10 else "нет"
#
# #Циклы
# #For
# for i in range(10):
#     print(i)
# for item in [1,2,3]:
#     print(item)
# for key, value in my_dict.items():
#     print(key, value)
#while
# g = 0
# while g < 5:
#     print(g)
#     g += 1
#Усправление циклами
# break - останавливает цикл
# continue - пропускает прокрут в цикле

#Функции
# def name(x, y):
#     return x + y
#
# print(name(5, 8))
# t = name(4, 3)
# print(t)


#1 Cумму чисел от 1 до N
# def sum_to_n(n):
#     result = 0
#     for j in range(1, n+1):
#         result += j
#     return result
#
# n = int(input())
# print(sum_to_n(n))

#2 Поиск максимального элемента в списке
# def find_max(lst):
#     return max(lst)
# print(find_max([1,3,2,5,4,7,6,9,8]))

#3 Подсчет гласных в строке
# def glass(str1):
#     count = 0
#     for a in str1:
#         if a == "а" or a == "о" or a == "е" or a == "и":
#             count += 1
#     return count


# Домашнее задание:
#4 Фильтрация четных чисел
#5 Проверка на палиндром

