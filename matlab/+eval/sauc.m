function score = sauc(saliencyMap, eyeData)
localHum = saliencyMap(eyeData.fixInd);
localRan = saliencyMap(eyeData.restFixInd);

score = auc(localHum, localRan);
end

function [ac,R,steps] = auc(a,b)
%returns the area under the curve by sweeping a threshold through the min
%and max values of the entire dataset.  where a is the model to test and b
%is the random model to discriminate from.  A score 0f .5 is a model that
%cannot discriminate from the random distrobution.

steps = .01;

mx = max([a;b]);
R = [];
for ii = 0:steps:mx
    tp = find((a >= ii));
    fp = find((b >= ii));
    R = [R;[length(fp)./length(b) length(tp)./length(a)]];
end
R = [R;[0 0]];
ac = trapz(flipdim(R(:,1),1),flipdim(R(:,2),1));
steps = 0:steps:mx;

end