require "import"
import "android.widget.*"
import "android.view.*"
import "android.graphics.PorterDuffColorFilter"
import "android.graphics.PorterDuff"
import "mods.muk"
import "mods.loadlayout"
import "com.michael.NoScrollListView"
import "android.widget.NumberPicker$OnValueChangeListener"
设置视图("layout/settings")

refuntion=...

if refuntion==nil then
  refuntion=[==[
data = {
  --{__type=1,title=""},
  {__type=3,subtitle="浏览设置",image=图标("")},
  {__type=3,subtitle="主页设置",image=图标("")},
  {__type=3,subtitle="缓存设置",image=图标("")},
  {__type=3,subtitle="Jesse205库设置",image=图标("")},
  {__type=3,subtitle="关于",image=图标("")}
}
tab={ --点击table
  浏览设置=function()
    local 执行代码 =[[
_title.text="浏览设置"
data={
  --{__type=1,title=""},
  {__type=4,subtitle="内部浏览器查看回答",image=图标(""),status={Checked=Boolean.valueOf(this.getSharedData("内部浏览器查看回答"))}},
  {__type=4,subtitle="自动打开剪贴板上的知乎链接",image=图标(""),status={Checked=Boolean.valueOf(this.getSharedData("自动打开剪贴板上的知乎链接"))}},
  --  {__type=1,title=""},
  {__type=4,subtitle="夜间模式追随系统",image=图标(""),status={Checked=Boolean.valueOf(this.getSharedData("Setting_Auto_Night_Mode"))}},
  {__type=4,subtitle="夜间模式",image=图标(""),status={Checked=Boolean.valueOf(this.getSharedData("Setting_Night_Mode"))}},
  --  {__type=1,title=""},
  --  {__type=4,subtitle="内部搜索(beta)",image=图标(""),status={Checked=Boolean.valueOf(this.getSharedData("内部搜索(beta)"))}},
  {__type=4,subtitle="回答预加载(beta)",image=图标(""),status={Checked=Boolean.valueOf(this.getSharedData("回答预加载(beta)"))}},
  {__type=4,subtitle="加载回答中存在的视频(beta)",image=图标(""),status={Checked=Boolean.valueOf(this.getSharedData("加载回答中存在的视频(beta)"))}},
    {__type=4,subtitle="标题简略化",image=图标(""),status={Checked=Boolean.valueOf(this.getSharedData("标题简略化"))}},
  {__type=5,subtitle="字体大小",image=图标(""),status={
      minValue=10,
      value=tonumber(activity.getSharedData("font_size")),
      maxValue=30,
      OnValueChangedListener=OnValueChangeListener{
        onValueChange=function(_,a,b)
          activity.setResult(1200,nil)
          activity.setSharedData("font_size",(b).."")
        end,
      },
      wrapSelectorWheel=false,
    }},
}


tab={ --点击table
  ["回答预加载(beta)"]=function()
    提示("此功能可能还有隐性bug,仅供体验，若影响体验请关闭")
  end,
  ["加载回答中存在的视频(beta)"]=function()
    提示("开启后如果没有加载请多次尝试")
  end,
  夜间模式=function()
    提示("返回主页面生效")
    activity.setResult(1200,nil)
  end,
  夜间模式追随系统=function(self)
    self.夜间模式()
  end,
  字体大小=function()
    activity.setResult(1200,nil)
  end
}
  ]]
    activity.newActivity("settings",{执行代码})
  end,
  主页设置=function()
    local 执行代码=[[
_title.text="主页设置"
data = {
  --{__type=1,title=""},
  {__type=3,subtitle="修改主页排序",image=图标("")},
}

tab={ --点击table
  修改主页排序=function()
    Http.get("https://www.zhihu.com/api/v4/me",{
      ["cookie"] = 获取Cookie("https://www.zhihu.com/");
    },function(code,content)
      if code==200 then
        activity.newActivity("xgtj")
       elseif code==401 then
        提示("请登录后使用本功能")
      end
    end)
  end,
}
  ]]
    activity.newActivity("settings",{执行代码})
  end,
  缓存设置=function()
    local 执行代码=[[
import "androidx.core.content.ContextCompat"
function clear()
  task(function(dar)
    --   dar=File(activity.getLuaDir()).parent.."/cache/webviewCache"
    require "import"
    import "java.io.File"
    local tmp={[1]=0}

    local function getDirSize(tab,path)
      if File(path).exists() then
        local a=luajava.astable(File(path).listFiles() or {})

        for k,v in pairs(a) do
          if v.isDirectory() then
            getDirSize(tab,tostring(v))
           else

            tab[1]=tab[1]+v.length()
          end
        end
      end
    end
    dar=tostring(ContextCompat.getDataDir(activity)).."/cache"
    getDirSize(tmp,dar)
    getDirSize(tmp,"/sdcard/Android/data/"..activity.getPackageName().."/cache/")

    local a1,a2=File("/data/data/"..activity.getPackageName().."/database/webview.db"),File("/data/data/"..activity.getPackageName().."/database/webviewCache.db")
    pcall(function()
      tmp[1]=tmp[1]+(a1.length() or 0)+(a2.length() or 0)
      a1.delete()
      a2.delete()
    end)
    LuaUtil.rmDir(File(dar))
    LuaUtil.rmDir(File("/sdcard/Android/data/"..activity.getPackageName().."/cache/images"))

    return tmp[1]
  end,APP_CACHEDIR,function(m)

    提示("清理成功,共清理 "..tokb(m))
  end)
end

_title.text="缓存设置"
data={
  --{__type=1,title=""},
  --  {__type=1,title=""},
  {__type=4,subtitle="自动清理缓存",image=图标(""),status={Checked=Boolean.valueOf(this.getSharedData("自动清理缓存"))}},
  {__type=4,subtitle="禁用大部分缓存",image=图标(""),status={Checked=Boolean.valueOf(this.getSharedData("禁用缓存"))}},
  {__type=3,subtitle="清理软件缓存",image=图标("")},
}


tab={ --点击table
  禁用大部分缓存=function()
    if this.getSharedData("禁用缓存")=="false" then
      clear()
    end
    提示("开启本并非完全禁用 只可禁用60％左右的缓存")
  end,
  自动清理缓存=function()
    提示("下次打开软件时生效")
  end,
  清理软件缓存=function()
    clear()
  end,
}
]]
    activity.newActivity("settings",{执行代码})
  end,
    Jesse205库设置=function()
local dialog=AlertDialog.Builder(this)
.setTitle("提示")
.setMessage("本软件导入了Jesse205库 Jesse205库内也有一套设置 请问是否进入?")
.setPositiveButton("取消",nil)
.setNegativeButton("好的",{onClick=function() newSubActivity("Settings") end})
.show()
end,
  关于=function()
    activity.newActivity("about")
  end
}
]==]
end

