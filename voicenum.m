function [voiceseg,vsl,SF,NF]=voicenum(dst1,T1,T2)

fn=length(dst1);                  
maxsilence = 10;                        
minlen  = 20;  

status  = 0;
count   = 0;
silence = 0;


xn=1;
for n=1:fn
    switch status
        case {0,1}                          
            if dst1(n) > T2               
                    x1(xn) = max(n-count(xn)-1,1);
                    status  = 2;
                    silence(xn) = 0;
                    count(xn)   = count(xn) + 1;
            elseif dst1(n) > T1                 
                status = 1;
                count(xn)  = count(xn) + 1;
            else                              
                status  = 0;
                count(xn)   = 0;
                x1(xn)=0;
                x2(xn)=0;
            end
        case 2                              
            if dst1(n) > T1
               
                count(xn) = count(xn) + 1;
                silence(xn) = 0;
            else                           
                silence(xn) = silence(xn)+1;
                if silence(xn) < maxsilence   
                    count(xn)  = count(xn) + 1;
                elseif count(xn) < minlen     
                    status  = 0;
                    silence(xn) = 0;
                    count(xn)   = 0;
                else                         
                    status  = 3;
                    x2(xn)=x1(xn)+count(xn);
                end
            end
        case 3                            
            status  = 0;
            xn=xn+1;
            count(xn)   = 0;
            silence(xn)=0;
            x1(xn)=0;
            x2(xn)=0;
    end
end
if xn==1 && x1(xn)==0                      
    SF=zeros(1,fn);                         
    NF=ones(1,fn);
    voiceseg=0;
    vsl=0;
elseif xn==1 && x1==1 && count==length(dst1)  
    SF=ones(1,fn);
    NF=zeros(1,fn);
    voiceseg.begin=1;
    voiceseg.end=length(dst1);
    voiceseg.duration=length(dst1);
    vsl=0;

else
    el=length(x1);
    if x1(el)==0                           
        el=el-1;
    end

    if x2(el)==0                           
        x2(el)=fn;
    end

    SF=zeros(1,fn);                         
    NF=ones(1,fn);
    for i=1 : el
        SF(x1(i):x2(i))=1;
        NF(x1(i):x2(i))=0;
    end

    speechIndex=find(SF==1);               
    voiceseg=findSegment(speechIndex);
    vsl=length(voiceseg);
end
end

