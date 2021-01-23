UPDATES Jan-23-2021 (mdlee@uci.edu)

The bandit, optimal stopping, and BART data have been cleaned a little. They now report only the 56 participants used in the paper, and do so consistently.

In addition, order information has been added. (The remainder of the data is ordered by the unique problems, not by the order in which subjects completed them),

order: nsubj x nprob x ncond, where the (i,j,k) is the problem number that the ith subject encountered as their jth problem in the kth condition

The new files are banditGuanEtAl2010, optimalStoppingGuanEtAl2021, and BARTGUanEtAl2021, each with a strutured variable "d"


----- ORIGINAL README --------

This folder contains the participant data for each of the 4 risk propensity tasks.
Each task has its own data structure, with the name of the task.

****** Bandit ******
nsubj: number of subjects
ncond: number of conditions (4: 0: length 8 neutral, 1: length 8 plentiful, 2: length 16 neutral, 3: length 16 plentiful)
nprob: number of problems per condition (40)
condition: a string stating the conditions of this task
distributions: a string stating the Beta distributions used for each environment
stimuli: nsubj x nprob x ncond x 4 array giving the randomly generated machine probabilities for the left and right machines, respectively and then how many rewards on the left and right machines, respectively
decisions: nsubj x nprob x ncond x 16 array indicating the exact choices on each problem the participant made, left slot machine (0) or right slot machine (1)
decLeft: nxubj x nprob x ncond x 16 array indicating the choices on each problem the participant made, where (1) indicates CHOSE LEFT while (0) indicates CHOSE RIGHT
decWSLS: nsubj x nprob x ncond x 16 array indicating the choices on each problem the participant made, where (1) indicates STAY while (2) indicates SHIFT
rewardLeft: nsubj x nprob x ncond x 16 array indicating the success/fail reward sequence randomly generated for the left machine
rewardRight: nsubj x nprob x ncond x 16 array indicating the success/fail reward sequence randomly generated for the right machine
rewardChosen: nsubj x nprob x ncond x 16 array indicating the success/fail reward sequence based on the decision of each participant


****** BART ******
nsubj: number of subjects
ncond: number of conditions (2: probability of bursting .1/.2)
nprob: number of problems per condition (50)
condition: a string stating the conditions of this task
stimuli: nsubj x nprob x ncond array indicating the actual number of pumps on each problem for each participant at which the balloon would burst.
decisions: nsubj x nprob x ncond x 2 array indicating 1) whether the participant banked (0) or the balloon bursted (1) on each problem and 2) the number of pumps for each participant on each problem.


****** Gambling ******
nsubj: number of subjects
ncond: number of conditions (2: gains/losses)
nprob: number of problems per condition (40)
condition: a string stating the conditions of this task
stimuli: nsubj x nprob x ncond x 8 array indicating the probabilities and payoffs for each of the gambles shown on each problem for each participant, where 1:4 are for the left gamble and 5:8 are for the right gamble.
decisions: nsubj x nprob x ncond array indicating left (0) or right (1) gamble was chosen.
decBetter: nsubj x nprob x ncond array indicating higher EV (better) gamble was chosen (1) or lower EV (worse) gamble was chosen (0).
stimuliBetter: nsubj x nprob x ncond x 8 array indicating the probabilities and payoffs for each of the gambles shown, where 1:4 are for the “better” gamble and 5:8 are for the “worse” gamble.



****** Optimal Stopping ******
nsubj: number of subjects
ncond: number of conditions (4: 4pt in neutral, 4pt in plentiful, 8pt in neutral, 8pt in plentiful)
nprob: number of problems per condition (40)
condition: a string stating the conditions of this task
distributions: a string stating the distributions used for each condition of this task
stimuli: nsubj x nprob x ncond x 8 array indicating the sequence values presented on each problem for each participant.
decisions: nsubj x nprob x ncond array indicating which position in the sequence they chose. Length 4 conditions: 0 for first, 1 for second, 2 for third, 4 for last. Length 8 conditions: 0 for first, 1 for second, 2 for third, 3 for fourth, 4 for fifth, 5 for sixth, 6 for seventh, and 8 for last.