assert(load(refuntion))()

波纹({fh},"圆主题")

about_item={
  {--标题
    LinearLayout;

    layout_width="fill";
    layout_height="-2";
    {
      TextView;
      Focusable=true;
      layout_marginTop="12dp";
      layout_marginBottom="12dp";
      gravity="center_vertical";
      Typeface=字体("product");
      id="title";
      textSize="15sp";
      textColor=primaryc;
      layout_marginLeft="16dp";
    };
  };

  {--图片,标题,简介
    LinearLayout;
    gravity="center";
    layout_width="fill";
    layout_height="64dp";
    {
      ImageView;
      layout_height="25dp";
      id="image";
      --padding="10dp";
      layout_width="25dp";
      layout_marginLeft="15dp";
      ColorFilter=textc;
    };
    {
      LinearLayout;
      orientation="vertical";
      layout_height="fill";
      gravity="center_vertical";
      layout_weight="1";
      {
        TextView;
        id="subtitle";
        textSize="16sp";
        textColor=textc;
        Typeface=字体("product");
        layout_marginLeft="16dp";
      };
      {
        TextView;
        textColor=stextc;
        id="message";
        textSize="14sp";

        Typeface=字体("product");
        layout_marginLeft="16dp";
      };
    };
  };

  {--图片,标题
    LinearLayout;
    layout_width="fill";
    layout_height="64dp";
    gravity="center_vertical";
    {
      ImageView;
      layout_height="25dp";
      id="image";
      --padding="10dp";
      layout_width="25dp";
      layout_marginLeft="15dp";
      ColorFilter=textc;
    };
    {
      TextView;
      id="subtitle";
      Typeface=字体("product");
      textSize="16sp";
      textColor=textc;
      layout_marginLeft="16dp";
    };
  };



  {--图片,标题,checkbox
    LinearLayout;
    gravity="center_vertical";
    layout_width="fill";
    layout_height="64dp";
    {
      ImageView;
      layout_height="25dp";
      id="image";
      --padding="10dp";
      layout_width="25dp";
      layout_marginLeft="15dp";
      ColorFilter=textc;
    };
    {
      TextView;
      id="subtitle";
      Typeface=字体("product");
      textSize="16sp";
      textColor=textc;
      gravity="center_vertical";
      layout_weight="1";
      layout_height="-1";
      layout_marginLeft="16dp";
    };
    {
      CheckBox;
      CheckBoxBackground=转0x(primaryc),
      id="status";
      focusable=false;
      clickable=false;
      layout_marginRight="16dp";
    };

  };

  {--图片 标题 描述 选框
    LinearLayout;
    gravity="center_vertical";
    layout_width="fill";
    layout_height="64dp";
    {
      ImageView;
      layout_height="25dp";
      id="image";
      --padding="10dp";
      layout_width="25dp";
      layout_marginLeft="15dp";
      ColorFilter=textc;
    };
    {
      LinearLayout;
      orientation="vertical";
      layout_height="fill";
      gravity="center_vertical";
      layout_weight="1";
      {
        TextView;
        id="subtitle";
        textSize="16sp";
        textColor=textc;
        Typeface=字体("product");
        layout_marginLeft="16dp";
      };

    };
    {
      NumberPicker;
      id="status";
      focusable=true;
      clickable=true;
      layout_marginRight="16dp";
    };
    {
      TextView;
      text="sp",
      textColor=textc,
      textSize="14sp",
      layout_marginRight="24dp";
    };

  };
};



