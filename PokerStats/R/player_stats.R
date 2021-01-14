profit_treshold = 50000
convergence_treshold = 10^5

get_net_profit = function (df) {
  profit = factor_to_int(df$win) - factor_to_int(df$p_pot_sz)
  return(profit[profit >= -profit_treshold &
                  profit <= profit_treshold]);
}

player_hands = function(df, player) {
  filter(df, p_name == player)
}

sample_hands = function(obs, count){
  replicate(convergence_treshold,
            sum(
              dqsample(obs, count, replace = TRUE),
              na.rm = TRUE))
}

plot_hands_distr = function(profit, hand_counts, bks, title){
  hands = sample_hands(profit, hand_counts)

  hands.hist = hist(hands, breaks = bks, plot = FALSE)
  hands.hist$counts = hands.hist$counts/sum(hands.hist$counts)
  plot(hands.hist, main = title)

  xfit <- seq(min(hands), max(hands), length = length(hands))
  yfit <- dnorm(xfit, mean = mean(hands), sd = sd(hands))
  yfit <- yfit * (hands.hist$counts / hands.hist$density)[1]

  lines(xfit, yfit, col = "darkblue", lwd = 2)
}

plot_player_distr = function(df, player, hands = 1000, bks = 75,
                             prefiltered = FALSE) {
  pdata = NULL
  if (prefiltered) {
    pdata = df
  } else {
    pdata = player_hands(df, player)
  }

  pprofit = get_net_profit(pdata)

  plot_hands_distr(pprofit, hands, bks,
                   sprintf("Sample distribution of %d hands from %s",
                           hands, player))
}

plot_bankroll = function(pdata, player) {
  pdata = arrange(pdata, factor_to_int(timestamp))
  pdata = mutate(pdata, win = factor_to_int(win))
  pdata = mutate(pdata, p_pot_sz = factor_to_int(p_pot_sz))
  pdata = mutate(pdata, profit = win - p_pot_sz)
  pdata$profit = cumsum(pdata$profit)

  x = anytime(factor_to_int(pdata$timestamp))
  y = factor_to_int(pdata$profit)

  plot(x, y, type="l",
       main = sprintf("Bankroll of %s", player))
}
