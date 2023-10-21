timer.Simple(1, function()

if SGM.ModelAttachingInstalled or SGM.ModelAttachingRedistInstalled then return end


print("SGM's Vehicle Model Attaching Framework not found, using redistributable...")

CreateConVar("sgm_attached_props_update_freq", 2, {FCVAR_NOTIFY}, "Adjust the update frequency of attached props. WARNING: Extremely low values can be kind of laggy.", 0, 60)
CreateConVar("sgm_attached_props_submat_update_freq", 10, {FCVAR_NOTIFY}, "Adjust the SubMaterial update frequency of attached props. WARNING: Extremely low values can be incredibly laggy.", 1, 60)

SGM = SGM or {}
SGM.AttachModels = SGM.AttachModels or {}
SGM.AttachModelsByClass = SGM.AttachModelsByClass or {}
SGM.AttachedModels = SGM.AttachedModels or {}
SGM.ModelAttachingRedistInstalled = true

local function AttachProps(ent)
    if !SGM.AttachModels[ent:GetModel()] and !SGM.AttachModelsByClass[ent:GetVehicleClass()] then return end

    local modelData = {}
    if SGM.AttachModels[ent:GetModel()] then
    table.Add(modelData, SGM.AttachModels[ent:GetModel()])
    end
    if SGM.AttachModelsByClass[ent:GetVehicleClass()] then
        table.Add(modelData, SGM.AttachModelsByClass[ent:GetVehicleClass()])
    end

    for _,v in ipairs(modelData) do
        local prop = ents.Create("prop_physics")
        prop:SetModel(v.Model or "models/Gibs/HGIBS.mdl")
        prop:SetPos(ent:LocalToWorld(v.Pos or vector_origin))
        prop:SetAngles(ent:LocalToWorldAngles(v.Ang or angle_zero))
        prop:SetColor(v.Color or color_white)
        prop:Spawn()
        prop:SetNotSolid(true)
        prop:SetParent(ent)

        if v.SyncSubMaterials then
            prop.SyncSubMaterials = true
        end

        if v.SyncFunction then
            prop.SyncFunction = v.SyncFunction
        end

        if v.RenderMode then
            prop:SetRenderMode(v.RenderMode)
        end

        if v.SubMaterials then
            for _,v in pairs(v.SubMaterials) do
                prop:SetSubMaterial(_, v)
            end
        end

        if isvector(v.Scale) then
            prop:ManipulateBoneScale(0, v.Scale)
        end

        if isnumber(v.Scale) then
            prop:SetModelScale(v.Scale, 0)
        end

        if v.BoneMerge then
            prop:AddEffects( EF_BONEMERGE )
            prop:Fire("SetParentAttachment", "vehicle_engine")
        end

        if v.BoneParent then
            local boneId = ent:LookupBone(v.BoneParent)
            if boneId ~= nil then
                prop:FollowBone(ent, boneId)
            end
        end

        if v.Sync then
            table.insert(SGM.AttachedModels, prop)
            prop:CallOnRemove("RemoveFromTable", function()
                table.RemoveByValue(SGM.AttachedModels, prop)
            end)
        end
    end
end

hook.Add("OnEntityCreated", "SGM_Attach_Props", function(ent)
    if !IsValid(ent) then return end
    if ent:GetClass() ~= "prop_vehicle_jeep" then return end
    timer.Simple(0.25,function()
        AttachProps(ent)
    end)
end)

local lastUpdate = 0
local lastSubMatUpdate = 0

hook.Add("Think", "SGM_Attached_Props_Update", function()
    if lastUpdate > CurTime() - (GetConVar("sgm_attached_props_update_freq"):GetInt()) then return end
    lastUpdate = CurTime()

    for _,v in ipairs(SGM.AttachedModels) do
        if IsValid(v) then
            local prop = v
            local parent = prop:GetParent()

            prop:SetMaterial(parent:GetMaterial())
            prop:SetColor(parent:GetColor())
            prop:SetSkin(parent:GetSkin())
            local bgroupstring = "0"
            for _,v in ipairs(parent:GetBodyGroups()) do
                bgroupstring = bgroupstring..parent:GetBodygroup(_)
            end
            prop:SetBodyGroups(bgroupstring)

            if prop.SyncSubMaterials and (lastSubMatUpdate < CurTime() - (GetConVar("sgm_attached_props_submat_update_freq"):GetInt())) then
                local subMaterials = {}

                for __,v2 in ipairs(parent:GetMaterials()) do
                    local subMat = parent:GetSubMaterial(__ - 1)
                    local originalMat = parent:GetMaterials()[__]

                    subMaterials[__ - 1] = {
                        original = originalMat,
                        subMat = subMat,
                    }

                end

                for __,v2 in ipairs(v:GetMaterials()) do
                    local originalMat = v:GetMaterials()[__]

                    for ___,v3 in pairs(subMaterials) do
                        if v3.original == originalMat then
                            prop:SetSubMaterial(__ - 1, v3.subMat)
                        end
                    end

                end
            end

            if prop.SyncFunction then
                prop.SyncFunction(parent, prop)
            end
        end
    end

    if lastSubMatUpdate < CurTime() - (GetConVar("sgm_attached_props_submat_update_freq"):GetInt()) then
        lastSubMatUpdate = CurTime()
    end

end)

end)