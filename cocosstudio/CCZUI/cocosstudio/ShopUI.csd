<GameProjectFile>
  <PropertyGroup Type="Node" Name="ShopUI" ID="9447c710-e6b7-497f-8fed-706bc449e679" Version="2.0.6.0" />
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
          <NodeObjectData Name="Panel" ActionTag="1044538145" FrameEvent="" Tag="18" ObjectIndex="1" TouchEnable="True" BackColorAlpha="102" ColorAngle="90.0000" Scale9Enable="True" LeftEage="120" RightEage="120" TopEage="80" BottomEage="50" Scale9OriginX="120" Scale9OriginY="80" Scale9Width="20" Scale9Height="24" ctype="PanelObjectData">
            <Position X="0.5000" Y="-2.5195" />
            <Scale ScaleX="1.0000" ScaleY="1.0000" />
            <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
            <CColor A="255" R="255" G="255" B="255" />
            <Size X="600.0000" Y="400.0000" />
            <PrePosition X="0.0000" Y="0.0000" />
            <PreSize X="0.0000" Y="0.0000" />
            <Children>
              <NodeObjectData Name="BuyButton" ActionTag="-1672215627" FrameEvent="" Tag="22" ObjectIndex="1" TouchEnable="True" FontSize="26" ButtonText="买入" Scale9Width="126" Scale9Height="44" ctype="ButtonObjectData">
                <Position X="117.3377" Y="364.9843" />
                <Scale ScaleX="1.0000" ScaleY="1.0000" />
                <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                <CColor A="255" R="255" G="255" B="255" />
                <Size X="126.0000" Y="44.0000" />
                <PrePosition X="0.1956" Y="0.9125" />
                <PreSize X="0.0000" Y="0.0000" />
                <FontResource Type="Normal" Path="ccz/ui/font/lishu.ttf" />
                <TextColor A="255" R="255" G="255" B="255" />
                <DisabledFileData Type="Normal" Path="ccz/ui/res/button1.png" />
                <PressedFileData Type="Normal" Path="ccz/ui/res/button1.png" />
                <NormalFileData Type="Normal" Path="ccz/ui/res/button4.png" />
              </NodeObjectData>
              <NodeObjectData Name="SellButton" ActionTag="844018488" FrameEvent="" Tag="297" ObjectIndex="2" TouchEnable="True" FontSize="26" ButtonText="卖出" Scale9Width="126" Scale9Height="44" ctype="ButtonObjectData">
                <Position X="247.4287" Y="364.9843" />
                <Scale ScaleX="1.0000" ScaleY="1.0000" />
                <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                <CColor A="255" R="255" G="255" B="255" />
                <Size X="126.0000" Y="44.0000" />
                <PrePosition X="0.4124" Y="0.9125" />
                <PreSize X="0.0000" Y="0.0000" />
                <FontResource Type="Normal" Path="ccz/ui/font/lishu.ttf" />
                <TextColor A="255" R="255" G="255" B="255" />
                <DisabledFileData Type="Normal" Path="ccz/ui/res/button1.png" />
                <PressedFileData Type="Normal" Path="ccz/ui/res/button1.png" />
                <NormalFileData Type="Normal" Path="ccz/ui/res/button4.png" />
              </NodeObjectData>
              <NodeObjectData Name="Image_2" ActionTag="1086177648" FrameEvent="" Tag="299" ObjectIndex="2" PrePositionEnabled="True" Scale9Enable="True" LeftEage="20" RightEage="20" TopEage="20" BottomEage="20" Scale9OriginX="20" Scale9OriginY="20" Scale9Width="90" Scale9Height="92" ctype="ImageViewObjectData">
                <Position X="228.0000" Y="188.0000" />
                <Scale ScaleX="1.0000" ScaleY="1.0000" />
                <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                <CColor A="255" R="255" G="255" B="255" />
                <Size X="420.0000" Y="300.0000" />
                <PrePosition X="0.3800" Y="0.4700" />
                <PreSize X="0.7000" Y="0.7500" />
                <Children>
                  <NodeObjectData Name="ItemsListView" ActionTag="-1404036640" FrameEvent="" Tag="298" ObjectIndex="1" PrePositionEnabled="True" TouchEnable="True" ClipAble="True" BackColorAlpha="102" ColorAngle="90.0000" IsBounceEnabled="True" ScrollDirectionType="0" ItemMargin="10" DirectionType="Vertical" HorizontalType="Align_HorizontalCenter" VerticalType="0" ctype="ListViewObjectData">
                    <Position X="16.8000" Y="12.0000" />
                    <Scale ScaleX="1.0000" ScaleY="1.0000" />
                    <AnchorPoint />
                    <CColor A="255" R="255" G="255" B="255" />
                    <Size X="390.0000" Y="280.0000" />
                    <PrePosition X="0.0400" Y="0.0400" />
                    <PreSize X="0.9286" Y="0.9333" />
                    <SingleColor A="255" R="150" G="150" B="255" />
                    <FirstColor A="255" R="150" G="150" B="255" />
                    <EndColor A="255" R="255" G="255" B="255" />
                    <ColorVector ScaleY="1.0000" />
                  </NodeObjectData>
                </Children>
                <FileData Type="Normal" Path="ccz/ui/res/bg3.png" />
              </NodeObjectData>
              <NodeObjectData Name="ItemInfoPanel" ActionTag="872619822" FrameEvent="" Tag="576" ObjectIndex="15" PrePositionEnabled="True" TouchEnable="True" BackColorAlpha="102" ComboBoxIndex="1" ColorAngle="90.0000" Scale9Enable="True" LeftEage="10" RightEage="10" TopEage="10" BottomEage="10" Scale9OriginX="10" Scale9OriginY="10" Scale9Width="79" Scale9Height="101" ctype="PanelObjectData">
                <Position X="516.0000" Y="188.0000" />
                <Scale ScaleX="1.0000" ScaleY="1.0000" />
                <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                <CColor A="255" R="255" G="255" B="255" />
                <Size X="140.0000" Y="300.0000" />
                <PrePosition X="0.8600" Y="0.4700" />
                <PreSize X="0.2333" Y="0.7500" />
                <Children>
                  <NodeObjectData Name="NameLabel" ActionTag="1949336056" FrameEvent="" Tag="697" ObjectIndex="170" PrePositionEnabled="True" LabelText="木制投石车" ctype="TextBMFontObjectData">
                    <Position X="70.0000" Y="282.7800" />
                    <Scale ScaleX="1.0000" ScaleY="1.0000" />
                    <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                    <CColor A="255" R="255" G="255" B="255" />
                    <Size X="133.0000" Y="26.0000" />
                    <PrePosition X="0.5000" Y="0.9426" />
                    <PreSize X="0.0000" Y="0.0000" />
                    <LabelBMFontFile_CNB Type="Normal" Path="ccz/ui/font/ziku_0.fnt" />
                  </NodeObjectData>
                  <NodeObjectData Name="LevelNode" ActionTag="63786185" FrameEvent="" Tag="746" ObjectIndex="2" IconVisible="True" ctype="SingleNodeObjectData">
                    <Position X="30.0000" Y="260.0000" />
                    <Scale ScaleX="0.8000" ScaleY="0.8000" />
                    <AnchorPoint />
                    <CColor A="255" R="255" G="255" B="255" />
                    <Size X="0.0000" Y="0.0000" />
                    <PrePosition X="0.2143" Y="0.8667" />
                    <PreSize X="0.0000" Y="0.0000" />
                    <Children>
                      <NodeObjectData Name="LevelTitleLabel" ActionTag="-1037783863" FrameEvent="" Tag="745" ObjectIndex="171" LabelText="Lv" ctype="TextBMFontObjectData">
                        <Position X="0.0000" Y="0.0000" />
                        <Scale ScaleX="1.0000" ScaleY="1.0000" />
                        <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                        <CColor A="255" R="255" G="255" B="255" />
                        <Size X="30.0000" Y="26.0000" />
                        <PrePosition X="0.0000" Y="0.0000" />
                        <PreSize X="0.0000" Y="0.0000" />
                        <LabelBMFontFile_CNB Type="Normal" Path="ccz/ui/font/ziku_26_0.fnt" />
                      </NodeObjectData>
                      <NodeObjectData Name="LevelLabel" ActionTag="628794869" FrameEvent="" Tag="747" ObjectIndex="172" LabelText="1" ctype="TextBMFontObjectData">
                        <Position X="50.0000" Y="0.0000" />
                        <Scale ScaleX="1.0000" ScaleY="1.0000" />
                        <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                        <CColor A="255" R="255" G="255" B="255" />
                        <Size X="14.0000" Y="26.0000" />
                        <PrePosition X="0.0000" Y="0.0000" />
                        <PreSize X="0.0000" Y="0.0000" />
                        <LabelBMFontFile_CNB Type="Normal" Path="ccz/ui/font/ziku_26_0.fnt" />
                      </NodeObjectData>
                    </Children>
                  </NodeObjectData>
                  <NodeObjectData Name="ExpNode" ActionTag="-1885972065" FrameEvent="" Tag="756" ObjectIndex="5" IconVisible="True" ctype="SingleNodeObjectData">
                    <Position X="30.0000" Y="235.0000" />
                    <Scale ScaleX="0.8000" ScaleY="0.8000" />
                    <AnchorPoint />
                    <CColor A="255" R="255" G="255" B="255" />
                    <Size X="0.0000" Y="0.0000" />
                    <PrePosition X="0.2143" Y="0.7833" />
                    <PreSize X="0.0000" Y="0.0000" />
                    <Children>
                      <NodeObjectData Name="ExpProgress" ActionTag="1270443709" FrameEvent="" Tag="751" ObjectIndex="1" IconVisible="True" ctype="ProjectNodeObjectData">
                        <Position X="80.0000" Y="0.0000" />
                        <Scale ScaleX="0.5500" ScaleY="1.0000" />
                        <AnchorPoint />
                        <CColor A="255" R="255" G="255" B="255" />
                        <Size X="0.0000" Y="0.0000" />
                        <PrePosition X="0.0000" Y="0.0000" />
                        <PreSize X="0.0000" Y="0.0000" />
                        <FileData Type="Normal" Path="ProgressNode.csd" />
                      </NodeObjectData>
                      <NodeObjectData Name="ExpTitleLabel" ActionTag="-1727059910" FrameEvent="" Tag="757" ObjectIndex="176" LabelText="Exp" ctype="TextBMFontObjectData">
                        <Position X="0.0000" Y="0.0000" />
                        <Scale ScaleX="1.0000" ScaleY="1.0000" />
                        <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                        <CColor A="255" R="255" G="255" B="255" />
                        <Size X="44.0000" Y="26.0000" />
                        <PrePosition X="0.0000" Y="0.0000" />
                        <PreSize X="0.0000" Y="0.0000" />
                        <LabelBMFontFile_CNB Type="Normal" Path="ccz/ui/font/ziku_26_0.fnt" />
                      </NodeObjectData>
                    </Children>
                  </NodeObjectData>
                  <NodeObjectData Name="AbilityLabel" ActionTag="326115209" FrameEvent="" Tag="764" ObjectIndex="181" PrePositionEnabled="True" LabelText="装备效果" ctype="TextBMFontObjectData">
                    <Position X="70.0000" Y="204.0000" />
                    <Scale ScaleX="0.8000" ScaleY="1.0000" />
                    <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                    <CColor A="255" R="255" G="255" B="255" />
                    <Size X="107.0000" Y="26.0000" />
                    <PrePosition X="0.5000" Y="0.6800" />
                    <PreSize X="0.0000" Y="0.0000" />
                    <LabelBMFontFile_CNB Type="Normal" Path="ccz/ui/font/ziku_0.fnt" />
                  </NodeObjectData>
                  <NodeObjectData Name="CostLabel" ActionTag="1126521835" FrameEvent="" Tag="763" ObjectIndex="180" PrePositionEnabled="True" LabelText="单价：500" ctype="TextBMFontObjectData">
                    <Position X="70.0000" Y="180.0000" />
                    <Scale ScaleX="0.8000" ScaleY="1.0000" />
                    <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                    <CColor A="255" R="255" G="255" B="255" />
                    <Size X="119.0000" Y="26.0000" />
                    <PrePosition X="0.5000" Y="0.6000" />
                    <PreSize X="0.0000" Y="0.0000" />
                    <LabelBMFontFile_CNB Type="Normal" Path="ccz/ui/font/ziku_0.fnt" />
                  </NodeObjectData>
                  <NodeObjectData Name="NumNode" ActionTag="-864312526" FrameEvent="" Tag="769" ObjectIndex="7" IconVisible="True" PrePositionEnabled="True" ctype="SingleNodeObjectData">
                    <Position X="70.0000" Y="105.0000" />
                    <Scale ScaleX="1.0000" ScaleY="1.0000" />
                    <AnchorPoint />
                    <CColor A="255" R="255" G="255" B="255" />
                    <Size X="0.0000" Y="0.0000" />
                    <PrePosition X="0.5000" Y="0.3500" />
                    <PreSize X="0.0000" Y="0.0000" />
                    <Children>
                      <NodeObjectData Name="NumLabel" ActionTag="-1501792041" FrameEvent="" Tag="768" ObjectIndex="184" PrePositionEnabled="True" LabelText="1" ctype="TextBMFontObjectData">
                        <Position X="0.0000" Y="0.0000" />
                        <Scale ScaleX="1.0000" ScaleY="1.0000" />
                        <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                        <CColor A="255" R="255" G="255" B="255" />
                        <Size X="18.0000" Y="32.0000" />
                        <PrePosition X="0.0000" Y="0.0000" />
                        <PreSize X="0.0000" Y="0.0000" />
                        <LabelBMFontFile_CNB Type="Normal" Path="ccz/ui/font/num_0.fnt" />
                      </NodeObjectData>
                      <NodeObjectData Name="BitmapFontLabel_183" ActionTag="442679517" FrameEvent="" Tag="767" ObjectIndex="183" LabelText="数目" ctype="TextBMFontObjectData">
                        <Position X="0.0000" Y="30.0000" />
                        <Scale ScaleX="1.0000" ScaleY="1.0000" />
                        <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                        <CColor A="255" R="255" G="0" B="0" />
                        <Size X="52.0000" Y="26.0000" />
                        <PrePosition X="0.0000" Y="0.0000" />
                        <PreSize X="0.0000" Y="0.0000" />
                        <LabelBMFontFile_CNB Type="Normal" Path="ccz/ui/font/ziku_0.fnt" />
                      </NodeObjectData>
                      <NodeObjectData Name="SubButton" ActionTag="-1037770783" FrameEvent="" Tag="770" ObjectIndex="11" TouchEnable="True" FontSize="14" ButtonText="" Scale9Enable="True" Scale9Width="73" Scale9Height="45" ctype="ButtonObjectData">
                        <Position X="-40.0000" Y="0.0000" />
                        <Scale ScaleX="1.0000" ScaleY="1.0000" />
                        <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                        <CColor A="255" R="255" G="255" B="255" />
                        <Size X="30.0000" Y="30.0000" />
                        <PrePosition X="0.0000" Y="0.0000" />
                        <PreSize X="0.0000" Y="0.0000" />
                        <TextColor A="255" R="65" G="65" B="70" />
                        <DisabledFileData Type="Normal" Path="ccz/ui/res/button5.png" />
                        <PressedFileData Type="Normal" Path="ccz/ui/res/button5.png" />
                        <NormalFileData Type="Normal" Path="ccz/ui/res/button5.png" />
                      </NodeObjectData>
                      <NodeObjectData Name="AddButton" ActionTag="-103433533" FrameEvent="" Tag="771" ObjectIndex="12" TouchEnable="True" FlipX="True" FontSize="14" ButtonText="" Scale9Enable="True" Scale9Width="73" Scale9Height="45" ctype="ButtonObjectData">
                        <Position X="40.0000" Y="0.0000" />
                        <Scale ScaleX="1.0000" ScaleY="1.0000" />
                        <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                        <CColor A="255" R="255" G="255" B="255" />
                        <Size X="30.0000" Y="30.0000" />
                        <PrePosition X="0.0000" Y="0.0000" />
                        <PreSize X="0.0000" Y="0.0000" />
                        <TextColor A="255" R="65" G="65" B="70" />
                        <DisabledFileData Type="Normal" Path="ccz/ui/res/button5.png" />
                        <PressedFileData Type="Normal" Path="ccz/ui/res/button5.png" />
                        <NormalFileData Type="Normal" Path="ccz/ui/res/button5.png" />
                      </NodeObjectData>
                    </Children>
                  </NodeObjectData>
                  <NodeObjectData Name="TotalCostLabel" ActionTag="1763011915" FrameEvent="" Tag="766" ObjectIndex="182" PrePositionEnabled="True" LabelText="总价：1000" ctype="TextBMFontObjectData">
                    <Position X="70.0000" Y="72.0000" />
                    <Scale ScaleX="0.8000" ScaleY="1.0000" />
                    <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                    <CColor A="255" R="255" G="255" B="255" />
                    <Size X="132.0000" Y="26.0000" />
                    <PrePosition X="0.5000" Y="0.2400" />
                    <PreSize X="0.0000" Y="0.0000" />
                    <LabelBMFontFile_CNB Type="Normal" Path="ccz/ui/font/ziku_0.fnt" />
                  </NodeObjectData>
                  <NodeObjectData Name="ShopButton" ActionTag="-366640683" FrameEvent="" Tag="765" ObjectIndex="10" PrePositionEnabled="True" TouchEnable="True" FontSize="20" ButtonText="购买" Scale9Width="120" Scale9Height="40" ctype="ButtonObjectData">
                    <Position X="70.0000" Y="30.0000" />
                    <Scale ScaleX="0.8000" ScaleY="1.0000" />
                    <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                    <CColor A="255" R="255" G="255" B="255" />
                    <Size X="120.0000" Y="40.0000" />
                    <PrePosition X="0.5000" Y="0.1000" />
                    <PreSize X="0.0000" Y="0.0000" />
                    <FontResource Type="Normal" Path="ccz/ui/font/lishu.ttf" />
                    <TextColor A="255" R="255" G="255" B="255" />
                    <DisabledFileData Type="Normal" Path="ccz/ui/res/button6.png" />
                    <PressedFileData Type="Normal" Path="ccz/ui/res/button2.png" />
                    <NormalFileData Type="Normal" Path="ccz/ui/res/button2.png" />
                  </NodeObjectData>
                </Children>
                <FileData Type="Normal" Path="ccz/ui/res/equip_item_bg1.png" />
                <SingleColor A="255" R="150" G="200" B="255" />
                <FirstColor A="255" R="150" G="200" B="255" />
                <EndColor A="255" R="255" G="255" B="255" />
                <ColorVector ScaleY="1.0000" />
              </NodeObjectData>
              <NodeObjectData Name="CloseButton" ActionTag="989172079" FrameEvent="" Tag="696" ObjectIndex="9" TouchEnable="True" FontSize="14" ButtonText="" Scale9Width="71" Scale9Height="71" ctype="ButtonObjectData">
                <Position X="569.9165" Y="373.7694" />
                <Scale ScaleX="0.8000" ScaleY="0.8000" />
                <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                <CColor A="255" R="255" G="255" B="255" />
                <Size X="71.0000" Y="71.0000" />
                <PrePosition X="0.9499" Y="0.9344" />
                <PreSize X="0.0000" Y="0.0000" />
                <TextColor A="255" R="65" G="65" B="70" />
                <DisabledFileData Type="Normal" Path="ccz/ui/res/button3.png" />
                <PressedFileData Type="Normal" Path="ccz/ui/res/button3.png" />
                <NormalFileData Type="Normal" Path="ccz/ui/res/button3.png" />
              </NodeObjectData>
              <NodeObjectData Name="BitmapFontLabel_185" ActionTag="-1915920878" FrameEvent="" Tag="393" ObjectIndex="185" LabelText="金钱：" ctype="TextBMFontObjectData">
                <Position X="398.5000" Y="365.0195" />
                <Scale ScaleX="1.0000" ScaleY="1.0000" />
                <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                <CColor A="255" R="217" G="192" B="39" />
                <Size X="78.0000" Y="26.0000" />
                <PrePosition X="0.6642" Y="0.9125" />
                <PreSize X="0.0000" Y="0.0000" />
                <LabelBMFontFile_CNB Type="Normal" Path="ccz/ui/font/ziku_26_0.fnt" />
              </NodeObjectData>
              <NodeObjectData Name="MoneyLabel" ActionTag="-985508980" FrameEvent="" Tag="394" ObjectIndex="186" LabelText="999999" ctype="TextBMFontObjectData">
                <Position X="481.5000" Y="365.0195" />
                <Scale ScaleX="1.0000" ScaleY="1.0000" />
                <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                <CColor A="255" R="255" G="255" B="255" />
                <Size X="81.0000" Y="26.0000" />
                <PrePosition X="0.8025" Y="0.9125" />
                <PreSize X="0.0000" Y="0.0000" />
                <LabelBMFontFile_CNB Type="Normal" Path="ccz/ui/font/ziku_26_0.fnt" />
              </NodeObjectData>
            </Children>
            <FileData Type="Normal" Path="ccz/ui/res/dialog_bg2.png" />
            <SingleColor A="255" R="150" G="200" B="255" />
            <FirstColor A="255" R="150" G="200" B="255" />
            <EndColor A="255" R="255" G="255" B="255" />
            <ColorVector ScaleY="1.0000" />
          </NodeObjectData>
        </Children>
      </ObjectData>
    </Content>
  </Content>
</GameProjectFile>