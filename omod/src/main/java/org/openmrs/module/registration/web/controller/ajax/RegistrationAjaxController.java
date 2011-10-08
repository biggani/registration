/**
 *  Copyright 2011 Health Information Systems Project of India
 *
 *  This file is part of Registration module.
 *
 *  Registration module is free software: you can redistribute it and/or modify
 *  it under the terms of the GNU General Public License as published by
 *  the Free Software Foundation, either version 3 of the License, or
 *  (at your option) any later version.

 *  Registration module is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU General Public License for more details.
 *
 *  You should have received a copy of the GNU General Public License
 *  along with Registration module.  If not, see <http://www.gnu.org/licenses/>.
 *
 **/

package org.openmrs.module.registration.web.controller.ajax;

import java.io.IOException;
import java.io.PrintWriter;
import java.math.BigDecimal;
import java.text.ParseException;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang.StringUtils;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.openmrs.Patient;
import org.openmrs.api.context.Context;
import org.openmrs.module.hospitalcore.util.DateUtils;
import org.openmrs.module.hospitalcore.util.GlobalPropertyUtil;
import org.openmrs.module.registration.RegistrationService;
import org.openmrs.module.registration.model.RegistrationFee;
import org.openmrs.module.registration.util.RegistrationConstants;
import org.openmrs.module.registration.util.RegistrationUtils;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

@Controller("RegistrationAjaxController")
public class RegistrationAjaxController {

	private static Log logger = LogFactory
			.getLog(RegistrationAjaxController.class);

	/**
	 * process patient birth date
	 * 
	 * @param birthdate
	 * @param model
	 * @return
	 * @throws ParseException
	 */
	@RequestMapping(value = "/module/registration/ajax/processPatientBirthDate.htm", method = RequestMethod.GET)
	public String processPatientBirthDate(
			@RequestParam("birthdate") String birthdate, Model model)
			throws ParseException {

		Map<String, Object> json = new HashMap<String, Object>();

		// try to parse date
		// if success -> it's a birthdate
		// otherwise -> it's an age
		Date date = null;
		try {
			date = RegistrationUtils.parseDate(birthdate);
		} catch (ParseException e) {

		}

		if (date != null) {

			// the user entered the correct birthdate
			json.put("estimated", false);
			json.put("birthdate", birthdate);
			json.put("age", estimateAge(birthdate));
			logger.info("User entered the correct birthdate.");

		} else {

			// the user entered an age
			// Integer age = Integer.parseInt(birthdate);
			// json.put("estimated", true);
			// 
			// json.put("birthdate", estimatedBirthdate);
			// json.put("age", estimateAge(estimatedBirthdate));
			// logger.info("User entered an estimated age.");

			// check the last letter of birthdate. if no letter found, the
			// default 'y' will be added.
			String lastLetter = birthdate.substring(birthdate.length() - 1);
			if (!StringUtils.isAlpha(lastLetter)) {
				birthdate += "y";
			}
			json.put("estimated", true);
			String estimatedBirthdate = getEstimatedBirthdate(birthdate);
			json.put("birthdate", estimatedBirthdate);
			json.put("age", estimateAge(estimatedBirthdate));
		}
		model.addAttribute("json", json);
		return "/module/registration/ajax/processPatientBirthDate";
	}

	/*
	 * Estimate the birthdate by age
	 * 
	 * @param age
	 * 
	 * @return
	 */
	private String getEstimatedBirthdate(String text) {
		text = text.toLowerCase();
		String age = text.substring(0, text.length() - 1);
		String type = text.substring(text.length() - 1);
		Calendar date = Calendar.getInstance();
		if (type.equalsIgnoreCase("y")) {
			date.add(Calendar.YEAR, -Integer.parseInt(age));
			return "01/01/" + date.get(Calendar.YEAR);
		} else if(type.equalsIgnoreCase("m")){
			date.add(Calendar.MONTH, -Integer.parseInt(age));
		} else if(type.equalsIgnoreCase("w")){
			date.add(Calendar.WEEK_OF_YEAR, -Integer.parseInt(age));
		} else if(type.equalsIgnoreCase("d")){
			date.add(Calendar.DATE, -Integer.parseInt(age));
		}
		return RegistrationUtils.formatDate(date.getTime());
	}

	/*
	 * Estimate the year by birthdate
	 * 
	 * @param birthdate
	 * 
	 * @return
	 * 
	 * @throws ParseException
	 */
	private String estimateAge(String birthdate) throws ParseException {
		Date date = RegistrationUtils.parseDate(birthdate);
		int years = DateUtils.getAgeFromBirthday(date);
		if (years > 1) {
			return String.format("~ %s years old", years);
		} else {
			return "~ 1 year old";
		}
	}

	@RequestMapping(value = "/module/registration/ajax/buySlip.htm", method = RequestMethod.GET)
	public void buySlip(@RequestParam("patientId") Integer patientId,
			Model model, HttpServletResponse response) throws IOException {
		response.setContentType("text/html;charset=UTF-8");
		PrintWriter out = response.getWriter();
		RegistrationFee fee = new RegistrationFee();
		Patient patient = Context.getPatientService().getPatient(patientId);
		fee.setPatient(patient);
		fee.setCreatedOn(new Date());
		fee.setCreatedBy(Context.getAuthenticatedUser());
		fee.setFee(new BigDecimal(GlobalPropertyUtil.getInteger(
				RegistrationConstants.PROPERTY_REGISTRATION_FEE, 0)));
		Context.getService(RegistrationService.class).saveRegistrationFee(fee);
		out.print("success");
	}
}