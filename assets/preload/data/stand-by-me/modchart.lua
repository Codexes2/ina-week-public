function start(song)
    showOnlyStrums = true;
    strumLine1Visible = false;
    strumLine2Visible = false;
end

function update(elapsed)


end

function beatHit(beat)
    if curBeat == 1 then
        strumLine2Visible = true;
        tweenFadeIn(7, 1, 2)
    end
    if curBeat == 8 then
        tweenFadeIn(6, 1, 2)
    end
    if curBeat == 16 then
        tweenFadeIn(5, 1, 2)
    end
    if curBeat == 24 then
        tweenFadeIn(4, 1, 2)
    end
end

function stepHit(step)

end