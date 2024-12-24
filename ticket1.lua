local lgi = require("lgi")
local Gtk = lgi.require("Gtk", "3.0")

local builder = Gtk.Builder()
builder:add_from_file("ticket_1.glade")

local wnd = builder:get_object("wnd")
local lb_output = builder:get_object("lb_output")

local num1 = ""
local num2 = ""
local operator = nil
local is_second_number = false

local function update_display()
    if is_second_number then
        lb_output.label = num2
    else
        lb_output.label = num1
    end
end

local function on_number_clicked(button)
    local number = button.label
    if is_second_number then
        num2 = num2 .. number
    else
        num1 = num1 .. number
    end
    update_display()
end

local function on_operator_clicked(button)
    if num1 ~= "" then
        operator = button.label
        is_second_number = true
    end
end

local function calculate()
    local n1 = tonumber(num1)
    local n2 = tonumber(num2)
    if not n1 or not n2 then return end

    if operator == "+" then
        return n1 + n2
    elseif operator == "-" then
        return n1 - n2
    elseif operator == "*" then
        return n1 * n2
    elseif operator == "/" then
        if n2 == 0 then
            return "Error: Division by 0"
        end
        return n1 / n2
    end
end

local function on_equal_clicked()
    local result = calculate()
    if result then
        num1 = tostring(result)
        num2 = ""
        operator = nil
        is_second_number = false
        lb_output.label = num1
    end
end

local function on_point_clicked()
    if is_second_number then
        if not num2:find("%.") then
            num2 = num2 .. "."
        end
    else
        if not num1:find("%.") then
            num1 = num1 .. "."
        end
    end
    update_display()
end

local function on_clear_clicked()
    num1 = ""
    num2 = ""
    operator = nil
    is_second_number = false
    update_display()
end

local function on_backspace_clicked()
    if is_second_number and #num2 > 0 then
        num2 = num2:sub(1, -2)
    elseif not is_second_number and #num1 > 0 then
        num1 = num1:sub(1, -2)
    end
    update_display()
end

local button_map = {
    btn_0 = on_number_clicked,
    btn_1 = on_number_clicked,
    btn_2 = on_number_clicked,
    btn_3 = on_number_clicked,
    btn_4 = on_number_clicked,
    btn_5 = on_number_clicked,
    btn_6 = on_number_clicked,
    btn_7 = on_number_clicked,
    btn_8 = on_number_clicked,
    btn_9 = on_number_clicked,
    btn_plus = on_operator_clicked,
    btn_minus = on_operator_clicked,
    btn_multi = on_operator_clicked,
    btn_divide = on_operator_clicked,
    btn_point = on_point_clicked,
    btn_equal = on_equal_clicked,
    btn_backspace = on_backspace_clicked,
}

for id, handler in pairs(button_map) do
    builder.objects[id].on_clicked = handler
end

wnd.on_destroy = Gtk.main_quit
wnd:show_all()
Gtk.main()
