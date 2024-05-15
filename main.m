global fig W P;

fig = uifigure('Name', 'Tic Tac Toe Game', 'Position', [100, 100, 400, 400]);
W = [1,2,3,4,5,6,7,8,9,1,4,7,2,5,8,3,6,9,1,5,9,3,5,7];
P = zeros(1,9);
Setup()

function Setup()
    global fig buttons;
    buttons = [];
    gridLayout = uigridlayout(fig, [3, 3]);
    disp("Tic Tac Toe by Hriday Ahuja, Starting")
    for row = 1:3
        for col = 1:3
            btn = uibutton(gridLayout, 'push', 'Text', '','FontSize',50);
            btn.Layout.Row = row;
            btn.Layout.Column = col;
            index = (row - 1) * 3 + col;
            btn.UserData.index = index;
            btn.ButtonPushedFcn = @(btn, event) Play(btn);
            buttons = [buttons btn];
        end
    end
end

function Play(btn)
    global fig P;
    if P(btn.UserData.index)
        return
    end
    prompt = msgbox('The AI is playing, Please Wait', 'Prompt');
    set(prompt, 'closerequestfcn', '');
    set(fig, 'Visible', 'off');
    P(btn.UserData.index) = 1;
    stop = UpdateGUI();
    if stop 
        delete(prompt)
        return 
    end
    aimove = minimax(P,2);
    P(aimove.index) = 2;
    stop = UpdateGUI();
    delete(prompt);
    if stop
        return 
    end
    set(fig, 'Visible', 'on');
end

function stop = UpdateGUI()
    stop = false;
    global P buttons;
    for i = 1:length(P)
        if P(i) == 1
            buttons(i).Text = "X";
        elseif P(i) == 2
            buttons(i).Text = "O";
        end
        drawnow;
    end
    cw = CheckWin(P,true);
    if cw 
        disp(cw)
        prompt = msgbox(cw, 'Prompt');
        stop = true;
        return
    end
end

function bestMove = minimax(newBoard,player)
    global P
    if sum(P == 0) == 8 && P(5) == 0
        bestMove.index = 5;
        return
    elseif sum(P == 0) == 8 && P(5) ~= 0
        bestMove.index = 1;
        return
    end
    if CheckWin(newBoard,false) == 'X Won'
        bestMove.score = -1;
        return;
    elseif CheckWin(newBoard,false) == 'O Won'
        bestMove.score = 1;
        return;
    elseif sum(newBoard == 0) == 0
        bestMove.score = 0;
        return;
    end
    moves = [];
    for i = 1:9
        if newBoard(i) == 0
            move.index = i;
            newBoard(i) = player;
            if player == 2
                result = minimax(newBoard,1);
                move.score = result.score;
            else
                result = minimax(newBoard,2);
                move.score = result.score;
            end
            newBoard(i) = 0;
            moves = [moves, move];
        end
    end
    if player == 2
        bestScore = -Inf;
        for i = 1:length(moves)
            if moves(i).score > bestScore
                bestScore = moves(i).score;
                bestMove = moves(i);
            end
        end
    else
        bestScore = Inf;
        for i = 1:length(moves)
            if moves(i).score < bestScore
                bestScore = moves(i).score;
                bestMove = moves(i);
            end
        end
    end
end

function result = CheckWin(P,f)
    global W;
    result = 0;
    x = find(P == 1);
    o = find(P == 2);
    for i = 3:3:length(W)
        vals = [W(i-2),W(i-1),W(i)];
        xWin = isempty(setdiff(vals,x));
        oWin = isempty(setdiff(vals,o));
        if xWin == 1
            result = 'X Won';
            return
        elseif oWin == 1
            result = 'O Won';
            return
        end
    end
    if result == 0 && all(P ~= 0) && f
        result = 'Tied';
    end
end

function MakeBoard(P)
    disp('+---+---+---+');
    retval = '|';
    for i = 1:9
        if P(i) == 1
            retval = [retval, ' X |']; % Player X's move
        elseif P(i) == 2
            retval = [retval, ' O |']; % Player O's move
        else
            retval = [retval, '   |']; % Empty cell
        end
        
        if mod(i, 3) == 0
            disp(retval);
            disp('+---+---+---+');
            if i < 9
                retval = '|';
            end
        end
    end
end
