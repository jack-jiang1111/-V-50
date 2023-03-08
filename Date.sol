pragma solidity ^0.5.1;

library ThursdayChecker {
    struct DateTime {
        uint16 year;
        uint8 month;
        uint8 day;
        uint8 hour;
        uint8 minute;
        uint8 second;
        uint8 weekday;
    }

    function isThursday(uint256 epochTime) external pure returns (int) {
        DateTime memory dt = parseTimestamp(epochTime);
        return dt.weekday; // Thursday is 4 in the DateTime library's weekday enumeration
    }

    function parseTimestamp(uint256 timestamp) internal pure returns (DateTime memory dt) {
        uint256 secondsAccountedFor = 0;
        uint256 buf;

        // Year
        dt.year = getYear(timestamp);
        buf = leapYearsBefore(dt.year) - leapYearsBefore(1970);
        secondsAccountedFor += buf * 31536000;
        secondsAccountedFor += (dt.year - 1970 - buf) * 31536000;

        // Month
        uint256 secondsInMonth;
        for (uint8 i = 1; i <= 12; i++) {
            secondsInMonth = 86400 * getDaysInMonth(i, dt.year);
            if (secondsInMonth + secondsAccountedFor > timestamp) {
                dt.month = i;
                break;
            }
            secondsAccountedFor += secondsInMonth;
        }

        // Day
        for (uint8 i = 1; i <= getDaysInMonth(dt.month, dt.year); i++) {
            if (86400 + secondsAccountedFor > timestamp) {
                dt.day = i;
                break;
            }
            secondsAccountedFor += 86400;
        }

        // Hour, minute, and second
        dt.hour = getHour(timestamp);
        dt.minute = getMinute(timestamp);
        dt.second = getSecond(timestamp);

        // Day of week
        dt.weekday = getWeekday(timestamp);

        return dt;
    }

    function getYear(uint256 timestamp) internal pure returns (uint16) {
        uint256 secondsAccountedFor = 0;
        uint16 year;
        uint256 numLeapYears;

        // Year
        year = uint16(1970 + timestamp / 31536000);
        numLeapYears = leapYearsBefore(year) - leapYearsBefore(1970);

        while (true) {
            if (isLeapYear(year)) {
                if (secondsAccountedFor + 31622400 > timestamp) {
                    break;
                }
                secondsAccountedFor += 31622400;
            } else {
                if (secondsAccountedFor + 31536000 > timestamp) {
                    break;
                }
                secondsAccountedFor += 31536000;
            }
            year += 1;
        }

        return year;
    }

    function getMonth(uint256 timestamp) internal pure returns (uint8) {
        return parseTimestamp(timestamp).month;
    }

    function getDay(uint256 timestamp) internal pure returns (uint8) {
        return parseTimestamp(timestamp).day;
    }

    function getHour(uint256 timestamp) internal pure returns (uint8) {
        return uint8((timestamp / 60 / 60) % 24);
    }

    function getMinute(uint256 timestamp) internal pure returns (uint8) {
        return uint8((timestamp / 60) % 60);
    }
    function getSecond(uint256 timestamp) internal pure returns (uint8) {
        return uint8(timestamp % 60);
    }
    function getDaysInMonth(uint8 month, uint16 year) internal pure returns (uint8) {
        if (month == 2) {
            return isLeapYear(year) ? 29 : 28;
        } else if (month <= 7) {
            return month % 2 == 0 ? 30 : 31;
        } else {
            return month % 2 == 0 ? 31 : 30;
        }
    }

    function isLeapYear(uint16 year) internal pure returns (bool) {
        if (year % 4 != 0) {
            return false;
        }
        if (year % 100 != 0) {
            return true;
        }
        if (year % 400 == 0) {
            return true;
        }
        return false;
    }

    function leapYearsBefore(uint256 year) internal pure returns (uint256) {
        year -= 1;
        return year / 4 - year / 100 + year / 400;
    }

    function getWeekday(uint256 timestamp) internal pure returns (uint8) {
        return uint8((timestamp / 86400 + 4) % 7) + 1;
    }

}