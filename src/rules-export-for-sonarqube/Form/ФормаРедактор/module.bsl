﻿
Перем ОценкаПравил;
Перем СимволовВОкончанииHTMLОписания;

#Область ОбработчикиСобытийФормы

Процедура ПриОткрытии()
	
	ПрочитатьПравила();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

Процедура ПутьКФайлуВыгрузкиНачалоВыбора(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Диалог = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.Сохранение);
	Диалог.Заголовок          = НСтр("ru='Выберите файл json для сохранения'");
	Диалог.МножественныйВыбор = Ложь;
	
	Если ЗначениеЗаполнено(ПутьКФайлуВыгрузки) Тогда
		
		Диалог.ПолноеИмяФайла = ПутьКФайлуВыгрузки;
		
	Иначе
		
		Диалог.ПолноеИмяФайла = "accRules.json";
		
	КонецЕсли;
	
	Диалог.Фильтр = "JSON (*.json)|*.json";
	
	Если Диалог.Выбрать() Тогда
		
		ПутьКФайлуВыгрузки = Диалог.ПолноеИмяФайла;
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ФайлКлассификацииОшибокНачалоВыбора(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Диалог = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.Открытие);
	Диалог.Заголовок = "Укажите файл классификации ошибок";
	Диалог.Фильтр    = "Текстовый документ(*.csv)|*.csv";
	
	Если Диалог.Выбрать() Тогда
		
		ФайлКлассификацииОшибок = Диалог.ПолноеИмяФайла;
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ФайлКлассификацииОшибокОткрытие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Если ЗначениеЗаполнено(ФайлКлассификацииОшибок) Тогда
		
		ЗапуститьПриложение(ФайлКлассификацииОшибок);
		
	КонецЕсли;

КонецПроцедуры

Процедура НастройкиSTEBIНачалоВыбора(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Диалог = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.Открытие);
	Диалог.Заголовок      = "Укажите файл настроек";
	Диалог.Фильтр         = "JSON (*.json)|*.json";
	Диалог.ПолноеИмяФайла = НастройкиSTEBI;
	
	Если Диалог.Выбрать() Тогда
		
		НастройкиSTEBI = Диалог.ПолноеИмяФайла;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

Процедура КнопкаВыполнитьНажатие(Кнопка)
	
	ПрочитатьПравила();
	
КонецПроцедуры

Процедура ОсновныеДействияФормыВыгрузитьВJSON(Кнопка)
	
	ЗаписьJSON = Новый ЗаписьJSON();
	ЗаписьJSON.ОткрытьФайл(ПутьКФайлуВыгрузки);
	ЗаписатьJSON(ЗаписьJSON, ДанныеДляЗаписи());
	ЗаписьJSON.Закрыть();
	
КонецПроцедуры

Процедура ПрименитьФайлКлассификацииНажатие(Элемент)

	Если Не ЗначениеЗаполнено(ФайлКлассификацииОшибок) Тогда
		Возврат;
	КонецЕсли;
	
	строкИзменено = 0;
	
	ЧтениеФайлаКлассификации = Новый ТекстовыйДокумент;
	ЧтениеФайлаКлассификации.Прочитать(ФайлКлассификацииОшибок, КодировкаТекста.ANSI);
	
	отЧисло = Новый ОписаниеТипов("Число", Новый КвалификаторыЧисла(10, 0, ДопустимыйЗнак.Неотрицательный));
	
	Для Сч = 1 По ЧтениеФайлаКлассификации.КоличествоСтрок() Цикл
		
		ТекСтрока = ЧтениеФайлаКлассификации.ПолучитьСтроку(Сч);
		Значения = СтрРазделить(ТекСтрока, ";");
		
		Серьезность = Значения[0];
		Тип = Значения[1];
		ЗатрачиваемыеУсилия = отЧисло.ПривестиЗначение(Значения[2]);
		КодОшибки = СокрЛП(Значения[3]);
		
		Если Не ЗначениеЗаполнено(Серьезность)
			ИЛИ Не ЗначениеЗаполнено(Тип) Тогда
			Продолжить;
		КонецЕсли;
		
		найденнаяСтрока = ПравилаКВыгрузке.Найти(КодОшибки, "Code");
		
		Если найденнаяСтрока = Неопределено Тогда
			Продолжить;
		КонецЕсли;
		
		Если Не найденнаяСтрока.Severity = Серьезность
			ИЛИ Не найденнаяСтрока.Type = Тип
			ИЛИ Не найденнаяСтрока.EffortMinutes = ЗатрачиваемыеУсилия Тогда
			
			строкИзменено = строкИзменено + 1;
			
			найденнаяСтрока.Severity = Серьезность;
			найденнаяСтрока.Type = Тип;
			найденнаяСтрока.EffortMinutes = ЗатрачиваемыеУсилия;
			
		КонецЕсли;
		
	КонецЦикла;
	
	Сообщить(СтрШаблон(НСтр("ru='Строк изменено: %1'"), строкИзменено));
	
	ЧтениеФайлаКлассификации = Неопределено;
	
