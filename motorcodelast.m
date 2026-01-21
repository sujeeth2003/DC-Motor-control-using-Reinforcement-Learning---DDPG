open_system('motorsim')
obsInfo = rlNumericSpec([3 1],...
    'LowerLimit',[-inf -inf 0  ]',...
    'UpperLimit',[ inf  inf inf]');
obsInfo.Name = 'observations';
obsInfo.Description = 'integrated error, error, and measured height';
numObservations = obsInfo.Dimension(1);

actInfo = rlNumericSpec([1 1],'LowerLimit', 0, 'UpperLimit', 12);
actInfo.Name = 'flow';
numActions = actInfo.Dimension(1);
env = rlSimulinkEnv('motorsim','motorsim/RL Agent',obsInfo,actInfo);
env.ResetFcn = @(in)localResetFcn(in);
Ts = 1.0/20;
Tf = 10;
rng(0)
statePath = [
    featureInputLayer(numObservations,'Normalization','none','Name','State')
    fullyConnectedLayer(50,'Name','CriticStateFC1')
    reluLayer('Name','CriticRelu1')
    fullyConnectedLayer(25,'Name','CriticStateFC2')];
actionPath = [
    featureInputLayer(numActions,'Normalization','none','Name','Action')
    fullyConnectedLayer(25,'Name','CriticActionFC1')];
commonPath = [
    additionLayer(2,'Name','add')
    reluLayer('Name','CriticCommonRelu')
    fullyConnectedLayer(1,'Name','CriticOutput')];

criticNetwork = layerGraph();
criticNetwork = addLayers(criticNetwork,statePath);
criticNetwork = addLayers(criticNetwork,actionPath);
criticNetwork = addLayers(criticNetwork,commonPath);
criticNetwork = connectLayers(criticNetwork,'CriticStateFC2','add/in1');
criticNetwork = connectLayers(criticNetwork,'CriticActionFC1','add/in2');
criticOpts = rlRepresentationOptions('LearnRate',1e-03,'GradientThreshold',1);
critic = rlQValueRepresentation(criticNetwork,obsInfo,actInfo,'Observation',{'State'},'Action',{'Action'},criticOpts);
actorNetwork = [
    featureInputLayer(numObservations,'Normalization','none','Name','State')
    fullyConnectedLayer(3, 'Name','actorFC')
    tanhLayer('Name','actorTanh')
    fullyConnectedLayer(numActions,'Name','Action')
    ];

actorOptions = rlRepresentationOptions('LearnRate',1e-04,'GradientThreshold',1);

actor = rlDeterministicActorRepresentation(actorNetwork,obsInfo,actInfo,'Observation',{'State'},'Action',{'Action'},actorOptions);
agentOpts = rlDDPGAgentOptions('SampleTime',Ts,'TargetSmoothFactor',1e-3,'DiscountFactor',1.0,'MiniBatchSize',64,'ExperienceBufferLength',1e6); 
agentOpts.NoiseOptions.StandardDeviation = 10.0;
agentOpts.NoiseOptions.StandardDeviationDecayRate = 1e-5;
agent = rlDDPGAgent(actor,critic,agentOpts);
maxepisodes = 1000;
maxsteps = ceil(Tf/Ts);
trainOpts = rlTrainingOptions('MaxEpisodes',maxepisodes,'MaxStepsPerEpisode',maxsteps,'ScoreAveragingWindowLength',20,'Verbose',false,'Plots','training-progress','StopTrainingCriteria','AverageReward','StopTrainingValue',400);
trainingStats = train(agent,env,trainOpts);
simOpts = rlSimulationOptions('MaxSteps',maxsteps,'StopOnError','on');
experiences = sim(env,agent,simOpts);
function in = localResetFcn(in)

% randomize reference signal
blk = sprintf('motorsim/Desired \nspeed');
h=randi([1798,1800]);
in = setBlockParameter(in,blk,'Value',num2str(h));

end