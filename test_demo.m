
testtime = 10;
togglefig('figure1')
for ii = 1:testtime
    industryparticle;    
    subplot(2,5,ii)
    imshow(TargetPic)
    title([num2str(N),' sampled points ',num2str(Iteration),' iteration'])
end