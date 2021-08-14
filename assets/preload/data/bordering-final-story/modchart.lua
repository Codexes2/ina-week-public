function start(song)
    inaStage = makeSprite('saigyou', 'inaBG', true)
    setActorX(200, 'inaBG')
    setActorY(500, 'inaBG')
    setActorAlpha(0, 'inaBG')
    setActorScale(3.0, 'inaBG')

    inaLight = makeSprite('light', 'theLight', false)
    setActorAlpha(1, 'theLight')
    setActorX(-40, 'theLight')
    setActorY(450, 'theLight')
    setActorAlpha(0, 'theLight')
    setActorScale(5.0, 'theLight')

    ol_Cherry = makeSprite('Cherryblossom_Overlay', 'cherry', true)
    setActorX(200, 'cherry')
    setActorY(500, 'cherry')
    setActorAlpha(0, 'cherry')
    setActorScale(3.0, 'cherry')

    signCard = makeSprite('HoloSign_Activation', 'signcard', true)
    setActorX(200, 'signcard')
    setActorY(500, 'signcard')
    setActorAlpha(0, 'signcard')
end

function update(elapsed) -- do nothing

end

function beatHit(beat)
    if curStep <= 2500 then
        if curBeat % 64 == 32 then
            tweenFadeIn('cherry', 1, 1)
        end

        if curBeat % 64 == 0 then
            tweenFadeIn('cherry', 0, 1)
        end
    else
        tweenFadeIn('cherry', 0, 1)
    end
end

function stepHit(step)
    if step == 50 then
        tweenFade('signcard', 1, 0.5)
    end
    
    if step == 2560 then
        tweenFadeIn('theLight', 1, 0.5)
        tweenFadeOut('dad', 0, 1.5)
    end

    if step == 2570 then
        setActorAlpha(1, 'inaBG')
        changeDadCharacter('inaKnightP2')
        setActorAlpha(0, 'dad')
    end

    if step == 2580 then 
        tweenFadeOut('theLight', 0, 4)
        tweenFadeIn('dad', 1, 4)
    end

    if step == 4550 then
        tweenFadeIn('theLight', 1, 0.5)
        tweenFadeOut('dad', 0, 0.5)
    end

    if step == 4600 then
        setActorAlpha(0, 'inaBG')
        changeDadCharacter('inaKnight')
        setActorAlpha(0, 'dad')
    end

    if step == 4620 then
        tweenFadeIn('dad', 1, 4)
        tweenFadeOut('theLight', 0, 4)
    end
end