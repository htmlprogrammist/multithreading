//
//  Quality of service.swift
//  multithreading
//
//  Created by Егор Бадмаев on 11.04.2022.
//

import Foundation

/// # Глобальные очереди
// Помимо пользовательских очередей, которые нужно специально создавать, система iOS предоставляет в распоряжение разработчика готовые (out-of-the-box) глобальные очереди (queues). Их 5:

// 1. Последовательная очередь Main queue, в которой происходят все операции с пользовательским интерфейсом (UI):
let main = DispatchQueue.main
// Если вы хотите выполнить функцию или замыкание, которые что-то делают с пользовательским интерфейсом (UI), с UIButton или с UI-чем-нибудь, вы должны поместить эту функцию или замыкание на Main queue. Эта очередь имеет наивысший приоритет среди глобальных очередей.

// 2. 4 фоновых concurrent (параллельных) глобальных очереди с разным качеством обслуживания qos и, конечно, разными приоритетами:

/// # Наивысший приоритет
let userInteractiveQueue = DispatchQueue.global(qos: .userInteractive)
// Для заданий, которые взаимодействуют с пользователем в данный момент и занимают очень мало времени: анимация, выполняются мгновенно; пользователь не хочет этого делать на Main queue, однако это должно быть сделано по возможности быстро, так как пользователь взаимодействует со мной прямо сейчас. Можно представить ситуацию, когда пользователь водит пальцем по экрану, а вам необходимо просчитать что-то, связанное с интенсивной обработкой изображения, и вы размещаете расчет в этой очереди. Пользователь продолжает водить пальцем по экрану, он не сразу видит результат, результат немного отстает от положения пальца на экране, так как расчеты требуют некоторого времени, но по крайней мере Main queue все еще “слушает” наши пальцы и реагирует на них. Эта очередь имеет очень высокий приоритет, но ниже, чем у Main queue.

let userInitiatedQueue = DispatchQueue.global(qos: .userInitiated)
// .userInitiated — для заданий, которые инициируются пользователем и требуют обратной связи, но это не внутри интерактивного события, пользователь ждет обратной связи, чтобы продолжить взаимодействие; может занять несколько секунд; имеет высокий приоритет, но ниже, чем у предыдущей очереди,

let utilityQueue = DispatchQueue.global(qos: .utility)
// .utulity — для заданий, которые требуют некоторого времени для выполнения и не требуют немедленной обратной связи, например, загрузка данных или очистка некоторой базы данных. Делается что-то, о чем пользователь не просит, но это необходимо для данного приложения. Задание может занять от несколько секунд до нескольких минут; приоритет ниже, чем у предыдущей очереди,

/// # Самый низкий приоритет
let backgroundQueue = DispatchQueue.global(qos: .background)
// .background — для заданий, не связанных с визуализацией и не критичных ко времени исполнения; например, backups или синхронизация с web — сервисом. Это то, что обычно запускается в фоновом режиме, происходит только тогда, когда никто не хочет никакого обслуживания. Просто фоновая задача, которая занимает значительное время от минут до часов; имеет наиболее низкий приоритет среди всех глобальных очередей.

let defaultQueue = DispatchQueue.global() // по умолчанию
// Есть еще Глобальная параллельная (concurrency) очередь по умолчанию .default, которая сообщает об отсутствие информации о «качестве обслуживания» qos. Она создается с помощью оператора: DispatchQueue.global()

// Каждую из этих очередей Apple наградила абстрактным «качеством обслуживания» qos (сокращение для Quality of Service), и мы должны решить, каким оно должно быть для наших заданий.
// Ниже представлены различные qos и объясняется, для чего они предназначены:

// Если удается определить qos информацию из других источников, то используется она, если нет, то используется qos между .userInitiated и .utility.

// Важно понимать, что все эти глобальные очереди являются СИСТЕМНЫМИ глобальными очередями и наши задания — не единственные задания в этой очереди! Также важно знать, что все глобальные очереди, кроме одной, являются concurrent (параллельными) очередями.
