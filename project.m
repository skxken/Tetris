function project(cmd)
BoxX = 10 + 2;                                
BOXY = 18 + 1;                                
ClkV=[0;0;86400;3600;60;1];
      % initialize GUI   
      % initialize figure window
        fig = figure('Name','Tetris','Numbertitle','off','Menubar','none',...
           'Color',[0.8 0.8 0.8],'Resize','off',...
         'Position',[150,150,220,400]);
        set(fig,'windowkeypressfcn',@keypressfcn);
        axes('Units','normalized','Position', [.02 .07 .96 .92],'Visible','off',...
           'DrawMode','fast','NextPlot','replace','XLim',[1,BoxX-1],'YLim',[1,BOXY]);
      set(line([1,BoxX-1,BoxX-1,1,1],[1,1,BOXY,BOXY,1]),'Color',[0,0,0]);
        
       % make button and handles
        HSCORE  = uicontrol('Units','normalized','Position',[0.05,0.01,.5,.05],...
           'Style','text','HorizontalAlignment','Left','FontWeight','bold');
      
        % make menu
      tmp1 = uimenu('Label','&Menu');
        HPAUSE2 = uimenu(tmp1,'Label','&Pause or Countinue','Callback',@pause1);
        HSTOP1 = uimenu(tmp1,'Label','&Stop','Callback',@stop1);
        HRESTART1= uimenu(tmp1,'Label','&Restart','Callback',@restart);
       HDIF1(1) = uimenu(tmp1,'Label','&Beginner','MenuSelectedFcn',@speed1);
        HDIF1(2) = uimenu(tmp1,'Label','&Intermediate','MenuSelectedFcn',@speed2);
       HDIF1(3) = uimenu(tmp1,'Label','&Expert','MenuSelectedFcn',@speed3);     
       TIMESTEP = 0.9;        % beginner difficulty mode
       HEXIT(3) = uimenu(tmp1,'Label','&Exit','MenuSelectedFcn',@exit);
        SNDFLAG = 1;            % sound effects initially enabled (0 for disabled)
        HMODE = uicontrol('Units','normalized','Position',[0.1,0.7,.8,.1],...
         'Style','text','FontSize',14);
        set(HMODE,'Visible','off');
      %GameSounds;
   score=0;
   set(HSCORE,'String','Score: 0');
    figure(fig)
  FrameStart = clock*ClkV;
  pausel=0;%现在是否暂停
  stop=0;%现在是否结束
  posX=0;%标记点的x坐标
  posY=0;%标记点的y坐标
  modelcolor=0;%方块的颜色
  detailX=zeros(1,4);%各个方块的相对坐标
  detailY=zeros(1,4);%各个方块的相对坐标
  type=0;%方块的类型
  map=zeros(10,19);%地图
  globalpatch=0;%进行一次全局更新
  needtoput=1;%需要放新的方块
  plot(1,1)
  axis off
  axis([0 10 0 18])
  for i1=1:10
      for j1=1:18
   x = [i1-1 i1 i1 i1-1];
   y = [j1-1 j1-1 j1 j1];
   patch(x,y,'white')
      end
  end
  do;

