local item = {'bg, songText', 'difficultyText'};

function onCreate()
    makeLuaSprite('bg', nil, -1000, 200);
    makeGraphic('bg', 400, 100, 'FFFFFF');
    setObjectCamera('bg', 'other');
    setProperty('bg.alpha', 0.7);
    addLuaSprite('bg', true);

    text('songText', songName, 200);
    text('difficultyText', difficultyName, 260);
end

function onCreatePost()
    for i = 1, 3 do
        doTweenX('tween' .. i, item[i], 0, 1, 'cubeOut');
    end
end

function onTweenCompleted(tag)
    if tag == 'songTweenIn' then
        runTimer('tweenTimer', 3);
    end
    if tag == 'songTweenOut' then
        removeLuaText('authortext', true);
        removeLuaText('songtext', true);
        removeLuaSprite('bg', true);
    end
end

function onTimerCompleted(tag)
    if tag == 'tweenTimer' then
        for i = 1, 3 do
            doTweenX('tween' .. i, item[i], -1000, 1, 'cubeIn');
        end
    end
end

function text(tag, txt, y)
    makeLuaText(tag, txt, 400, -1000, y);
    setTextSize(tag, 30);
    setObjectCamera(tag, 'other');
    setTextAlignment(tag, 'center');
    addLuaText(tag, true);
end