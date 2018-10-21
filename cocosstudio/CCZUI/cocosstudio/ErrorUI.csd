<GameProjectFile>
  <PropertyGroup Type="Node" Name="ErrorUI" ID="09b9f97e-2947-44b2-855a-d5c47bf117dc" Version="2.0.6.0" />
  <Content ctype="GameProjectContent">
    <Content>
      <Animation Duration="0" Speed="1.0000" />
      <ObjectData Name="Node" FrameEvent="" Tag="17" ctype="SingleNodeObjectData">
        <Position X="0.0000" Y="0.0000" />
        <Scale ScaleX="1.0000" ScaleY="1.0000" />
        <AnchorPoint />
        <CColor A="255" R="255" G="255" B="255" />
        <Size X="0.0000" Y="0.0000" />
        <PrePosition X="0.0000" Y="0.0000" />
        <PreSize X="0.0000" Y="0.0000" />
        <Children>
          <NodeObjectData Name="Root" ActionTag="-1079179216" FrameEvent="" Tag="24" ObjectIndex="1" TouchEnable="True" BackColorAlpha="127" ComboBoxIndex="1" ColorAngle="90.0000" ctype="PanelObjectData">
            <Position X="0.7692" Y="0.0000" />
            <Scale ScaleX="1.0000" ScaleY="1.0000" />
            <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
            <CColor A="255" R="255" G="255" B="255" />
            <Size X="600.0000" Y="400.0000" />
            <PrePosition X="0.0000" Y="0.0000" />
            <PreSize X="0.0000" Y="0.0000" />
            <Children>
              <NodeObjectData Name="ScrollView" ActionTag="734421399" FrameEvent="" Tag="18" ObjectIndex="1" PrePositionEnabled="True" TouchEnable="True" ClipAble="True" BackColorAlpha="76" ComboBoxIndex="1" ColorAngle="90.0000" ScrollDirectionType="Vertical_Horizontal" ctype="ScrollViewObjectData">
                <Position X="300.0000" Y="200.0000" />
                <Scale ScaleX="1.0000" ScaleY="1.0286" />
                <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                <CColor A="255" R="255" G="255" B="255" />
                <Size X="500.0000" Y="280.0000" />
                <PrePosition X="0.5000" Y="0.5000" />
                <PreSize X="0.8333" Y="0.7000" />
                <Children>
                  <NodeObjectData Name="ErrorLabel" ActionTag="1311942215" FrameEvent="" Tag="22" ObjectIndex="2" FontSize="14" LabelText="stack traceback:&#xA;        [string &quot;src/module/player/game_data.lua&quot;]:289: in function 'isRPlot'&#xA;        [string &quot;src/module/ui/tipbox.lua&quot;]:27: in function 'ctor'&#xA;        [string &quot;src/framework/functions.lua&quot;]:315: in function 'new'&#xA;        [string &quot;src/module/ui/tipbox.lua&quot;]:58: in function 'showTip'&#xA;        [string &quot;src/module/studio_ui/loading_ui.lua&quot;]:46: in function 'callback'&#xA;        [string &quot;src/module/common/ui_helper.lua&quot;]:53: in function 'addButtonEffect'&#xA;        [string &quot;src/module/common/ui_helper.lua&quot;]:60: in function &lt;[string &quot;src/module/common/ui_helper.lua&quot;]:59&gt;" IsCustomSize="True" ctype="TextObjectData">
                    <Position X="252.0754" Y="797.1517" />
                    <Scale ScaleX="1.0000" ScaleY="1.0000" />
                    <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                    <CColor A="255" R="255" G="255" B="255" />
                    <Size X="500.0000" Y="400.0000" />
                    <PrePosition X="0.5042" Y="0.7972" />
                    <PreSize X="0.8333" Y="0.4000" />
                    <FontResource Type="Normal" Path="ccz/ui/font/lishu.ttf" />
                  </NodeObjectData>
                </Children>
                <SingleColor A="255" R="105" G="111" B="106" />
                <FirstColor A="255" R="105" G="111" B="106" />
                <EndColor A="255" R="255" G="255" B="255" />
                <ColorVector ScaleY="1.0000" />
                <InnerNodeSize Width="500" Height="1000" />
              </NodeObjectData>
              <NodeObjectData Name="BitmapFontLabel_1" ActionTag="1240651280" FrameEvent="" Tag="20" ObjectIndex="1" LabelText="错误提示" ctype="TextBMFontObjectData">
                <Position X="301.1297" Y="364.9503" />
                <Scale ScaleX="1.5176" ScaleY="1.9467" />
                <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                <CColor A="255" R="255" G="0" B="0" />
                <Size X="107.0000" Y="26.0000" />
                <PrePosition X="0.5019" Y="0.9124" />
                <PreSize X="0.0000" Y="0.0000" />
                <LabelBMFontFile_CNB Type="Normal" Path="ccz/ui/font/ziku_0.fnt" />
              </NodeObjectData>
              <NodeObjectData Name="CloseButton" ActionTag="496607124" FrameEvent="" Tag="23" ObjectIndex="1" TouchEnable="True" FontSize="14" ButtonText="" Scale9Width="71" Scale9Height="71" ctype="ButtonObjectData">
                <Position X="575.3757" Y="371.5587" />
                <Scale ScaleX="1.0543" ScaleY="1.0000" />
                <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                <CColor A="255" R="255" G="255" B="255" />
                <Size X="71.0000" Y="71.0000" />
                <PrePosition X="0.9590" Y="0.9289" />
                <PreSize X="0.0000" Y="0.0000" />
                <TextColor A="255" R="65" G="65" B="70" />
                <DisabledFileData Type="Normal" Path="ccz/ui/res/button3.png" />
                <PressedFileData Type="Normal" Path="ccz/ui/res/button3.png" />
                <NormalFileData Type="Normal" Path="ccz/ui/res/button3.png" />
              </NodeObjectData>
            </Children>
            <SingleColor A="255" R="33" G="33" B="33" />
            <FirstColor A="255" R="33" G="33" B="33" />
            <EndColor A="255" R="255" G="255" B="255" />
            <ColorVector ScaleY="1.0000" />
          </NodeObjectData>
        </Children>
      </ObjectData>
    </Content>
  </Content>
</GameProjectFile>