if this.getSharedData("内部浏览器查看回答") == nil then
  this.setSharedData("内部浏览器查看回答","false")
end

if this.getSharedData("加载回答中存在的视频(beta)") == nil then
  this.setSharedData("加载回答中存在的视频(beta)","true")
end



--activity.setTheme(Theme_Material_Light)


adp=LuaMultiAdapter(this,data,about_item)

--[[adp.addAll{
  --{__type=1,title=""},
  {__type=4,subtitle="内部浏览器查看回答",image=图标(""),status={Checked=Boolean.valueOf(this.getSharedData("内部浏览器查看回答"))}},
  {__type=4,subtitle="自动打开剪贴板上的知乎链接",image=图标(""),status={Checked=Boolean.valueOf(this.getSharedData("自动打开剪贴板上的知乎链接"))}},
  --  {__type=1,title=""},
  {__type=4,subtitle="夜间模式追随系统",image=图标(""),status={Checked=Boolean.valueOf(this.getSharedData("Setting_Auto_Night_Mode"))}},
  {__type=4,subtitle="夜间模式",image=图标(""),status={Checked=Boolean.valueOf(this.getSharedData("Setting_Night_Mode"))}},
  --  {__type=1,title=""},
  --  {__type=4,subtitle="内部搜索(beta)",image=图标(""),status={Checked=Boolean.valueOf(this.getSharedData("内部搜索(beta)"))}},
  {__type=4,subtitle="回答预加载(beta)",image=图标(""),status={Checked=Boolean.valueOf(this.getSharedData("回答预加载(beta)"))}},
  {__type=4,subtitle="加载回答中存在的视频(beta)",image=图标(""),status={Checked=Boolean.valueOf(this.getSharedData("加载回答中存在的视频(beta)"))}},
  {__type=5,subtitle="字体大小",image=图标(""),status={
      minValue=10,
      value=tonumber(activity.getSharedData("font_size")),
      maxValue=30,
      OnValueChangedListener=OnValueChangeListener{
        onValueChange=function(_,a)
          activity.setResult(1200,nil)

          activity.setSharedData("font_size",(a+1).."")
        end,
      },
      wrapSelectorWheel=false,
  }},
  --  {__type=1,title=""},
  {__type=3,subtitle="清理缓存",image=图标("")},--,status={Checked=Boolean.valueOf(this.getSharedData("内部浏览器查看回答"))}}
  {__type=3,subtitle="关于",image=图标("")},
  {__type=3,subtitle="修改主页推荐顺序",image=图标("")},
}]]

