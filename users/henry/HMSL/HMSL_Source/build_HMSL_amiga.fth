; hl: 470k, not 370...
echo "This compilation requires the new JForth 3.0 or greater."

execute JForth:Assigns

IF EXISTS HWORK:BIG4th
    execute HMSL_Source:Assigns
    run hwork:big4th include hh:load_hmsl 470 #K ! save-forth hwork:HMSL4th
ELSE
    execute Extras:Assigns
    com:JForth 470 #K ! save-forth hwork:hmsl4th bye
    execute HMSL_Source:Assigns
    run hwork:hmsl4th include hh:load_hmsl save-forth hwork:HMSL4th bye
ENDIF