КонецПроцедуры

Процедура ПрименитьНастройкиSTEBIНажатие(Элемент)
	// Вставить содержимое обработчика.
КонецПроцедуры

#КонецОбласти

Процедура ПравилаКВыгрузкеПриАктивизацииСтроки(Элемент)
	
	Если ЭлементыФормы.ПравилаКВыгрузке.ТекущиеДанные = Неопределено Тогда
		
		Возврат;
		
	КонецЕсли;
	
	ЭлементыФормы.РедакторHTML.УстановитьТекст(ЭлементыФормы.ПравилаКВыгрузке.ТекущиеДанные.Description);
	
КонецПроцедуры

// Формирование таблицы

Процедура ПрочитатьПравила()
	
	ПравилаКВыгрузке.Очистить();
	ПрочитатьОценкуПравил();
	
	отЧисло = Новый ОписаниеТипов("Число", Новый КвалификаторыЧисла(10, 0, ДопустимыйЗнак.Неотрицательный));
	
	Для Каждого требованиеВБазе Из СтрокиТребованийВБазе() Цикл
		
		новаяСтрокаПравила = ПравилаКВыгрузке.Добавить();
		новаяСтрокаПравила.Code = СокрЛП(требованиеВБазе.ОшибкаКод);
		новаяСтрокаПравила.Name = требованиеВБазе.ОшибкаНаименование;
		новаяСтрокаПравила.Active = Истина;
		новаяСтрокаПравила.NeedForCertificate = требованиеВБазе.ТребованиеПрименяетсяДля1ССовместимо;
		УстановитьСвойстваТипаИКритичности(новаяСтрокаПравила, требованиеВБазе);
		новаяСтрокаПравила.Description = ОписаниеОшибкиВHTML(требованиеВБазе);
		новаяСтрокаПравила.ЧисловойКод = отЧисло.ПривестиЗначение(новаяСтрокаПравила.Code);
		
	КонецЦикла;
	
	ПравилаКВыгрузке.Сортировать("ЧисловойКод");
	
	Сообщить(СтрШаблон(НСтр("ru='Прочитано правил к выгрузке: %1'"), ПравилаКВыгрузке.Количество()));

КонецПроцедуры

Функция СтрокиТребованийВБазе()
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ТребованияРеализацияТребования.Ссылка КАК Требование,
	|	ПравилаОбнаруживаемыеОшибки.Ошибка КАК Ошибка
	|ПОМЕСТИТЬ втТребования
	|ИЗ
	|	Справочник.Требования.РеализацияТребования КАК ТребованияРеализацияТребования
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.Правила.ОбнаруживаемыеОшибки КАК ПравилаОбнаруживаемыеОшибки
	|		ПО ТребованияРеализацияТребования.ПравилоПроверки = ПравилаОбнаруживаемыеОшибки.Ссылка
	|ГДЕ
	|	ПравилаОбнаруживаемыеОшибки.Ссылка.ИспользуетсяПриПроверке
	|	И НЕ ПравилаОбнаруживаемыеОшибки.Ссылка.ПолуавтоматическаяПроверка
	|	И НЕ ПравилаОбнаруживаемыеОшибки.Ссылка.ПометкаУдаления
	|	И ПравилаОбнаруживаемыеОшибки.Ошибка <> ЗНАЧЕНИЕ(Справочник.ОбнаруживаемыеОшибки.ПустаяСсылка)
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТребованияККонфигурации.Ошибка КАК Ошибка,
	|	ТребованияККонфигурации.Требование КАК Требование,
	|	ТребованияККонфигурации.Требование.СсылкаНаСтандарт КАК ТребованиеСсылкаНаСтандарт,
	|	ТребованияККонфигурации.Ошибка.Код КАК ОшибкаКод,
	|	ТребованияККонфигурации.Ошибка.Наименование КАК ОшибкаНаименование,
	|	ТребованияККонфигурации.Ошибка.Критичность КАК ОшибкаКритичность,
	|	ТребованияККонфигурации.Ошибка.Рекомендация КАК ОшибкаРекомендация,
	|	ТребованияККонфигурации.Требование.Описание КАК ТребованиеОписание,
	|	ТребованияККонфигурации.Требование.ОписаниеHTML КАК ТребованиеОписаниеHTML,
	|	ТребованияККонфигурации.Требование.ПрименяетсяДля1ССовместимо КАК ТребованиеПрименяетсяДля1ССовместимо
	|ИЗ
	|	втТребования КАК ТребованияККонфигурации
	|
	|УПОРЯДОЧИТЬ ПО
	|	ОшибкаКод
	|ИТОГИ
	|	МАКСИМУМ(ОшибкаКод),
	|	МАКСИМУМ(ОшибкаНаименование),
	|	МАКСИМУМ(ОшибкаКритичность),
	|	МАКСИМУМ(ТребованиеПрименяетсяДля1ССовместимо)
	|ПО
	|	Ошибка";
	
	Возврат Запрос.Выполнить().Выгрузить(ОбходРезультатаЗапроса.ПоГруппировкам).Строки;
	