settings_list.setAdapter(adp)


--[[function clear()
  task(function(dar)
    --   dar=File(activity.getLuaDir()).parent.."/cache/webviewCache"
    require "import"
    import "java.io.File"
    local tmp={[1]=0}

    local function getDirSize(tab,path)
      if File(path).exists() then
        local a=luajava.astable(File(path).listFiles() or {})

        for k,v in pairs(a) do
          if v.isDirectory() then
            getDirSize(tab,tostring(v))
           else

            tab[1]=tab[1]+v.length()
          end
        end
      end
    end
    getDirSize(tmp,dar)
    getDirSize(tmp,"/sdcard/Android/data/"..activity.getPackageName().."/cache/images")

    local a1,a2=File("/data/data/"..activity.getPackageName().."/database/webview.db"),File("/data/data/"..activity.getPackageName().."/database/webviewCache.db")
    pcall(function()
      tmp[1]=tmp[1]+(a1.length() or 0)+(a2.length() or 0)
      a1.delete()
      a2.delete()
    end)
    LuaUtil.rmDir(File(dar))
    LuaUtil.rmDir(File("/sdcard/Android/data/"..activity.getPackageName().."/cache/images"))

    return tmp[1]
    end,APP_CACHEDIR,function(m)

    提示("清理成功,共清理 "..tokb(m))
  end)
end]]




settab={
  ["夜间模式"]="Setting_Night_Mode",
  ["夜间模式追随系统"]="Setting_Auto_Night_Mode",
}--设置数据

settings_list.setOnItemClickListener(AdapterView.OnItemClickListener{
  onItemClick=function(id,v,zero,one)
    if v.Tag.status ~= nil then

      if v.Tag.status.Checked then
        this.setSharedData(settab[tostring(v.Tag.subtitle.Text)] or v.Tag.subtitle.Text,"false")
        data[one].status["Checked"]=false
       else
        this.setSharedData(settab[tostring(v.Tag.subtitle.Text)] or v.Tag.subtitle.Text,"true")
        data[one].status["Checked"]=true
      end

    end
    (tab[tostring(v.Tag.subtitle.Text)] or function()end) (tab)
    adp.notifyDataSetChanged()--更新列表
end})


if this.getSharedData("更新设置字体设置")=="true" then
  this.setSharedData("更新设置字体设置",nil)
  activity.setResult(1200,nil)
end


function onActivityResult(a,b,c)
  if b==1200 then
    local res =this.getResources();
    local config = res.getConfiguration();
    if config.fontScale~=tonumber(this.getSharedData("font_size"))/20 then
      this.setSharedData("更新设置字体设置","true")
      activity.recreate()
    end
    activity.setResult(1200,nil)
  end

end