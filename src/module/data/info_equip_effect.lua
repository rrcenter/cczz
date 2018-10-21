
-- 导表工具自动生成

local EquipEffectInfo = {
    ["EFFECT_ADD_EXP"] = {
        ["desc"] = "增加武将经验（如孟徳新书）",
        ["value"] = 25,
    },
    ["EFFECT_ADD_HITSTATUS"] = {
        ["desc"] = "添加一个攻击状态（如吕布之弓等）",
        ["value"] = 7,
    },
    ["EFFECT_ADD_PROP"] = {
        ["desc"] = "增加属性（如古锭刀）",
        ["value"] = 4,
    },
    ["EFFECT_ATTACK_BACK_AGAIN"] = {
        ["desc"] = "反击再反击（如雌雄双剑）",
        ["value"] = 2,
    },
    ["EFFECT_ATTACK_DAMGERATE"] = {
        ["desc"] = "物理伤害的附加因子（如青釭剑）",
        ["value"] = 3,
    },
    ["EFFECT_ATTACK_HITRATE"] = {
        ["desc"] = "物理命中的附加因子（如布手套）",
        ["value"] = 1,
    },
    ["EFFECT_CHANGE_ATTACKRANGE"] = {
        ["desc"] = "改变攻击范围（如没羽箭）",
        ["value"] = 21,
    },
    ["EFFECT_CHANGE_HITRANGE"] = {
        ["desc"] = "改变攻击方式（如蛇矛等）",
        ["value"] = 6,
    },
    ["EFFECT_DEFENSE_ATTACK_DAMGE"] = {
        ["desc"] = "伤害减少（如铜制马铠）",
        ["value"] = 24,
    },
    ["EFFECT_DEFENSE_CRITATTACK"] = {
        ["desc"] = "防御致命一击（如黄金甲）",
        ["value"] = 9,
    },
    ["EFFECT_DEFENSE_DOUBLEATTACK"] = {
        ["desc"] = "防御连击中的第二击（如连环甲）",
        ["value"] = 8,
    },
    ["EFFECT_DEFENSE_HITRATE"] = {
        ["desc"] = "物理命中的附加因子（如倚天剑）",
        ["value"] = 11,
    },
    ["EFFECT_DEFENSE_YUANCHENG"] = {
        ["desc"] = "防御远程攻击（如镜铠）",
        ["value"] = 10,
    },
    ["EFFECT_DIE_AGAIN_ATTACK"] = {
        ["desc"] = "引导攻击（如方天画戟）",
        ["value"] = 12,
    },
    ["EFFECT_LEARNMAGIC"] = {
        ["desc"] = "策略模仿（如遁甲天书）",
        ["value"] = 23,
    },
    ["EFFECT_MAGIC_ATTACK_DAMGE"] = {
        ["desc"] = "策略伤害加强（如芭蕉扇，进攻）",
        ["value"] = 13,
    },
    ["EFFECT_MAGIC_ATTACK_HITRATE"] = {
        ["desc"] = "策略命中加强（如七星剑，进攻）",
        ["value"] = 15,
    },
    ["EFFECT_MAGIC_DEFENSE_DAMGE"] = {
        ["desc"] = "策略伤害加强（如白银铠，防守）",
        ["value"] = 14,
    },
    ["EFFECT_MAGIC_DEFENSE_HITRATE"] = {
        ["desc"] = "策略命中减弱（如风神盾，防守）",
        ["value"] = 16,
    },
    ["EFFECT_MAGIC_MPCOST"] = {
        ["desc"] = "策略mp消耗增加或减少（如白羽扇）",
        ["value"] = 17,
    },
    ["EFFECT_MOVE_IGNORE_ENEMY"] = {
        ["desc"] = "突击移动（如赤兔马）",
        ["value"] = 19,
    },
    ["EFFECT_MOVE_IGNORE_TILE"] = {
        ["desc"] = "恶路移动（如的卢）",
        ["value"] = 20,
    },
    ["EFFECT_MP_REPLACE_HP"] = {
        ["desc"] = "mp替换hp的效果（如龙鳞铠）",
        ["value"] = 18,
    },
    ["EFFECT_MUST_CRITATTACK"] = {
        ["desc"] = "必定暴击（如玉玺）",
        ["value"] = 22,
    },
    ["EFFECT_NON_ATTACK_BACK"] = {
        ["desc"] = "禁止反击（如青龙偃月刀）",
        ["value"] = 5,
    },
    ["EFFECT_TURN_BEGIN_ADD_PROP"] = {
        ["desc"] = "每回合开始前增加某些属性（如凤凰羽衣）",
        ["value"] = 26,
    },
    ["EFFECT_TURN_BEGIN_REMOVE_STATUS"] = {
        ["desc"] = "回合开始前清除负面状态",
        ["value"] = 28,
    },
    ["EFFECT_WHEN_HURT_USE_ITEM"] = {
        ["desc"] = "受伤使用道具（如豆袋）",
        ["value"] = 27,
    },
}

return EquipEffectInfo