function do
  while(true)
  if pausel==1
      pause(1);
  else
      if stop==1
          break;
      end
    if needtoput==1
        for i3=17:18
            for j3=1:10
                if map(j3,i3)~=0
                    stop1;
                break;
                end
            end
        end
        needtoput=0;
        modelcolor=randi([1 4]);
        type=randi([1 6]);
        switch type
            case 1
                detailX=[0,0,1,1];
                detailY=[0,-1,-1,0];
            case 2
                detailX=[-1,0,1,0];
                detailY=[0,0,0,1];
            case 3
                detailX=[0,-1,0,1];
                detailY=[0,0,1,1];
            case 4
                detailX=[0,1,-1,-1];
                detailY=[0,0,0,1];
            case 5
                detailX=[-1,0,1,1];
                detailY=[0,0,0,1];
            case 6
                detailX=[-1,0,1,2];
                detailY=[0,0,0,0];
        end
        posX=5;
        if type==1 || type==6
            posY=18;
        else
            posY=17;
        end
    end
    if clock*ClkV>=FrameStart+TIMESTEP
        FrameStart=clock*ClkV;
        k=0;
        for i=1:4
            if posY+detailY(i)==1||map(posX+detailX(i),posY+detailY(i)-1)~=0
                k=1;
            end
        end
        if k==0
            posY=posY-1;
        elseif posY<17
            needtoput=1;
            check;
        else
            stop1;
        end
    end
    if globalpatch==0
    for i=1:4
        map(posX+detailX(i),posY+detailY(i))=modelcolor;
    end
    for i=max(1,posX-2):min(10,posX+3)
        for j=max(1,posY-2):min(18,posY+2)
             x = [i-1 i i i-1];
             y = [j-1 j-1 j j];
             if map(i,j)==0
                patch(x,y,'white')
             elseif map(i,j)==1
                patch(x,y,'red')
             elseif map(i,j)==2
                patch(x,y,'yellow')
             elseif map(i,j)==3
                patch(x,y,'blue')
             else
                 patch(x,y,'green')
             end
        end
    end
    if needtoput==0
        for i=1:4
            map(posX+detailX(i),posY+detailY(i))=0;
        end
    end
    else
        globalpatch=0;
    for i=1:10
        for j=1:18
             x = [i-1 i i i-1];
             y = [j-1 j-1 j j];
             if map(i,j)==0
                patch(x,y,'white')
             elseif map(i,j)==1
                patch(x,y,'red')
             elseif map(i,j)==2
                patch(x,y,'yellow')
             elseif map(i,j)==3
                patch(x,y,'blue')
             else
                 patch(x,y,'green')
             end
        end
    end
    end
    drawnow;
  end
  end
