
;;;======================================================
;;;   WebHub Installation Expert
;;;
;;;     This example guides someone to install
;;;     WebHub Runtime including all pre-requisites.
;;;
;;;     CLIPS Version 6.0 
;;;
;;;     To execute, merely load, reset and run.
;;;======================================================

(defmodule MAIN (export ?ALL))

;;****************
;;* DEFFUNCTIONS *
;;****************

(deffunction MAIN::ask-question (?question ?allowed-values)
   (printout t ?question)
   (bind ?answer (read))
   (if (lexemep ?answer) then (bind ?answer (lowcase ?answer)))
   (while (not (member ?answer ?allowed-values)) do
      (printout t ?question)
      (bind ?answer (read))
      (if (lexemep ?answer) then (bind ?answer (lowcase ?answer))))
   ?answer)

;;*****************
;;* INITIAL STATE *
;;*****************

(deftemplate MAIN::attribute
   (slot name)
   (slot value)
   (slot certainty (default 100.0)))

(defrule MAIN::start
  (declare (salience 10000))
  =>
  (set-fact-duplication TRUE)
  (focus QUESTIONS CHOOSE-PLATFORM-REASONABLE COMPUTERPLATFORMS PRINT-RESULTS))

(defrule MAIN::combine-certainties ""
  (declare (salience 100)
           (auto-focus TRUE))
  ?rem1 <- (attribute (name ?rel) (value ?val) (certainty ?per1))
  ?rem2 <- (attribute (name ?rel) (value ?val) (certainty ?per2))
  (test (neq ?rem1 ?rem2))
  =>
  (retract ?rem1)
  (modify ?rem2 (certainty (/ (- (* 100 (+ ?per1 ?per2)) (* ?per1 ?per2)) 100))))
  

;;******************
;;* QUESTION RULES *
;;******************

(defmodule QUESTIONS (import MAIN ?ALL) (export ?ALL))

(deftemplate QUESTIONS::question
   (slot attribute (default ?NONE))
   (slot the-question (default ?NONE))
   (multislot valid-answers (default ?NONE))
   (slot already-asked (default FALSE))
   (multislot precursors (default ?DERIVE)))
   
(defrule QUESTIONS::ask-a-question
   ?f <- (question (already-asked FALSE)
                   (precursors)
                   (the-question ?the-question)
                   (attribute ?the-attribute)
                   (valid-answers $?valid-answers))
   =>
   (modify ?f (already-asked TRUE))
   (assert (attribute (name ?the-attribute)
                      (value (ask-question ?the-question ?valid-answers)))))

(defrule QUESTIONS::precursor-is-satisfied
   ?f <- (question (already-asked FALSE)
                   (precursors ?name is ?value $?rest))
         (attribute (name ?name) (value ?value))
   =>
   (if (eq (nth 1 ?rest) and) 
    then (modify ?f (precursors (rest$ ?rest)))
    else (modify ?f (precursors ?rest))))

(defrule QUESTIONS::precursor-is-not-satisfied
   ?f <- (question (already-asked FALSE)
                   (precursors ?name is-not ?value $?rest))
         (attribute (name ?name) (value ~?value))
   =>
   (if (eq (nth 1 ?rest) and) 
    then (modify ?f (precursors (rest$ ?rest)))
    else (modify ?f (precursors ?rest))))


;;***************************
;;* WEBHUBRUNTIME QUESTIONS *
;;***************************

(defmodule WEBHUBRUNTIME-QUESTIONS (import QUESTIONS ?ALL))

(deffacts WEBHUBRUNTIME-QUESTIONS::question-attributes
  (question (attribute use-case)
            (the-question "Do you wish to run web applications on this computer? ")
            (precursors computer-platform is supported)
            (valid-answers yes no))
  (question (attribute computer-bitness)
            (the-question "What type of CPU is here?")
            (valid-answers 32-bit 64-bit))
  (question (attribute computer-operating-system)
            (the-question "What operating system runs here? ")
            (valid-answers WinXP Windows7 Windows8 Win2003 Win2008 Win2012 Linux MacOS)))
 
;;******************
;; The RULES module
;;******************

(defmodule RULES (import MAIN ?ALL) (export ?ALL))

