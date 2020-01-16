function makeArray(studentCount, studentDF, courseCount, coursesDF, weights)
	array = zeros((studentCount, courseCount)) .+ weights[1]
	for i = 1:courseCount
		for j = 1:studentCount
			if coursesDF.CourseCode[i] == studentDF.Choice1[j]
				array[j, i] = weights[2]
			elseif coursesDF.CourseCode[i] == studentDF.Choice2[j]
				array[j, i] = weights[3]
			elseif coursesDF.CourseCode[i] == studentDF.Choice3[j]
				array[j, i] = weights[4]
			elseif coursesDF.CourseCode[i] == studentDF.Choice4[j]
				array[j, i] = weights[5]
			elseif coursesDF.CourseCode[i] == studentDF.Choice5[j]
				array[j, i] = weights[6]
			end
		end
	end
	return array
end

mutable struct allotment
	studentCount::Int
	courseCount::Int
	times
	data
end

function squeezeAllotment(anAllotment::allotment)
	dataHolder = zeros(anAllotment.studentCount, anAllotment.courseCount)
	start = 1
	for i = 1:anAllotment.courseCount
		stop = start + anAllotment.times[i]
		dataHolder[:, i] = collect(Iterators.flatten(sum(anAllotment.data[:,start:stop-1], dims=2)))
		start = stop
	end
	anAllotment.data = dataHolder
	return anAllotment
end

function calcGoodness(anAllotment::allotment, choiceWeights, cpiArray)
	a = anAllotment.data .* choiceWeights
	choiceGoodness = sum(a, dims=2) ./ sum(a .!= 0, dims=2)
	choiceGoodness = replace!(choiceGoodness, NaN=>0)
	cpiRepeated = repeat(cpiArray, outer=[1, anAllotment.courseCount])
	SvC_cpi = anAllotment.data .* cpiRepeated
	cpiGoodness = sum(SvC_cpi, dims=1) ./ sum(SvC_cpi .!= 0, dims=1)
	cpiGoodness = replace!(cpiGoodness, NaN=>0)
	return choiceGoodness, cpiGoodness
end

function swapRows(anAllotment::allotment)
	swapID1 = rand(1:anAllotment.studentCount)
	swapID2 = rand(1:anAllotment.studentCount)
	temp = copy(anAllotment.data)
	tempVar = copy(temp[swapID1, :])
	temp[swapID1,:] = temp[swapID2,:]
	temp[swapID2,:] = tempVar
	return temp
end

# Running with no errors untill here

function calcChoiceCost(anAllotmentData, SvCArray)
	cost1 = sum(anAllotmentData .* SvCArray)
	return cost1
end

function calculateVariance(cpiArray, anAllotment, courseCount, times)
	cpiRepeated = repeat(cpiArray, outer=[1, courseCount])
	SvC_cpi = anAllotment .* cpiRepeated
	a = sum(SvC_cpi, dims=1) ./ sum(SvC_cpi .!= 0, dims=1)
	a = replace!(a, NaN=>0)
	variance = var(a)
	return variance
end

function allottedCourseGrade(studentCount, courseCount,studentDF, anAllotment, SvCArray)
	allotmentMatrix = anAllotment .* SvCArray
	temp = zeros((studentCount, 1))
	for i = 1:studentCount
		for j = 1:courseCount
			if allotmentMatrix[i,j] != 0
				if allotmentMatrix[i,j] == 10
					temp[i] = 0
					break
				else
					temp[i] = studentDF[i, Symbol("Grade"*string(Int(allotmentMatrix[i,j])))]
					# temp[i] = eval(Meta.parse("studentDF["*string(i)*",:].Grade"*string(Int(allotmentMatrix[i,j]))))
					break
				end
			end
		end
	end
	return sum(temp)
end

function calculateUtility(anAllotmentData, costWeights, choiceIdx, choiceWeights, courseCount, studentCount, studentsDF, cpiArray, times)
	choiceSum = calcChoiceCost(anAllotmentData, choiceWeights)
	cost1 = costWeights[1]*choiceSum
	cost2 = costWeights[2]*allottedCourseGrade(studentCount, courseCount, studentsDF, anAllotmentData, choiceWeights)
	var = calculateVariance(cpiArray, anAllotmentData, courseCount, times)
	cost3 = costWeights[3]/var
	totalUtility = cost1 + cost2 + cost3
	return totalUtility
end

function runMCMC(currentAllotment, nIters, studentCount, courseCount, costWeights, choiceIdx, choiceWeights, studentsDF, cpiArray, times)
	beta = 10*log10(1 + studentCount)
	utility = zeros((nIters, 1))
	for i = 1:nIters
		println(i)
		newAllotmentData = swapRows(currentAllotment)

		u1 = calculateUtility(newAllotmentData, costWeights, choiceIdx, choiceWeights, courseCount, studentCount, studentsDF, cpiArray, times)
		u2 = calculateUtility(currentAllotment.data, costWeights, choiceIdx, choiceWeights, courseCount, studentCount, studentsDF, cpiArray, times)
		utility[i] = u1
		println(u1)
		if u1 >= u2
			currentAllotment.data = newAllotmentData
		else
			beta = 10*log10(1+(i-1))
			probVar = exp(beta*(u1 - u2))
			randNum = rand()
			if randNum < probVar
				currentAllotment.data = newAllotmentData
			else
				currentAllotment.data = currentAllotment.data
			end
		end
	end
	return currentAllotment, utility
end

function writePerformance(anAllotment, choiceGoodnessOld, cpiGoodnessOld, choiceGoodnessNew, cpiGoodnessNew, utility)
	save("../../myfile.jld", "allotment", allotment, "choiceGoodnessOld", choiceGoodnessOld, "cpiGoodnessOld", cpiGoodnessOld, "choiceGoodnessNew", choiceGoodnessNew, "cpiGoodnessNew", cpiGoodnessNew, "utility", utility)
end