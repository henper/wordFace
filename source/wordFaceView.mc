import Toybox.Graphics;
import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;

class wordFaceView extends WatchUi.WatchFace {

    var prevMinute;

    function initialize() {
        WatchFace.initialize();

        prevMinute = System.getClockTime().min - 1;
    }

    // Load your resources here
    function onLayout(dc as Dc) as Void {
        setLayout(Rez.Layouts.WatchFace(dc));
    }

    // Called when this View is brought to the foreground. Restore
    // the state of this View and prepare it to be shown. This includes
    // loading resources into memory.
    function onShow() as Void {
    }

    function abs(x) {
        if (x < 0) {
            return x * -1;
        } else {
            return x;
        }
    }

    // Update the view
    function onUpdate(dc as Dc) as Void {

        // Get and show the current time
        var clockTime = System.getClockTime();

        if (prevMinute != clockTime.min) {
            prevMinute = clockTime.min;
            System.println(Lang.format("$1$:$2$", [clockTime.hour, clockTime.min.format("%02d")]));
        }

        var fuzziness = 5;

        var precision = "";

        // Are we around the hour mark?
        if ((60 - fuzziness/2 <= clockTime.min) || (clockTime.min <= fuzziness/2)) {
            // TODO: oh'clock suffix?
        
        // Are we around the half hour mark?
        } else if (abs(clockTime.min - 30) <= (3*fuzziness)/2) {
            // handle five past/to half
            if (clockTime.min > 30 + fuzziness/2) {
                precision = "Fem över ";
            } else if (clockTime.min < 30 - fuzziness/2) {
                precision = "Fem i ";
            }

            precision = precision + "Halv ";
        } else {
            var minutes = ["Fem", "Tio", "Kvart", "Tjugo"];
            var minute = clockTime.min;
            var offset = fuzziness/2;
            if (minute > 30) {
                precision = precision + " i ";
                // re-use the table by playing the uno-reverse card
                minute = minute - 30;
                minutes = minutes.reverse();
                offset = -fuzziness/2 - 1;
            } else {
                precision = precision + " över ";
            }

            var minuteIndex = (minute + offset) / fuzziness - 1;
            
            precision = minutes[minuteIndex] + precision;
        }
        
        var hours = ["Tolv", "Ett", "Två", "Tre", "Fyra", "Fem", "Sex", "Sju", "Åtta", "Nio", "Tio", "Elva", "Tolv"];
        var hourIndex = clockTime.hour;

        // 24-hour time is a system setting, that we choose to ignore. TODO: show AM/PM?
        if (hourIndex > 12) {
            hourIndex = hourIndex - 12;
        }

        var timeString = precision + hours[hourIndex];
        
        var view = View.findDrawableById("TimeLabel") as Text;
        view.setText(timeString);

        // Call the parent onUpdate function to redraw the layout
        View.onUpdate(dc);
    }

    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    function onHide() as Void {
    }

    // The user has just looked at their watch. Timers and animations may be started here.
    function onExitSleep() as Void {
    }

    // Terminate any active timers and prepare for slow updates.
    function onEnterSleep() as Void {
    }

}
