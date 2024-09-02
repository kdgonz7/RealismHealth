--# realism health lol
if CLIENT then return end

local health_modifier   = 5.0   // calculations are randomly selected from half this value, to the full value for variety.
local shield_helper     = 0.3   // shield, a chance for an entity to have higher health.
local chance_for_shield = 2     // 1 in this number 

-- the whitelist.
-- used to add NPCs that can have these special health modifiers
local whitelist = {
    ["npc_combine_s"] = true
}

---@param entity Entity
hook.Add("OnEntityCreated", "realism", function (entity)
    if ! IsValid(entity) then return end
    if ! whitelist[entity:GetClass()] then return end

    timer.Simple(0, function()
        if ! IsValid(entity) then return end

        entity:SetHealth(entity:GetMaxHealth() * math.random(health_modifier/2, health_modifier))

        if math.random(0, chance_for_shield) == 1 then
            entity:SetNWBool("shield_tagged", true)  /* this one is special */
            entity:SetColor(Color(179, 181, 255)) /* a little blue */
        end
    end)
end)

---@param target Entity
---@param dmg CTakeDamageInfo
hook.Add("EntityTakeDamage", "realism_2", function (target, dmg)
    if ! IsValid(target) then return end

    if target:GetNWBool("shield_tagged", false) then
        dmg:SetDamage(dmg:GetDamage() * shield_helper)
    end
end)

print('loaded', 'realism health addon')
