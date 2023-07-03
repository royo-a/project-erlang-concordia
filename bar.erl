% -module(bar).
% -export([bank/1]).
% -export([customer/1]).

% bank({Name, ReserveAmount}) ->
%     put(reserve_amount, ReserveAmount),
%     receive
%         {SenderProcess, MainProcess, CustomerName, Amount} ->
%             % 👉 if reserve has enough money to grant, grant money
%             if
%                 ReserveAmount - Amount >= 0 ->
%                     % 👉 deduct from reserve
%                     put(reserve_amount, ReserveAmount - Amount),
%                     SenderProcess ! true,
%                     MainProcess ! {Name, CustomerName, Amount, true};
%                 % 👉 otherwise refuse
%                 true ->
%                     SenderProcess ! false,
%                     MainProcess ! {Name, CustomerName, Amount, false}
%             end,
%             bank({Name, get(reserve_amount)})
%     end.

% request_bank({Name, Amount, BankPIDs, BankInfo, MainProcess}) ->
%     timer:sleep(random:uniform(91) + 10),
%     if
%         length(BankPIDs) == 0 ->
%             ok;
%         true ->
%             % 👉 choose a random bank to request
%             RandomIndex = rand:uniform(length(BankPIDs)),
%             BankPid = lists:nth(RandomIndex, BankPIDs),
%             Bank = lists:nth(RandomIndex, BankInfo),
%             {BankName, _} = Bank,

%             % 👉 choose a random amount between 1 or min(50, lowest) to ask bank
%             if
%                 Amount > 0 ->
%                     MinAmount = rand:uniform(lists:min([50, Amount]));
%                 true ->
%                     MinAmount = 0
%             end,

%             % 👉 while there are banks to request money from and all money
%             % not received
%             if
%                 Amount > 0 andalso length(BankPIDs) > 0 ->
%                     BankPid ! {self(), MainProcess, Name, MinAmount},
%                     MainProcess ! {Name, BankName, MinAmount};
%                 true ->
%                     ok
%             end,
%             receive
%                 true ->
%                     % 👉 if bank accepts, reduce total amount
%                     request_bank({Name, Amount - MinAmount, BankPIDs, BankInfo, MainProcess});
%                 false ->
%                     % 👉 if bank refuses, remove bank from list
%                     request_bank(
%                         {Name, Amount - MinAmount, lists:delete(BankPid, BankPIDs),
%                             lists:delete(Bank, BankInfo), MainProcess}
%                     )
%             end
%     end.

% customer({Name, Amount, BankPIDs, BankInfo, MainProcess}) ->
%     put(customer_name, Name),
%     put(requested_amount, Amount),
%     put(banks_to_request, lists:reverse(BankPIDs)),

%     request_bank({Name, Amount, get(banks_to_request), lists:reverse(BankInfo), MainProcess}),
%     ok.
