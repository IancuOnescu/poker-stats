players_list = function(df) {
  distinct(df, p_name)$p_name
}

player_hands_freq = function(df) {
  freq_names = data.frame(table(df$p_name))
  colnames(freq_names) = c("p_name", "hands")
  arrange(freq_names, desc(hands))
}

player_hands_stats = function(freq = NULL, df = NULL) {
  if (is.null(freq)) {
    freq = player_hands_freq(df)
  }

  list(
    mean = mean(freq$hands),
    median = median(freq$hands),
    variance = var(freq$hands),
    sd = sd(freq$hands),
    quantiles = quantile(freq$hands, probs = c(0.1, 0.25, 0.5, 0.9, 0.95, 0.99))
  )
}
