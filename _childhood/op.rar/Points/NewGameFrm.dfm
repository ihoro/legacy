object NewGame: TNewGame
  Left = 192
  Top = 107
  BorderStyle = bsToolWindow
  Caption = '����� ����'
  ClientHeight = 180
  ClientWidth = 196
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object RadioGroup1: TRadioGroup
    Left = 8
    Top = 8
    Width = 105
    Height = 65
    Caption = '���������:'
    TabOrder = 2
  end
  object Button1: TButton
    Left = 21
    Top = 152
    Width = 73
    Height = 25
    Caption = 'OK'
    TabOrder = 0
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 101
    Top = 152
    Width = 73
    Height = 25
    Caption = '������'
    TabOrder = 1
    OnClick = Button2Click
  end
  object RadioButton1: TRadioButton
    Left = 24
    Top = 24
    Width = 49
    Height = 17
    Caption = '�����'
    Checked = True
    TabOrder = 3
    TabStop = True
  end
  object RadioButton2: TRadioButton
    Left = 24
    Top = 48
    Width = 81
    Height = 17
    Caption = '���������'
    Enabled = False
    TabOrder = 4
  end
  object GroupBox1: TGroupBox
    Left = 120
    Top = 8
    Width = 73
    Height = 65
    Caption = '����:'
    TabOrder = 5
    OnMouseDown = imgEnemyMouseDown
    object imgEnemy: TImage
      Left = 30
      Top = 26
      Width = 12
      Height = 12
      Stretch = True
      OnMouseDown = imgEnemyMouseDown
    end
  end
  object GroupBox2: TGroupBox
    Left = 120
    Top = 80
    Width = 73
    Height = 65
    Caption = '��� ����:'
    TabOrder = 6
    OnMouseDown = imgYouMouseDown
    object imgYou: TImage
      Left = 30
      Top = 26
      Width = 12
      Height = 12
      Stretch = True
      OnMouseDown = imgYouMouseDown
    end
  end
  object GroupBox3: TGroupBox
    Left = 8
    Top = 80
    Width = 105
    Height = 65
    Caption = '������� ����:'
    TabOrder = 7
    object Label1: TLabel
      Left = 20
      Top = 20
      Width = 10
      Height = 13
      Caption = 'X:'
    end
    object Label2: TLabel
      Left = 20
      Top = 44
      Width = 10
      Height = 13
      Caption = 'Y:'
    end
    object SpinEdit1: TSpinEdit
      Left = 36
      Top = 16
      Width = 49
      Height = 22
      MaxValue = 100
      MinValue = 10
      TabOrder = 0
      Value = 10
    end
    object SpinEdit2: TSpinEdit
      Left = 36
      Top = 40
      Width = 49
      Height = 22
      MaxValue = 100
      MinValue = 10
      TabOrder = 1
      Value = 10
    end
  end
  object im: TImageList
    Height = 12
    Width = 12
    Left = 456
    Bitmap = {
      494C01010A000E0004000C000C00FFFFFFFFFF10FFFFFFFFFFFFFFFF424D3600
      0000000000003600000028000000300000003000000001002000000000000024
      0000000000000000000000000000000000000B0206402F0714404B1226405913
      2E405D0E3140650A37406F083F408E1F6140AF3582409C177440830D65401A03
      154002080B4005213140093A54400A4362400A4261400A4464400B4A6C40106B
      9D40158ED040106EA2400D59834003121A4003002540170145402D065F403906
      69403D046D40450274404F017C406F0D9B40951BB4407F08AA4063039E400A00
      4640030903400E290F40174518401B511C401B501C401C531E401E5920402B81
      2D4039AB3C402D862F40246C2640071507400100024018060E4034071B404911
      2B40632E4F406F315A406F1B5040730D4E407A0958407F0D6240500842400400
      03400102024003131B4006243540083852400D5983400F6492400D567E400C50
      75400C5176400D578040083750400103044000001540090139401B0150402B05
      664043168B404F1895404F0A8C4053038A405A0293405F039C4031017F400000
      1A4001020140081708400F2C104017441840246C264028782A40236825402060
      22402162234023692540164217400103014000000040060105401F0313404424
      3C406C55754081699140774073406C1252406C0D5640570A4A401B031A400000
      0040000000400104054004151F400A415F40127DB840179CE4401171A6400C4F
      73400B4A6D40093B574003131B400000004000000040010021400D0043402710
      79404C36AB406149BE405724A9404C068E404C039140380287400A004F400000
      00400000004002050240091A09401A4E1B40339836403FBC42402E893040205F
      22401E5A20401848194008170840000000400000004000000040060207401800
      10403D1D3B405A355F405B2156404F083F403908334016021540000000400000
      0040000000400000004001050740030F1640083852400E5C87400B4D71400835
      4E4006283A40030F164000000040000000400000004000000040010028400900
      3D40210B78403A1B99403B0E914030017C401E016F4008004640000000400000
      00400000004000000040020602400612064017441840256F27401F5D21401641
      1740103011400612064000000040000000400000004000000040000000400100
      0240080109401E061F4022062340100310400400044000000040000000400000
      004000000040000000400000004001020240010609400417214004192440020B
      1040010304400000004000000040000000400000004000000040000000400000
      154001002D400C0156400E015C4005003D4000001E4000000040000000400000
      00400000004000000040000000400102014003080340091B09400A1E0B40050E
      0540010301400000004000000040000000400000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000505230002400C00001204C00263AC0000000000066204C000000
      263A010000044C00662000000000000000000000000000000000000000000000
      000030004C000000263A00000000000002000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000201
      0100150D070042291600452B1700180F08000201010000000000000000000000
      000000000000000000000000000001010200060616001212470013134A000707
      1A00010102000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000120B06003622
      1200603C20007D4E2A0089552E007E4E2A0053341C00180F0800000000000000
      00000000000000000000050513000F0F3A001A1A670022228500252592002222
      87001616580007071A0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000110B0600472C1800965D
      3200B36F3C00935B310083522C00925B31008F593000694123001A1009000000
      0000000000000505120013134B002828A0003030BF0027279D0023238B002727
      9B00262698001C1C700007071B00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000302010021140B009C613400CE96
      6B00CE966B00AE6C3A0081502B0084522C008D582F008F5930004E301A000201
      010001010300090923002A2AA7006161D8006161D8002F2FBA0023238A002323
      8D00262697002626980015155300010102000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000E09050051321B00C4804D00D6A7
      8400D19D7500AB6A3900754927008C572F00A164360089552E007E4E2A00150D
      070004040E00161657004141D0007C7CDE006C6CDA002E2EB70020207D002525
      95002B2BAB002525920022228700060616000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000020140B00603C2000C0784200CE96
      6B00C58351008D582F00623D2100AA6A3900D29F7800BA733E0087542D003E27
      1500090922001A1A67003636CD006161D8004646D100262697001A1A68002D2D
      B5006F6FDB003232C70024249000111142000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000001D120A004129160083522C009E62
      350084522C00684123005C391F00AD6C3A00D9AE8D00C17A44007E4E2A003E27
      150008081E001212450023238B002A2AA80023238D001C1C6F00191962002E2E
      B8008686E1003737CD0022228700111142000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000009060300291A0E00452B17005132
      1B0050321B0053341C0059371E0081502B00AB6A390086532D006C432400150D
      070003030A000B0B2B0013134A0016165700161655001616580018185F002323
      8A002E2EB70024248F001D1D7300060616000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000002010100170E08002C1C0F00442A
      17006C432400784B280068412300603C2000623D210069412300422916000302
      010001010200060618000C0C2E00121248001D1D7300202080001C1C6F001A1A
      67001A1A68001C1C700012124700010103000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000050302001A1009004E30
      1A00985F3300BC753F0089552E005F3B20005A381E00482D1800170E08000000
      0000000000000202050007071B00151553002929A2003232C800252592001A1A
      65001818600014144D0006061800000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000006040200120B
      0600442A17006F4525005D3A1F0041291600301E1000120B0600000000000000
      000000000000000000000202060005051300121248001E1E7700191963001212
      45000D0D33000505130000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000201
      0100080503001B1109001E130A000E0905000302010000000000000000000000
      0000000000000000000000000000010102000202080008081D00080820000404
      0E00010103000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000202
      0100151007004232160045351700181208000202010000000000000000000000
      000000000000000000000000000002020100141507003E421600414517001618
      0800020201000000000000000000000000000000000000000000000000000102
      020007141500163E420017414500081618000102020000000000000000000000
      0000000000000000000000000000010101000B0B110022223700232339000D0D
      1400010101000000000000000000000000000000000000000000120E06003629
      1200604920007D602A0089692E007E602A0053401C0018120800000000000000
      0000000000000000000011120600333612005A602000757D2A0080892E00767E
      2A004E531C001618080000000000000000000000000000000000061112001233
      3600205A60002A757D002E8089002A767E001C4E530008161800000000000000
      000000000000000000000A0A0F001C1C2D00313150003F3F6800454572004040
      69002A2A45000D0D1400000000000000000000000000110D0600473618009673
      3200B3893C009370310083642C00927031008F6D3000695023001A1409000000
      00000000000010110600434718008D963200A8B33C008A9331007B832C008992
      3100868F300062692300181A090000000000000000000610110018434700328D
      96003CA8B300318A93002C7B83003189920030868F002362690009181A000000
      00000000000009090E0024243B004C4C7D005A5A95004A4A7A0042426D004949
      790048487700353557000D0D1500000000000302010021190B009C773400CEAB
      6B00CEAB6B00AE853A0081632B0084652C008D6C2F008F6D30004E3C1A000202
      0100030301001F210B00929C3400C5CE6B00C5CE6B00A3AE3A0079812B007C84
      2C00848D2F00868F3000494E1A0002020100010303000B1F210034929C006BC5
      CE006BC5CE003AA3AE002B7981002C7C84002F848D0030868F001A494E000102
      02000202020011111B004F4F82008484B5008484B5005858910041416B004343
      6E00474775004848770028284100010101000E0B0500513E1B00C49A4D00D6B9
      8400D1B17500AB833900755927008C6B2F00A17B360089692E007E602A001510
      07000D0E05004C511B00B9C44D00CED68400C8D17500A0AB39006E752700838C
      2F0097A1360080892E00767E2A0014150700050D0E001B4C51004DB9C40084CE
      D60075C8D10039A0AB00276E75002F838C003697A1002E8089002A767E000714
      150007070B00292943006B6BA6009999C1008D8DBA0056568E003B3B61004646
      74005151860045457200404069000B0B110020190B0060492000C0944200CEAB
      6B00C59C51008D6C2F00624B2100AA823900D2B27800BA8E3E0087672D003E30
      15001E200B005A602000B4C04200C5CE6B00BAC55100848D2F005C6221009FAA
      3900CAD27800AEBA3E007F872D003A3E15000B1E2000205A600042B4C0006BC5
      CE0051BAC5002F848D00215C6200399FAA0078CAD2003EAEBA002D7F8700153A
      3E0010101A00313150006262A0008484B5006F6FA80047477500313151005555
      8D008F8FBB005E5E9B00444470001F1F33001D160A004132160083642C009E79
      350084652C00685023005C461F00AD843A00D9BE8D00C19544007E602A003E30
      15001B1D0A003D4116007B832C00949E35007C842C0062682300565C1F00A2AD
      3A00D2D98D00B5C14400767E2A003A3E15000A1B1D00163D41002C7B83003594
      9E002C7C8400236268001F565C003AA2AD008DD2D90044B5C1002A767E00153A
      3E000F0F18002121360042426D004F4F830043436E00343456002E2E4C005757
      9000A1A1C6006363A100404069001F1F330009070300291F0E0045351700513E
      1B00503D1B0053401C0059441E0081632B00AB83390086672D006C5324001510
      07000809030026290E00414517004C511B004B501B004E531C0053591E007981
      2B00A0AB39007E862D00656C240014150700030809000E262900174145001B4C
      51001B4B50001C4E53001E5359002B79810039A0AB002D7E860024656C000714
      150005050700151522002323390029294300282842002A2A45002D2D4A004141
      6B0056568E0043436F0037375A000B0B110002020100171208002C220F004434
      17006C532400785C28006850230060492000624B210069502300423216000302
      01000202010016170800292C0F0040441700656C240070782800626823005A60
      20005C622100626923003E4216000303010001020200081617000F292C001740
      440024656C002870780023626800205A6000215C620023626900163E42000103
      0300010101000C0C1300161624002222380037375A003D3D6400343456003131
      50003131510035355700222237000202020000000000050402001A1409004E3C
      1A0098743300BC903F0089692E005F4920005A451E0048371800171208000000
      00000000000005050200181A0900494E1A008E983300B0BC3F0080892E00595F
      2000545A1E00434818001617080000000000000000000205050009181A001A49
      4E00338E98003FB0BC002E80890020595F001E545A0018434800081617000000
      000000000000030304000D0D1500282841004C4C7E005E5E9C00454572003030
      4F002E2E4B0025253C000C0C130000000000000000000000000006050200120E
      0600443417006F5525005D471F004132160030251000120E0600000000000000
      00000000000000000000060602001112060040441700686F2500575D1F003D41
      16002D3010001112060000000000000000000000000000000000020606000611
      12001740440025686F001F575D00163D4100102D300006111200000000000000
      00000000000000000000040405000A0A0F002222380038385C002F2F4D002121
      3600191928000A0A0F0000000000000000000000000000000000000000000202
      0100080603001B1509001E170A000E0B05000302010000000000000000000000
      00000000000000000000000000000202010008080300191B09001C1E0A000D0E
      0500030301000000000000000000000000000000000000000000000000000102
      02000308080009191B000A1C1E00050D0E000103030000000000000000000000
      000000000000000000000000000001010100040406000E0E1600101019000707
      0B00020202000000000000000000000000000000000000000000000000000300
      03001A0311005207370055073A001E0315000200020000000000000000000000
      00000000000000000000000000000102020003121A0008375000093A54000314
      1D00010202000000000000000000000000000000000000000000000000000000
      1A000A003F0033017400360177000C0046000000150000000000000000000000
      0000000000000000000000000000010201000715070016421700174518000818
      080001020100000000000000000000000000000000000000000016020D004602
      25007A0742009A0D5900A70F67009B0E6500660846001F021600000000000000
      00000000000000000000030F1600072D42000C5075000F6797001171A6000F68
      99000A44640003141D0000000000000000000000000000000000080037002900
      5E005A017F007D0394008C04A0007E049E00460183000D004800000000000000
      000000000000000000000612060012361300206022002A7D2C002E8930002A7E
      2C001C531E000818080000000000000000000000000015010A00540A28009B2D
      5C00B8377000A91B5F00A40B5B00B2106B00AF0F7100820A5900200316000000
      000000000000020E1400093B5600127CB6001694D900127AB300106D9F001279
      B1001176AD000D57800004151F00000000000000000007003000350262007E16
      9700A01DA7008E0A9900880396009905A3009504A700620294000D0048000000
      0000000000000611060018471900329635003CB33F00319334002C832E003192
      3400308F330023692500091A090000000000040002002D000F00963A5C00D465
      9000D8619300B4346D009C105500A40C5E00B10C6D00AF0F7300610843000300
      030001030400041B28001382BE004BB4ED004BB4ED001590D300106B9D00106D
      A0001175AB001176AD000A415F00010202000000150016003B00781F9700C445
      BE00C941C0009C1BA4007F059100880398009803A4009504A900410180000000
      1A00010301000B210C00349C37006BCE6E006BCE6E003AAE3D002B812D002C84
      2E002F8D3200308F33001A4E1B00010201001102080057162C00B45D7A00DF7B
      A000DA6D9A00AE376C00900D4C00A4176200B71F7700AD0970009B0E6D001A03
      1200020B10000A43620027A5EA006AC1F00058BAEF00158ED0000E618E001174
      AA001385C3001171A6000F68990003121A0005002B00380867009C3DAE00D35B
      C800CC4DC400941DA4007203890088089C009F0DAC009302A7007E04A4000A00
      4100050E05001B511C004DC4500084D6860075D1780039AB3C00277529002F8C
      320036A139002E8930002A7E2C000715070025051100611F3400A95A7400C96F
      9000BD598200962758007E054000B3307600EB60B300CA2E9200A80D77004B07
      3800041A26000C5075001AA0E9004BB4ED002CA7EA001175AB000C517600158D
      CE005BBBEF00169AE2001070A40008334B0010003F00410D70008E3AAA00B64F
      BE00A739B400781293005E007D009A18AB00E340D400B716BF008D03AC002D01
      75000B200C002060220042C045006BCE6E0051C554002F8D32002162230039AA
      3C0078D27A003EBA41002D872F00153E160022051000470F200079354C009142
      5F00852B50007813400075063E00AF377900F472C200CB3A9A009C0C72004B07
      3A000418230008354E00106D9F001382BF00106DA0000D567E000B4C6F00158F
      D20075C6F2001CA1E9000F68990008334B000E003D002A045700591B89007325
      990065148C0058067D0055017B00951DAD00EF52DD00B81FC4007F03A8002D01
      77000A1D0B00164117002C832E00359E38002C842E00236825001F5C21003AAD
      3D008DD98F0044C147002A7E2C00153E16000B0206002F0714004B1226005913
      2E005D0E3100650A37006F083F008E1F6100AF3582009C177400830D65001A03
      150002080B0005213100093A54000A4362000A4261000A4464000B4A6C00106B
      9D00158ED000106EA2000D59830003121A0003002500170145002D065F003906
      69003D046D00450274004F017C006F0D9B00951BB4007F08AA0063039E000A00
      4600030903000E290F00174518001B511C001B501C001C531E001E5920002B81
      2D0039AB3C002D862F00246C2600071507000100020018060E0034071B004911
      2B00632E4F006F315A006F1B5000730D4E007A0958007F0D6200500842000400
      03000102020003131B0006243500083852000D5983000F6492000D567E000C50
      75000C5176000D578000083750000103040000001500090139001B0150002B05
      660043168B004F1895004F0A8C0053038A005A0293005F039C0031017F000000
      1A0001020100081708000F2C100017441800246C260028782A00236825002060
      22002162230023692500164217000103010000000000060105001F0313004424
      3C006C55750081699100774073006C1252006C0D5600570A4A001B031A000000
      0000000000000104050004151F000A415F00127DB800179CE4001171A6000C4F
      73000B4A6D00093B570003131B000000000000000000010021000D0043002710
      79004C36AB006149BE005724A9004C068E004C039100380287000A004F000000
      00000000000002050200091A09001A4E1B00339836003FBC42002E893000205F
      22001E5A20001848190008170800000000000000000000000000060207001800
      10003D1D3B005A355F005B2156004F083F003908330016021500000000000000
      0000000000000000000001050700030F1600083852000E5C87000B4D71000835
      4E0006283A00030F160000000000000000000000000000000000010028000900
      3D00210B78003A1B99003B0E910030017C001E016F0008004600000000000000
      00000000000000000000020602000612060017441800256F27001F5D21001641
      1700103011000612060000000000000000000000000000000000000000000100
      0200080109001E061F0022062300100310000400040000000000000000000000
      000000000000000000000000000001020200010609000417210004192400020B
      1000010304000000000000000000000000000000000000000000000000000000
      150001002D000C0156000E015C0005003D0000001E0000000000000000000000
      00000000000000000000000000000102010003080300091B09000A1E0B00050E
      050001030100000000000000000000000000424D3E000000000000003E000000
      2800000030000000300000000100010000000000800100000000000000000000
      000000000000000000000000FFFFFF0000000000000000000000000000000000
      33001602150000004F083F00390800005F005B21560000003D1D3B005A350000
      070018001000000000000000060200001B40000000000000091A09401A4E0000
      00400205024000000000004000000000000000004F4000000000004038020000
      000000068E400000000000405724000000000036AB4000000000000000000000
      00000000000000000000000000000000000000015C000000000000000C010000
      0000000015000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000}
  end
  object pmBalls: TPopupMenu
    AutoHotkeys = maManual
    Images = Main.ilBalls
    Left = 168
    object pmiColor1: TMenuItem
      Caption = 'Color&1'
      ImageIndex = 0
      OnClick = pmiColor1Click
    end
    object pmiColor2: TMenuItem
      Caption = 'Color&2'
      ImageIndex = 1
      OnClick = pmiColor2Click
    end
    object pmiColor3: TMenuItem
      Caption = 'Color&3'
      ImageIndex = 2
      OnClick = pmiColor3Click
    end
    object pmiColor4: TMenuItem
      Caption = 'Color&4'
      ImageIndex = 3
      OnClick = pmiColor4Click
    end
    object pmiColor5: TMenuItem
      Caption = 'Color&5'
      ImageIndex = 4
      OnClick = pmiColor5Click
    end
    object pmiColor6: TMenuItem
      Caption = 'Color&6'
      ImageIndex = 5
      OnClick = pmiColor6Click
    end
    object pmiColor7: TMenuItem
      Caption = 'Color&7'
      ImageIndex = 6
      OnClick = pmiColor7Click
    end
    object pmiColor8: TMenuItem
      Caption = 'Color&8'
      ImageIndex = 7
      OnClick = pmiColor8Click
    end
    object pmiColor9: TMenuItem
      Caption = 'Color&9'
      ImageIndex = 8
      OnClick = pmiColor9Click
    end
    object pmiColor10: TMenuItem
      Caption = 'Color1&0'
      ImageIndex = 9
      OnClick = pmiColor10Click
    end
  end
end