timer.Simple(0,function()
CreateClientConVar( "sgm_ignore_warnings", "0", true, false, "ignores the warning for improper shader variables" )
if GetConVar("sgm_ignore_warnings"):GetInt() != 1 and !timer.Exists("sgm_cvar_check") then
	timer.Create("sgm_cvar_check", 300, 0, function()
	if GetConVar("sgm_ignore_warnings"):GetInt() != 0 then 
	timer.Remove("sgm_cvar_check")
	return end
	
	local drawmodeldecals = GetConVar("r_drawmodeldecals"):GetInt()
	local matspecular = GetConVar("mat_specular"):GetInt()
	local matbump = GetConVar("mat_bumpmap"):GetInt()
	local rootlod = GetConVar("r_rootlod"):GetInt()
	if (drawmodeldecals != 0 and BRANCH != "x86-64" and BRANCH != "chromium") or matspecular != 1 or matbump != 1 or rootlod != 0 then
	chat.AddText(Color(200,20,20),
	"Some of your settings may reduce visual quality on high detailed models, and even crash your game.\n",Color(200,200,200),"The following settings can be affected:"
	.."\nr_drawmodeldecals: "..drawmodeldecals.." (If you're crashing from shooting cars, set this to 0 or switch to the x86-64 branch of Garry's Mod.)"
	.."\nr_rootlod: "..rootlod.." (Recommended: 0, if you're seeing visually distorted cars, set your model detail to 'High'.)"
	.."\nmat_specular: "..matspecular.." (Recommended: 1, this enables reflections on vehicles. )"
	.."\nmat_bumpmap: "..matbump.." (Recommended: 1, this allows certain textures to have depth and is also required for some reflection shaders.)"
	.."\n",Color(255,255,255),"You can disable this message by typing 'sgm_ignore_warnings 1' in console."
	)
	end
	end)
end
end)