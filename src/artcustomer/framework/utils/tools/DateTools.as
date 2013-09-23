/*
 * Copyright (c) 2012 David MASSENOT - http://artcustomer.fr/
 * 
 * Permission is hereby granted to use, modify, and distribute this file 
 * in accordance with the terms of the license agreement accompanying it.
 */

package artcustomer.framework.utils.tools {
	
	
	/**
	 * DateTools : Tools for dates.
	 * 
	 * @author David Massenot
	 */
	public class DateTools {
		public static const LANG_FR:String = 'fr';
		public static const LANG_EN:String = 'en';
		
		private static const FR_DAYS:Array = ['Dimanche', 'Lundi', 'Mardi', 'Mercredi', 'Jeudi', 'Vendredi', 'Samedi'];
		private static const FR_MONTHS:Array = ['Janvier', 'Février', 'Mars', 'Avril', 'Mai', 'Juin', 'Juillet', 'Août', 'Septembre', 'Octobre', 'Novembre', 'Décembre'];
		private static const EN_DAYS:Array = ['Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'];
		private static const EN_MONTHS:Array = ['January', 'Fabruary', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'];
		
		
		/**
		 * Convert String UTC datetime value to Date.
		 * 
		 * @param	str : Can be YYYY-MM-DD HH:MM:SS or YYYY-MM-DD
		 * @return
		 */
		public static function convertStringUTCDateTime(str:String):Date {
			var fullMatches:Array = str.match(/(\d\d\d\d)-(\d\d)-(\d\d) (\d\d):(\d\d):(\d\d)/);
			var matches:Array = str.match(/(\d\d\d\d)-(\d\d)-(\d\d)/);
			var date:Date = new Date();
			
			if (fullMatches) {
				date.setUTCFullYear(int(fullMatches[1]), int(fullMatches[2]) - 1, int(fullMatches[3]));
				date.setUTCHours(int(fullMatches[4]), int(fullMatches[5]), int(fullMatches[6]), 0);
			} else if (matches) {
				date.setUTCFullYear(int(matches[1]), int(matches[2]) - 1, int(matches[3]));
			}
			
			return date;
		}
		
		/**
		 * Convert UTC Date value to a String value.
		 * 
		 * @param	date
		 * @return
		 */
		public static function convertUTCDateToString(date:Date):String {
			if (!date) return '';
			
			var day:String = convertNumber(date.date.toString());
			var month:String = convertNumber((date.month + 1).toString());
			var year:String = convertNumber(date.fullYear.toString());
			var hour:String = convertNumber(date.hours.toString());
			var minutes:String = convertNumber(date.minutes.toString());
			var seconds:String = convertNumber(date.seconds.toString());
			
			return day + '-' + month + '-' + year + ' ' + hour + ':' + minutes + ':' + seconds;
		}
		
		/**
		 * Convert Date to formated sentence.
		 * 
		 * @param	date
		 * @param	displayTime
		 * @param	lang : Only FR and EN at the moment
		 * @return
		 */
		public static function getSafeDate(date:Date, displayTime:Boolean = false, lang:String = 'fr'):String {
			var safeDate:String;
			var safeTime:String = '[HOURS]:[MINUTES]:[SECONDS]';
			var days:Array;
			var months:Array;
			
			switch (lang) {
				case(LANG_FR):
				default:
					safeDate = '[DAY] [DATE] [MONTH] [YEAR]';
					days = FR_DAYS;
					months = FR_MONTHS;
					break;
					
				case(LANG_EN):
					safeDate = '[DAY], [MONTH] the [DATE] [YEAR]';
					days = EN_DAYS;
					months = EN_MONTHS;
					break;
			}
			
			safeDate = safeDate.split('[DAY]').join(days[date.day]);
			safeDate = safeDate.split('[DATE]').join(date.date);
			safeDate = safeDate.split('[MONTH]').join(months[date.month]);
			safeDate = safeDate.split('[YEAR]').join(date.fullYear);
			
			if (displayTime) {
				safeTime = safeTime.split('[HOURS]').join(convertNumber(date.hours.toString()));
				safeTime = safeTime.split('[MINUTES]').join(convertNumber(date.minutes.toString()));
				safeTime = safeTime.split('[SECONDS]').join(convertNumber(date.seconds.toString()));
				
				safeDate = safeDate + ' ' + safeTime;
			}
			
			return safeDate;
		}
		
		/**
		 * Convert Date to formated Object.
		 * 
		 * @param	date
		 * @param	lang : Only FR and EN at the moment
		 * @return
		 */
		public static function getSafeObject(date:Date, lang:String = 'fr'):Object {
			var object:Object = { };
			var days:Array;
			var months:Array;
			
			switch (lang) {
				case(LANG_FR):
				default:
					days = FR_DAYS;
					months = FR_MONTHS;
					break;
					
				case(LANG_EN):
					days = EN_DAYS;
					months = EN_MONTHS;
					break;
			}
			
			object.day = days[date.day];
			object.date = date.date;
			object.month = months[date.month];
			object.year = date.fullYear;
			object.hours = convertNumber(date.hours.toString());
			object.minutes = convertNumber(date.minutes.toString());
			object.seconds = convertNumber(date.seconds.toString());
			
			return object;
		}
		
		
		/**
		 * @private
		 */
		private static function convertNumber(value:String):String {
			if (value.length == 1) return '0' + value;
			
			return value;
		}
	}
}