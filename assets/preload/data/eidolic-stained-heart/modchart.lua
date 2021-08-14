function start(song)
    inaDark = makeSprite('darkness', 'theDark', false)
    setActorAlpha(0, 'theDark')
    setActorX(-40, 'theDark')
    setActorY(450, 'theDark')
    setActorAlpha(0, 'theDark')
    setActorScale(5.0, 'theDark')
end

function update(elapsed) -- do nothing

end

function beatHit(beat) -- do nothing

end

function stepHit(step)
    if step == 2420 then
        showOnlyStrums = true;
        strumLine1Visible = false;
        strumLine2Visible = false;
    end

    if step == 2550 then
        tweenFadeIn('theDark', 1, 3)
    end
end