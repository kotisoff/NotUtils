-- Этот скрипт использует not_utils:lib/events для создания своего эмиттера ивентов.
-- Под капотом скрипт просто создаёт новую таблицу, которая использует предустановленное значение,
-- которое указывается при создании эмиттера.

local pack_id = require "constants".pack_id;
local nu_events = require "lib/events_provider".new(pack_id);

return nu_events;
-- Вот настолько всё это просто.
