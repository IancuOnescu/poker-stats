# output dir must exist!
# it is assumed that they have the same structure
convert_all_csvs_to_feather = function (
  path,
  INPUT_DIR_NAME  = "parsed_data",
  OUTPUT_DIR_NAME = "dataframes"
) {
  csvs = list.files(path, pattern = "*.csv",
                    recursive = TRUE, full.names = TRUE)

  cl = makeForkCluster()
  pblapply(csvs, function(name) {
    df = read.csv(name)

    outname = gsub(INPUT_DIR_NAME, OUTPUT_DIR_NAME, name)
    outname = gsub("\\.csv", ".feather", outname)
    write_feather(df, outname)
    return ()
  }, cl = cl)
  stopCluster(cl)
}

load_pdbs = function(path = "./dataframes") {
  frames = list.files(path, pattern = "pdb.*.feather",
                      full.names = TRUE, recursive = TRUE)

  cl = makeForkCluster()
  all_dataframes = pblapply(frames, function(frame) {
    df = read_feather(frame,
                      columns = c(
                        "timestamp",
                        "p_name",
                        "p_bankroll",
                        "p_pot_sz",
                        "win",
                        "cards"))
  }, cl = cl)
  stopCluster(cl)

  return(all_dataframes)
}
