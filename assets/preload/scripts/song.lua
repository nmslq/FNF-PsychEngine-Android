function onCreate()
    makeLuaSprite('whitebg', nil, -1000, 200);
    makeGraphic('whitebg', 400, 100, 'FFFFFF');
    setObjectCamera('whitebg', 'other');
    setProperty('whitebg.alpha', 0.7);
    addLuaSprite('whitebg', true);

    makeLuaText('songtext', songName, 400, 0, 200);
    setTextSize('songtext', 30);
    setObjectCamera('songtext', 'other');
    setTextAlignment('songtext', 'center');
    addLuaText('songtext', true);

    makeLuaText('authortext', difficultyName, 400, 0, 260);
    setTextSize('authortext', 30);
    setObjectCamera('authortext', 'other');
    setTextAlignment('authortext', 'center');
    addLuaText('authortext', true);
end

function onCreatePost()
    doTweenX('songTweenIn' ,'whitebg', 0, 1, 'cubeOut');
end

function onUpdate()
    setProperty('songtext.x',getProperty('whitebg.x'));
    setProperty('authortext.x',getProperty('whitebg.x')) 
end

function onTweenCompleted(tag)
    if tag == 'songTweenIn' then
        runTimer('tweenTimer', 3);
    end
    if tag == 'songTweenOut' then
        removeLuaText('authortext', true);
        removeLuaText('songtext', true);
        removeLuaSprite('whitebg', true);
    end
end

function onTimerCompleted(tag)
    if tag == 'tweenTimer' then
        doTweenX('songTweenOut', 'whitebg', -1000, 1, 'cubeIn');
    end
end
