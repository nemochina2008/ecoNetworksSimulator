context("Test integration")

test_that("we can build a C-model from an R-model", {
  species <- newSpeciesTable()
  species <- addSpecies(species, "resource1", growthRate = 0.2, carryingCapacity = 25)
  species <- addSpecies(species, "resource2", growthRate = 0.3, carryingCapacity = 26)
  species <- addSpecies(species, "consumer", mortality = 0.4, halfSaturation = 27)
  interactions <- newInteractionsTable()
  interactions <- addInteraction(interactions,
                                 predator = "consumer",
                                 prey = "resource1",
                                 attackRate = 0.5,
                                 conversionRate = 0.35)
  interactions <- addInteraction(interactions,
                                 predator = "consumer",
                                 prey = "resource2",
                                 attackRate = 0.6,
                                 conversionRate = 0.40)
  r2c1 <- newModel(species, interactions)
  cModel <- .R_buildCModel(r2c1)
  numSpecies <- .C_numSpecies(cModel)
  expect_equal(numSpecies, 3)
  #
  # resource1
  #
  values <- .C_getSpeciesValues(cModel, 0)
  expect_equal(length(values), 4)
  expect_equal(values[1], 0.2)
  expect_equal(values[2], 25.0)
  expect_equal(values[3], NA_real_)
  expect_equal(values[4], NA_real_)
  predatorValues <- .C_getPredatorCoefficients(cModel, 0)
  expect_equal(length(predatorValues), 0)
  preyValues <- .C_getPreyCoefficients(cModel, 0)
  expect_equal(length(preyValues), 3)
  expect_equal(length(preyValues[[1]]), 1)
  expect_equal(preyValues[[1]][1], 2)
  expect_equal(length(preyValues[[2]]), 1)
  expect_equal(preyValues[[2]][1], 0.5)
  expect_equal(length(preyValues[[3]]), 1)
  expect_equal(preyValues[[3]][1], 0.35)
  #
  # resource2
  #
  values <- .C_getSpeciesValues(cModel, 1)
  expect_equal(length(values), 4)
  expect_equal(values[1], 0.3)
  expect_equal(values[2], 26.0)
  expect_equal(values[3], NA_real_)
  expect_equal(values[4], NA_real_)
  predatorValues <- .C_getPredatorCoefficients(cModel, 1)
  expect_equal(length(predatorValues), 0)
  preyValues <- .C_getPreyCoefficients(cModel, 1)
  expect_equal(length(preyValues), 3)
  expect_equal(length(preyValues[[1]]), 1)
  expect_equal(preyValues[[1]][1], 2)
  expect_equal(length(preyValues[[2]]), 1)
  expect_equal(preyValues[[2]][1], 0.6)
  expect_equal(length(preyValues[[3]]), 1)
  expect_equal(preyValues[[3]][1], 0.40)
  #
  # consumer
  #
  values <- .C_getSpeciesValues(cModel, 2)
  expect_equal(length(values), 4)
  expect_equal(values[1], 0)
  expect_equal(values[2], NA_real_)
  expect_equal(values[3], 0.4)
  expect_equal(values[4], 27.0)
  predatorValues <- .C_getPredatorCoefficients(cModel, 2)
  expect_equal(length(predatorValues), 3)
  expect_equal(length(predatorValues[[1]]), 2)
  expect_equal(predatorValues[[1]][1], 0)
  expect_equal(predatorValues[[1]][2], 1)
  expect_equal(length(predatorValues[[2]]), 2)
  expect_equal(predatorValues[[2]][1], 0.5)
  expect_equal(predatorValues[[2]][2], 0.6)
  expect_equal(length(predatorValues[[3]]), 2)
  expect_equal(predatorValues[[3]][1], 0.35)
  expect_equal(predatorValues[[3]][2], 0.40)
  preyValues <- .C_getPreyCoefficients(cModel, 2)
  expect_equal(length(preyValues), 0)
})

test_that("we can euler integrate simple model", {
  species <- newSpeciesTable()
  species <- addSpecies(species, "resource", growthRate = 0.2, carryingCapacity = 25)
  species <- addSpecies(species, "consumer", mortality = 0.2, halfSaturation = 25)
  interactions <- newInteractionsTable()
  interactions <- addInteraction(interactions,
    predator = "consumer",
    prey = "resource",
    attackRate = 0.1,
    conversionRate = 0.35)
  r1c1 <- newModel(species, interactions)
  results <- integrateModel(r2c1, 0.01, 10000, initialValues)
  expect_false(is.null(values))
})