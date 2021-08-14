function start(song) -- setting shit up
    inaLight = makeSprite ('light', 'theLight', false)
    setActorAlpha(1, 'theLight')
    setActorX(-40, 'theLight')
    setActorY(450, 'theLight')
    setActorAlpha(1, 'theLight')
    setActorScale(5.0, 'theLight')

    inaLightText = makeSprite ('lightText', 'theLightText', false)
    setActorX(-40, 'theLightText')
    setActorY(450, 'theLightText')
    setActorAlpha(0, 'theLightText')
    setActorScale(1.5, 'theLightText')

    showOnlyStrums = true;
    strumLine1Visible = false;
    strumLine2Visible = false;
    for i=0,3 do -- health bar disappears
        tweenFadeOut(i, 0, 0)
    end

end

function setDefault(id) -- do nothing

end

function update(elapsed)

    local currentBeatHalf = (songPos / 1000)*((bpm/2)/60)
    local currentBeat = (songPos / 1000)*(bpm/60)
    local currentBeat2 = (songPos / 1000)*((bpm*2)/60)

    if violentshakinghorizontal then
        for i=0,7 do
            setActorX(_G['defaultStrum'..i..'X'] + 16 * math.sin(currentBeat*8 * math.pi), i)
        end
    end
end

function beatHit(beat) -- do nothing

end

function stepHit(step) -- do nothing
    if step <= 1 then
        setActorAlpha(0, 'theLight')
        setActorAlpha(1, 'theLightText')
    end

    if step == 15 then
        showOnlyStrums = false;
        strumLine1Visible = true;
        strumLine2Visible = true;

        tweenFadeOut('theLightText', 0, 2)
        tweenFadeOut(0, 1, 2)
        tweenFadeOut(1, 1, 2)
        tweenFadeOut(2, 1, 2)
        tweenFadeOut(3, 1, 2)
        tweenFadeOut(4, 1, 2)
        tweenFadeOut(5, 1, 2)
        tweenFadeOut(6, 1, 2)
        tweenFadeOut(7, 1, 2)
        
    end

    if step == 928 then
        violentshakinghorizontal = true
    end

    if step == 1088 then
        violentshakinghorizontal = false
    end

end