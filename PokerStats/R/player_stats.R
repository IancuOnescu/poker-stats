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

filter_handset = function(pcards, filter_suited){
  local = vector()
  for(i in seq(1, length(pcards)/4, by=4)){
    are_suited = pcards[i+1] == pcards[i+3]
    if(are_suited == filter_suited){
      local = c(local, c(min(pcards[i], pcards[i+2]), max(pcards[i], pcards[i+2])))
    }
  }
  return (local)
}

piechart_top_hands = function(hands, player, n_hands){
  hands.table = table(as.character(interaction(hands, sep = " ")))
  hands.table = hands.table[order(hands.table, decreasing = TRUE)]

  hand.names = names(hands.table)[1:n_hands]
  hand.counts = as.numeric(hands.table)[1:n_hands]

  pct = round(hand.counts/sum(hand.counts)*100)
  hand.names = paste(hand.names, pct)
  hand.names = paste(hand.names, "%", sep="")
  pie3D(hand.counts, labels = hand.names, explode=0.1, col = rainbow(length(hand.names)), main = c("Top winning hands of ", player), labelcex = 0.95)
}

plot_hands_distr = function(profit, hand_counts, bks, title){
  hands = sample_hands(profit, hand_counts)

  hands.hist = hist(hands, breaks = bks, plot = FALSE)
  hands.hist$counts = hands.hist$counts/sum(hands.hist$counts)
  plot(hands.hist, main = title,
       xlab = "Outcome in $", ylab = "Relative Frequency")
  mtext(sprintf("All hands: %d\nMean: %.2f$\nSD: %.2f$",
                length(profit), mean(hands), sd(hands)),
        side=4, adj = 1, las = 1)

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
       main = sprintf("Bankroll of %s", player),
       xlab = "Timeline", ylab = "Amount of $")
}

plot_top_hands = function(pdata, player, n_hands) {
  pcards = filter(pdata, win != 0)
  pcards = as.character(filter(pcards, cards != "")$cards)
  pcards = unlist(strsplit(unlist(strsplit(pcards, " ")), ""))

  suited_hands = filter_handset(pcards, filter_suited = TRUE)
  sh_length = length(suited_hands)

  offsuit_hands = filter_handset(pcards, filter_suited = FALSE)
  oh_length = length(offsuit_hands)

  suited_hands.df = data.frame(suited_hands[seq(sh_length) %% 2 == 1], suited_hands[seq(sh_length) %% 2 == 0], rep("suited", sh_length/2))
  colnames(suited_hands.df) = c("first card", "second card", "type")
  offsuit_hands.df = data.frame(offsuit_hands[seq(oh_length) %% 2 == 1], offsuit_hands[seq(oh_length) %% 2 == 0], rep("offsuit", oh_length/2))
  colnames(offsuit_hands.df) = c("first card", "second card", "type")

  hands = rbind(suited_hands.df, offsuit_hands.df)
  piechart_top_hands(hands, player, n_hands)
}
