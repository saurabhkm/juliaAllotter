module juliaAllotter

using CSV
using LinearAlgebra
using Statistics
using JLD
include("core.jl")

courseFile = "/nfs4/saurabh1/Workspace/Projects/juliaAllotter/data/courseFile.csv"
studentsFile = "/nfs4/saurabh1/Workspace/Projects/juliaAllotter/data/studentsFile.csv"
choiceIndices = [0, 1, 2, 3, 4, 5]
choiceWeights = [10, 1, 2, 3, 4, 5]
costWeights = [-1.0, 1.0, 1.0]
iterations = 10000

coursesDF = CSV.read(courseFile)
studentsDF = CSV.read(studentsFile)

courseCount = length(coursesDF[:, 1])
studentCount = length(studentsDF[:, 1])
cpiArray = Array(studentsDF.CPI)
times = Array(coursesDF.CourseNeeds)

choiceIdx = makeArray(studentCount, studentsDF, courseCount, coursesDF, choiceIndices)
choiceWeights = makeArray(studentCount, studentsDF, courseCount, coursesDF, choiceWeights)

initialAllotment = allotment(studentCount, courseCount, times, Matrix{Float64}(I, studentCount, studentCount))
initialAllotment = squeezeAllotment(initialAllotment)

choiceGoodnessOld, cpiGoodnessOld = calcGoodness(initialAllotment, choiceWeights, cpiArray)
finalAllottment, utility = runMCMC(initialAllotment, iterations, studentCount, courseCount, costWeights, choiceIdx, choiceWeights, studentsDF, cpiArray, times)
choiceGoodnessNew, cpiGoodnessNew = calcGoodness(finalAllottment, choiceWeights, cpiArray)

writePerformance(finalAllottment, choiceGoodnessOld, cpiGoodnessOld, choiceGoodnessNew, cpiGoodnessNew, utility)

end # module