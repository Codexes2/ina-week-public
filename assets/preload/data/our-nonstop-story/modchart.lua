function start(song) -- setting overlays up
    ov_kiara = makeSprite('Overlay_Kiara', 'kiara', true)
    setActorX(200, 'kiara')
    setActorY(500, 'kiara')
    setActorAlpha(0, 'kiara')
    setActorScale(3.0, 'kiara')

    ov_calli = makeSprite('Overlay_Calli', 'calli', true)
    setActorX(200, 'calli')
    setActorY(500, 'calli')
    setActorAlpha(0, 'calli')
    setActorScale(3.0, 'calli')

    ov_gura = makeSprite('Overlay_Gura', 'gura', true)
    setActorX(200, 'gura')
    setActorY(500, 'gura')
    setActorAlpha(0, 'gura')
    setActorScale(3.0, 'gura')

    ov_ame = makeSprite('Overlay_Ame', 'ame', true)
    setActorX(200, 'ame')
    setActorY(500, 'ame')
    setActorAlpha(0, 'ame')
    setActorScale(3.0, 'ame')

end

function update(elapsed) -- do nothing

end

function beatHit(beat) -- do nothing

end

function stepHit(step)
    if step == 270 then
        tweenFadeIn('kiara', 1, 2)
    end

    if step == 520 then
        tweenFadeIn('kiara', 0, 2)
        tweenFadeIn('calli', 1, 2)
    end

    if step == 996 then
        tweenFadeIn('calli', 0, 2)
        tweenFadeIn('gura', 1, 2)
    end

    if step == 1376 then
        tweenFadeIn('gura', 0, 2)
        tweenFadeIn('ame', 1, 2)
    end

    if step == 1660 then
        tweenFadeIn('ame', 0, 2)
    end
end