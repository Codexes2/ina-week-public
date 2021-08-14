local prevX = 0
local prevY = 0

function start(song)
    inaStage = makeSprite('ExtraStage2', 'inaBG', true)
    setActorX(200, 'inaBG')
    setActorY(500, 'inaBG')
    setActorAlpha(0, 'inaBG')
    setActorScale(2.2, 'inaBG')

    inaLight = makeSprite('light', 'theLight', false)
    setActorAlpha(0, 'theLight')
    setActorX(-40, 'theLight')
    setActorY(450, 'theLight')
    setActorAlpha(0, 'theLight')
    setActorScale(5.0, 'theLight')

    inaDark = makeSprite('darkness', 'theDark', false)
    setActorAlpha(0, 'theDark')
    setActorX(-40, 'theDark')
    setActorY(450, 'theDark')
    setActorAlpha(0, 'theDark')
    setActorScale(5.0, 'theDark')

    prevX = getActorX('dad')
    prevY = getActorY('dad')

    print('dadX:', prevX)
    print('dadY:', prevY)
end

function update(elapsed) -- do nothing

end

function beatHit(beat) -- do nothing

end

function stepHit(step)
    if step == 5520 then
        tweenFadeIn('theDark', 1, 8)
        showOnlyStrums = true
        strumLine1Visible = false
        strumLine2Visible = false
    end

    if step == 5700 then
        setActorAlpha(1, 'inaBG')
        changeDadCharacter('inaKnightP2')
        setActorX(-300, 'dad')
        setActorY(100, 'dad')
    end

    if step == 5808 then 
        tweenFadeIn('theDark', 0, 4)
        showOnlyStrums = false
        strumLine1Visible = true
        strumLine2Visible = true
    end

    if step == 10992 then
        tweenFadeIn('theLight', 1, 2)
    end

    if step == 11040 then
        setActorAlpha(0, 'inaBG')
    end

    if step == 11056 then
        tweenFadeIn('theLight', 0, 2)
        changeDadCharacter('ina')
        setActorX(prevX, 'dad')
        setActorY(prevY, 'dad')
    end
end