erlc bank.erl
erlc customer.erl
erlc money.erl
erl -noshell -run money start c1.txt b1.txt -s init stop


io:fwrite("~p~n", [BankInfo]),

lists:foreach(
    fun({BankName, ReserveAmount}) ->
        PID = spawn(money, bank, [BankName, ReserveAmount]),
        io:fwrite("~p~n", [PID]),
        lists:append(BankPIDs, [PID]),
        io:fwrite("~p~n", [BankPIDs])
    end,
    BankInfo
),

PID = spawn(bar, bank, [{"RBC", 200}]),
PID ! {self(), 5},

[FirstPID | _] = BankPIDs,
FirstPID ! {self(), 500},

lists:min([50, Amount])