(deftemplate RULES::rule
  (slot certainty (default 100.0))
  (multislot if)
  (multislot then))

(defrule RULES::throw-away-ands-in-antecedent
  ?f <- (rule (if and $?rest))
  =>
  (modify ?f (if ?rest)))

(defrule RULES::throw-away-ands-in-consequent
  ?f <- (rule (then and $?rest))
  =>
  (modify ?f (then ?rest)))

(defrule RULES::remove-is-condition-when-satisfied
  ?f <- (rule (certainty ?c1) 
              (if ?attribute is ?value $?rest))
  (attribute (name ?attribute) 
             (value ?value) 
             (certainty ?c2))
  =>
  (modify ?f (certainty (min ?c1 ?c2)) (if ?rest)))

(defrule RULES::remove-is-not-condition-when-satisfied
  ?f <- (rule (certainty ?c1) 
              (if ?attribute is-not ?value $?rest))
  (attribute (name ?attribute) (value ~?value) (certainty ?c2))
  =>
  (modify ?f (certainty (min ?c1 ?c2)) (if ?rest)))

(defrule RULES::perform-rule-consequent-with-certainty
  ?f <- (rule (certainty ?c1) 
              (if) 
              (then ?attribute is ?value with certainty ?c2 $?rest))
  =>
  (modify ?f (then ?rest))
  (assert (attribute (name ?attribute) 
                     (value ?value)
                     (certainty (/ (* ?c1 ?c2) 100)))))

(defrule RULES::perform-rule-consequent-without-certainty
  ?f <- (rule (certainty ?c1)
              (if)
              (then ?attribute is ?value $?rest))
  (test (or (eq (length$ ?rest) 0)
            (neq (nth 1 ?rest) with)))
  =>
  (modify ?f (then ?rest))
  (assert (attribute (name ?attribute) (value ?value) (certainty ?c1))))

;;*******************************
;;* CUSTOM RULES *
;;*******************************

(defmodule CHOOSE-PLATFORM-REASONABLE (import RULES ?ALL)
                            (import QUESTIONS ?ALL)
                            (import MAIN ?ALL))

(defrule CHOOSE-PLATFORM-REASONABLE::startit => (focus RULES))

(deffacts the-platform-rules

  ; Rules for assessing the overall computer platform

  (rule (if computer-operating-system is Linux)
        (then computerplatform is unsupported))
  (rule (if computer-operating-system is MacOS)
        (then computerplatform is unsupported))
  (rule (if computer-operating-system is Win2003)
        (then computerplatform is supported))
  (rule (if computer-operating-system is Windows7)
        (then computerplatform is supported))
  (rule (if computer-operating-system is Windows7)
        (then computerplatform is supported))
  (rule (if user-objective is yes and computer-platform is supported)
	(then should-install httpServer should-install WebHubRuntimeSetup)))

;;************************
;;* CUSTOM SELECTION RULES *
;;************************

(defmodule COMPUTERPLATFORMS (import MAIN ?ALL))

(deffacts any-attributes
  (attribute (name x-operating-system) (value any))
  (attribute (name x-operating-system-bitness) (value any))
  (attribute (name x-use-case) (value any)))

(deftemplate COMPUTERPLATFORMS::computerplatform
  (slot name (default ?NONE))
  (multislot operating-system (default any))
  (multislot operating-system-bitness (default any))
  (multislot use-case (default any)))

;;*****************************
;;* PRINT SOMETHING *
;;*****************************

(defmodule PRINT-RESULTS (import MAIN ?ALL))

(defrule PRINT-RESULTS::header ""
   (declare (salience 10))
   =>
   (printout t "ok" crlf))


;;(deffacts startup
;; (operating-system-list WinXP Windows7 Windows8 Win2003 Win2008 Win2012)
;; (operating-system-bitness-list 32-bit 64-bit))

;;(defrule MAIN::wishToRunWebAppsHere
;;   (wish-run-web-applications-here yes)
;;   =>
;;   (assert (should-install httpServer)
;;           (should-install WebHubRuntime)))

;;(defrule MAIN::willNOTRunWebAppsHere
;;   (wish-run-web-applications-here no)
;;   =>
;;   (assert (should-not-install httpServer)
;;           (should-not-install WebHubRuntime)))

