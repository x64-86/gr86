local Category = "SGM Cars"

local V = {
				// Required information
				Name =	"2022 Toyota GR86",
				Class = "prop_vehicle_jeep",
				Category = Category,

				// Optional information
				Author = "SentryGunMan",
				Information = "vroom vroom",
				Model =	"models/sentry/gr86.mdl",
 
                                           

				KeyValues = {				
								vehiclescript =	"scripts/vehicles/sentry/gr86.txt"
					    }
}

list.Set( "Vehicles", "gr86_sgm", V )

SGM = SGM or {}
SGM.AttachModels = SGM.AttachModels or {}
SGM.AttachModelsByClass = SGM.AttachModelsByClass or {}
SGM.AttachedModels = SGM.AttachedModels or {}

SGM.AttachModels["models/sentry/gr86.mdl"] = {
    {
        Model = "models/sentry/gr86_2.mdl",
        Pos = Vector(0,0,0),
        Ang = Angle(0,0,0),
        Color = Color(255,255,255),
        Scale = 1,
        BoneMerge = true,
        BoneParent = "",
        RenderMode = RENDERMODE_NORMAL,
        Sync = false,
        SyncSubMaterials = false,
    },
}