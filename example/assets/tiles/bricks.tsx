<?xml version="1.0" encoding="UTF-8"?>
<tileset version="1.8" tiledversion="1.8.1" name="bricks" tilewidth="8" tileheight="8" tilecount="8" columns="4">
 <image source="../images/brick_tiles.png" width="32" height="16"/>
 <tile id="0" type="brick">
  <properties>
   <property name="brickHealth" type="int" value="1"/>
   <property name="name" value="brick"/>
  </properties>
  <objectgroup draworder="index">
   <object id="1" x="0" y="0" width="8" height="8"/>
  </objectgroup>
 </tile>
 <tile id="1" type="heavy_brick">
  <properties>
   <property name="brickHealth" type="int" value="1000"/>
  </properties>
  <objectgroup draworder="index">
   <object id="1" x="0" y="0" width="8" height="8"/>
  </objectgroup>
 </tile>
 <tile id="2" type="ice"/>
 <tile id="3" type="tree">
  <objectgroup draworder="index" id="2">
   <object id="3" x="0" y="0" width="8" height="8"/>
  </objectgroup>
 </tile>
 <tile id="4" type="skip">
  <objectgroup draworder="index">
   <object id="1" x="0" y="0" width="8" height="8"/>
  </objectgroup>
 </tile>
 <tile id="5" type="skip">
  <objectgroup draworder="index">
   <object id="1" x="0" y="0" width="8" height="8"/>
  </objectgroup>
 </tile>
 <tile id="6" type="water">
  <properties>
   <property name="allowBullet" type="bool" value="true"/>
  </properties>
  <objectgroup draworder="index">
   <object id="1" x="0" y="0" width="8" height="8"/>
  </objectgroup>
  <animation>
   <frame tileid="4" duration="500"/>
   <frame tileid="5" duration="500"/>
   <frame tileid="6" duration="500"/>
  </animation>
 </tile>
</tileset>