КонецФункции

Процедура ПрочитатьОценкуПравил()
	
	МакетСПравилами = ЭтотОбъект.ПолучитьМакет("ПравилаОценка");
	Чтение = Новый ЧтениеJSON();
	Чтение.УстановитьСтроку(МакетСПравилами.ПолучитьТекст());
	ОценкаПравил = ПрочитатьJSON(Чтение);
	
КонецПроцедуры

Процедура УстановитьСвойстваТипаИКритичности(ОписаниеПравила, Правило)
	
	РезультатПоискаВОценке = НайтиПравилоВОценке(Правило);
	
	Если РезультатПоискаВОценке <> Неопределено Тогда
		
		ЗаполнитьЗначенияСвойств(ОписаниеПравила, РезультатПоискаВОценке, "Type,Severity,effortMinutes");
		
	ИначеЕсли Правило.ОшибкаКритичность = Перечисления.УровниКритичностиОшибок.Совместимо Тогда
		
		ОписаниеПравила.Type = "BUG";
		ОписаниеПравила.Severity = "CRITICAL";
		
	ИначеЕсли Правило.ОшибкаКритичность = Перечисления.УровниКритичностиОшибок.Обязательно Тогда
		
		ОписаниеПравила.Type = "CODE_SMELL";
		ОписаниеПравила.Severity = "CRITICAL";
		
	Иначе
		
		ОписаниеПравила.Type = "CODE_SMELL";
		ОписаниеПравила.Severity = "INFO";
		
	КонецЕсли;
	
КонецПроцедуры

Функция НайтиПравилоВОценке(Правило)
	
	Для Каждого ОценкаПравила Из ОценкаПравил Цикл
		
		КодНачало = СокрЛП(Правило.ОшибкаКод) + " :";
		
		Если ОценкаПравила.ruleId = Правило.ОшибкаНаименование ИЛИ СтрНачинаетсяС(ОценкаПравила.ruleId, КодНачало) Тогда
			
			Возврат ОценкаПравила;
			
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат Неопределено;
	
КонецФункции

Функция ОписаниеОшибкиВHTML(Правило)
	
	Если Правило.Строки.Количество() = 1 Тогда
		
		Возврат ВырезатьТело(Правило.Строки[0].ТребованиеОписаниеHTML);
		
	ИначеЕсли Правило.Строки.Количество() > 1 Тогда
		
		Описания = Новый Массив();
		
		Для Каждого Требование Из Правило.Строки Цикл
			
			Описания.Добавить(ВырезатьТело(Требование.ТребованиеОписаниеHTML));
			
		КонецЦикла;
		
		Возврат СтрСоединить(Описания, Символы.ПС + Символы.ПС + Символы.ПС);
		
	Иначе
		
		Возврат "Нет описания";
		
	КонецЕсли;
	
КонецФункции

Функция ВырезатьТело(Текст)
	
	ТекстВРЕГ = ВРег(Текст);
	
	ПозицияНачалаТела = СтрНайти(ТекстВРЕГ, "<BODY");
	ПозицияКонцаТела = СтрНайти(ТекстВРЕГ, "</BODY>");
	
	Если ПозицияНачалаТела > 0 И ПозицияКонцаТела > 0 Тогда
		
		Возврат СокрЛП(Сред(Текст, ПозицияНачалаТела + СтрДлина("<BODY>"), ПозицияКонцаТела - (ПозицияНачалаТела + СтрДлина("<BODY>"))));
		
	КонецЕсли;
	
	Возврат Текст;
	
КонецФункции

// Запись в файл

Функция ДанныеДляЗаписи()
	
	Правила = Новый Массив();
	
	Для Каждого ПравилоКВыгрузке Из ПравилаКВыгрузке Цикл
		
		НовыйЭлемент = Новый Структура("Code,Type,Severity,Name,Description,Active,NeedForCertificate,EffortMinutes");
		ЗаполнитьЗначенияСвойств(НовыйЭлемент, ПравилоКВыгрузке);
		Правила.Добавить(НовыйЭлемент);
		
	КонецЦикла;
	
	Возврат Новый Структура("Rules", Правила);
	
КонецФункции

СимволовВОкончанииHTMLОписания = 13;