end

    function keypressfcn(h,evt)
        switch get(fig,'CurrentCharacter')
            case {'a','A'}
                k=0;
                for i=1:4
                    if posX+detailX(i)==1||map(posX+detailX(i)-1,posY+detailY(i))~=0
                        k=1;
                    end
                end
                if k==0
                    posX=posX-1;
                end
            case {'d','D'}
                k=0;
                for i=1:4
                    if posX+detailX(i)==10||map(posX+detailX(i)+1,posY+detailY(i))~=0
                        k=1;
                    end
                end
                if k==0
                    posX=posX+1;
                end
             case {'s','S'}
                 while(true)
                    k=0;
                    for i=1:4
                        if posY+detailY(i)==1||map(posX+detailX(i),posY+detailY(i)-1)~=0
                             k=1;
                        end
                    end
                    if k==0
                        posY=posY-1;
                    else
                        for i=max(1,posX-2):min(10,posX+2)
                            for j=1:18
                            x = [i-1 i i i-1];
                            y = [j-1 j-1 j j];
                            if map(i,j)==0
                                patch(x,y,'white')
                            elseif map(i,j)==1
                                patch(x,y,'red')
                            elseif map(i,j)==2
                                patch(x,y,'yellow')
                             elseif map(i,j)==3
                             patch(x,y,'blue')
                            else
                                patch(x,y,'green')
                            end
                            end
                        end
                        
                        break;
                     end
                 end
                for i=1:4
                    map(posX+detailX(i),posY+detailY(i))=modelcolor;
                end
                needtoput=1;
                posX=5;
                posY=17;
                check
            case{'w','W'}
                if type==2
                    if map(posX,posY-1)==0
                        type=7;
                        detailX=[0,0,0,1];
                        detailY=[1,0,-1,0];
                    end
                elseif type==3
                    if map(posX+1,posY)==0&&map(posX+1,posY-1)==0
                        type=10;
                        detailX=[0,0,1,1];
                        detailY=[1,0,0,-1];
                    end
                elseif type==4
                    if map(posX,posY+1)==0&&map(posX,posY-1)==0&&map(posX+1,posY+1)==0
                        type=11;
                        detailX=[0,0,0,1];
                        detailY=[1,0,-1,1];
                    end
                elseif type==5
                    if map(posX,posY+1)==0&&map(posX,posY-1)==0&&map(posX+1,posY-1)==0
                        type=14;
                        detailX=[0,0,0,1];
                        detailY=[1,0,-1,-1];
                    end
                elseif type==6
                     if map(posX,posY+1)==0&&map(posX,posY-1)==0&&map(posX,posY-2)==0
                        type=17;
                        detailX=[0,0,0,0];
                        detailY=[1,0,-1,-2];
                    end                   
                elseif type==7
                     if map(posX-1,posY)==0&&map(posX,posY-1)==0&&map(posX+1,posY)==0
                        type=8;
                        detailX=[-1,0,0,1];
                        detailY=[0,0,-1,0];
                     end
                elseif type==8
                     if map(posX-1,posY)==0&&map(posX,posY-1)==0&&map(posX,posY+1)==0
                        type=9;
                        detailX=[-1,0,0,0];
                        detailY=[0,0,-1,1];
                     end
                elseif type==9
                     if map(posX-1,posY)==0&&map(posX+1,posY)==0&&map(posX,posY+1)==0
                        type=2;
                        detailX=[-1,0,1,0];
                        detailY=[0,0,0,1];
                     end
                elseif type==10
                     if map(posX-1,posY)==0&&map(posX+1,posY+1)==0&&map(posX,posY+1)==0
                        type=3;
                        detailX=[-1,0,1,0];
                        detailY=[0,0,1,1];
                    end             
                elseif type==11
                     if map(posX-1,posY)==0&&map(posX+1,posY)==0&&map(posX+1,posY-1)==0
                        type=12;
                        detailX=[-1,0,1,1];
                        detailY=[0,0,0,-1];
                     end           
                elseif type==12
                     if map(posX-1,posY-1)==0&&map(posX,posY+1)==0&&map(posX,posY-1)==0
                        type=13;
                        detailX=[-1,0,0,0];
                        detailY=[-1,0,1,-1];
                     end    
                elseif type==13
                     if map(posX-1,posY+1)==0&&map(posX-1,posY)==0&&map(posX+1,posY)==0
                        type=4;
                        detailX=[-1,0,-1,1];
                        detailY=[1,0,0,0];
                     end      
                elseif type==14
                     if map(posX-1,posY-1)==0&&map(posX-1,posY)==0&&map(posX+1,posY)==0
                        type=15;
                        detailX=[-1,0,-1,1];
                        detailY=[-1,0,0,0];
                     end
                elseif type==15
                     if map(posX-1,posY+1)==0&&map(posX,posY+1)==0&&map(posX,posY-1)==0
                        type=16;
                        detailX=[-1,0,0,0];
                        detailY=[1,0,1,-1];
                     end   
                elseif type==16
                     if map(posX-1,posY)==0&&map(posX+1,posY+1)==0&&map(posX+1,posY)==0
                        type=5;
                        detailX=[-1,0,1,1];
                        detailY=[0,0,1,0];
                     end   
                elseif type==17
                     if map(posX-1,posY)==0&&map(posX+1,posY)==0&&map(posX+2,posY)==0
                        type=6;
                        detailX=[-1,0,1,2];
                        detailY=[0,0,0,0];
                    end                     
                end                     
        end

    end
    function speed1(h,evt)
        TIMESTEP=0.9;
    end
    function speed2(h,evt)
        TIMESTEP=0.6;
    end
    function speed3(h,evt)
        TIMESTEP=0.3;
    end
    function stop1(h,evt)
        stop=1;
        set(HMODE,'String','GAME OVER','Visible','on');
    end
    function pause1(h,evt)
        if pausel==1
            set(HMODE,'Visible','off');
            pausel=0;
        else
            set(HMODE,'String','PAUSE','Visible','on');
            pausel=1;
        end
    end
    function exit(h,evt)
        stop=1;
        close all;
    end
    function restart(h,evt)
        set(HMODE,'Visible','off');
        score=0;
        set(HSCORE,'String',['Score: ',num2str(score)]);
        pausel=0;
        map=zeros(10,19);
        globalpatch=1;
        needtoput=1;
        if stop==1
            stop=0;
            do;
        end
    end
    function check
        for i=17:-1:1
            kk=0;
            for j=1:10
                if map(j,i)==0
                    kk=1;
                end
            end
            if kk==0
                score=score+100;
                set(HSCORE,'String',['Score: ',num2str(score)]);
                for ii=i:17
                    map(:,ii)=map(:,ii+1);
                end                     
                
            end
        end
        globalpatch=1;
    end
end