<%--
 *  Copyright 2013 Society for Health Information Systems Programmes, India (HISP India)
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
 *  author: Ghanshyam
 *  date:   20-02-2013
--%>

<style>
.cell {
	border-top: 1px solid lightgrey;
	padding: 20px;
}

td.border {
	border-width: 1px;
	border-right: 0px;
	border-bottom: 1px;
	border-color: lightgrey;
	border-style: solid;
}

td.bottom {
	border-width: 1px;
	border-bottom: 1px;
	border-right: 0px;
	border-top: 0px;
	border-left: 0px;
	border-color: lightgrey;
	border-style: solid;
}
</style>
<script type="text/javascript">
	jQuery(document).ready(
			function() {

				// Fill data into address dropdowns
				PAGE.fillOptions("#districts", {
					data : MODEL.districts
				});
				PAGE.fillOptions("#upazilas", {
					data : MODEL.upazilas[0].split(',')
				});

				// Set value for patient information
				formValues = "patient.name==" + MODEL.patientName + "||";
				formValues += "patient.birthdate==" + MODEL.patientBirthdate
						+ "||";
				formValues += "patient.gender==" + MODEL.patientGender + "||";
				formValues += "patient.identifier==" + MODEL.patientIdentifier
						+ "||";
				formValues += "patient.gender==" + MODEL.patientGender[0]
						+ "||";
				formValues += "person.attribute.8=="
						+ MODEL.patientAttributes[8] + "||";

						formValues += "person.attribute.26=="
						+ MODEL.patientAttributes[26] + "||";
						
				formValues += "person.attribute.27=="
						+ MODEL.patientAttributes[27] + "||";

			
								
				attributes = MODEL.patientAttributes[14];
				jQuery.each(attributes.split(","), function(index, value) {
					jQuery("#patientRegistrationForm").fillForm(
							"person.attribute.14==" + value + "||");
				});				
								
				if (!StringUtils.isBlank(MODEL.patientAttributes[16])) {
					formValues += "person.attribute.16=="
							+ MODEL.patientAttributes[16] + "||";
				}
				
				if (!StringUtils.isBlank(MODEL.patientAttributes[20])) {
					formValues += "patient.attribute.20=="
							+ MODEL.patientAttributes[20] + "||";
				}
				if (!StringUtils.isBlank(MODEL.patientAttributes[25])) {
					formValues += "patient.attribute.25=="
							+ MODEL.patientAttributes[25] + "||";
				}
				
				if (!StringUtils.isBlank(MODEL.patientAttributes[28])) {
					formValues += "person.attribute.28=="
							+ MODEL.patientAttributes[28] + "||";
				}
				
				if (!StringUtils.isBlank(MODEL.patientAttributes[29])) {
					formValues += "person.attribute.29=="
							+ MODEL.patientAttributes[29] + "||";
				}
				
				if (!StringUtils.isBlank(MODEL.patientAttributes[30])) {
					formValues += "person.attribute.30=="
							+ MODEL.patientAttributes[30] + "||";
				}

				if (!StringUtils.isBlank(MODEL.patientAttributes[31])
						&& jQuery("#patCatChildLessThan5yr").attr('checked')) {
					jQuery("#patientRegistrationForm").fillForm(
							"person.attribute.31=="
									+ MODEL.patientAttributes[31] + "||");
				} else {
					jQuery("#exemptionField1").hide();
				}
				
				if (!StringUtils.isBlank(MODEL.patientAttributes[34])
						&& jQuery("#CCC").attr('checked')) {
					jQuery("#patientRegistrationForm").fillForm(
							"person.attribute.34=="
									+ MODEL.patientAttributes[34] + "||");
				} else {
					jQuery("#exemptionField2").hide();
				}
				
				if (!StringUtils.isBlank(MODEL.patientAttributes[35])
						&& jQuery("#patCatMother").attr('checked')) {
					jQuery("#patientRegistrationForm").fillForm(
							"person.attribute.35=="
									+ MODEL.patientAttributes[35] + "||");
				} else {
					jQuery("#exemptionField3").hide();
				}
				
				if (!StringUtils.isBlank(MODEL.patientAttributes[36])
						&& jQuery("#patCatNHIF").attr('checked')) {
					jQuery("#patientRegistrationForm").fillForm(
							"person.attribute.36=="
									+ MODEL.patientAttributes[36] + "||");
					jQuery("#patientRegistrationForm").fillForm(
							"person.attribute.33=="
									+ MODEL.patientAttributes[33] + "||");

					} else {
					jQuery("#exemptionField4").hide();
					jQuery("#nhifCardField").hide();
				}
				if (!StringUtils.isBlank(MODEL.patientAttributes[32])
						&& jQuery("#patCatFree").attr('checked')) {
					jQuery("#patientRegistrationForm").fillForm(
							"person.attribute.32=="
									+ MODEL.patientAttributes[32] + "||");
				} else {
					jQuery("#waverField").hide();
				}

				
				// Set value for address 
				addressParts = MODEL.patientAddress.split(',');
				formValues += "patient.address.postalAddress==" + StringUtils.trim(addressParts[0]) + "||";
				jQuery("#districts").val(StringUtils.trim(addressParts[2]));
				PAGE.changeDistrict();
				jQuery("#upazilas").val(StringUtils.trim(addressParts[1]));
				
				jQuery("#patientRegistrationForm").fillForm(formValues);
				PAGE.checkBirthDate();
				VALIDATORS.genderCheck();
				jQuery("#patientRegistrationForm").fillForm(
						"person.attribute.15==" + MODEL.patientAttributes[15]
								+ "||");


				// binding
				jQuery("#patCatChildLessThan5yr").click(function() {
					VALIDATORS.childYearCheck();
				});
				jQuery("#CCC").click(function() {
					VALIDATORS.cccCheck();
				});
				jQuery("#patCatGeneral").click(function() {
					VALIDATORS.generalCheck();
				});
				jQuery("#patCatMother").click(function() {
					VALIDATORS.motherCheck();
				});
				jQuery("#patCatFree").click(function() {
					VALIDATORS.freeCheck();
				});
				jQuery("#patCatNHIF").click(function() {
					VALIDATORS.nhifCheck();
				});

				jQuery("#sameAddress").click(function() {
					VALIDATORS.copyaddress();
				});

				jQuery('#calendar').datepicker({
					yearRange : 'c-100:c+100',
					dateFormat : 'dd/mm/yy',
					changeMonth : true,
					changeYear : true
				});
				jQuery('#birthdate').change(PAGE.checkBirthDate);
				
				//ghanshyam 25-feb-2013 New Requirement #966[Billing]Add Paid Bill/Add Free Bill for Bangladesh module(removed Patient Category)
				/*
				jQuery("#free").click(function() {
					VALIDATORS.freeCheck();
				});
				jQuery("#patCatGeneral").click(function() {
					VALIDATORS.generalCheck();
				});
				*/
				jQuery("#calendarButton").click(function() {
					jQuery("#calendar").datepicker("show");
				});
				jQuery("#calendar").change(function() {
					jQuery("#birthdate").val(jQuery(this).val());
					PAGE.checkBirthDate();
				});
				jQuery("#birthdate").click(function() {
					jQuery("#birthdate").select();
				});
				jQuery("#patientGender").change(function() {
					VALIDATORS.genderCheck();
				});

			});

	/**
	 ** FORM
	 **/
	PAGE = {
		/** SUBMIT */
		submit : function() {

			// Capitalize fullname and relative name
			fullNameInCapital = StringUtils.capitalize(jQuery("#patientName",
					jQuery("#patientRegistrationForm")).val());
			jQuery("#patientName", jQuery("#patientRegistrationForm")).val(
					fullNameInCapital);
			relativeNameInCaptital = StringUtils.capitalize(jQuery("#patientRelativeName").val());
			jQuery("#patientRelativeName").val(relativeNameInCaptital);

			otherNameInCaptital = StringUtils.capitalize(jQuery("#patientOtherName").val());
			jQuery("#patientOtherName").val(otherNameInCaptital);

			// Validate and submit
			if (this.validateRegisterForm()) {
				jQuery("#patientRegistrationForm")
						.mask(
								"<img src='" + openmrsContextPath + "/moduleResources/hospitalcore/ajax-loader.gif" + "'/>&nbsp;");
				jQuery("#patientRegistrationForm").ajaxSubmit(
						{
							success : function(responseText, statusText, xhr) {
								json = jQuery.parseJSON(responseText);
								if (json.status == "success") {
									window.location.href = openmrsContextPath
											+ "/findPatient.htm";
								} else {
									alert(json.message);
								}
								jQuery("#patientRegistrationForm").unmask();
							}
						});
			}
		},

		 //ghanshya,3-july-2013 #1962 Create validation for length of Health ID and National ID
		//Add Validation for checking duplicate National Id and Health Id
		checkHealthNationalID : function() {
		        patientId=MODEL.patientId;
		        healthId=jQuery("#patientHealthId").val();
				nationalId=jQuery("#patientNationalId").val();
				jQuery.ajax({
				type : "GET",
				url : getContextPath() + "/module/registration/validatenationalidandhealthidedit.form",
				data : ({
					patientId			: patientId,
					healthId			: healthId,
					nationalId			: nationalId
				}),
				success : function(data) {	
				    jQuery("#validationMessage").html(data);	
					 
		           } 
               });
			},	
		
		/** VALIDATE BIRTHDATE */
		checkBirthDate : function() {
			jQuery
					.ajax({
						type : "GET",
						url : getContextPath()
								+ "/module/registration/ajax/processPatientBirthDate.htm",
						data : ({
							birthdate : $("#birthdate").val()
						}),
						dataType : "json",
						success : function(json) {

							if (json.error == undefined) {
								if (json.estimated == "true") {
									jQuery("#birthdateEstimated").val("true")
								} else {
									jQuery("#birthdateEstimated").val("false");
								}

								jQuery("#estimatedAge").html(json.age);
								jQuery("#birthdate").val(json.birthdate);
							} else {
								alert(json.error);
								jQuery("#birthdate").val("");
							}
						},
						error : function(xhr, ajaxOptions, thrownError) {
							alert(thrownError);
						}
					});
		},

		/** FILL OPTIONS INTO SELECT 
		 * option = {
		 * 		data: list of values or string
		 *		index: list of corresponding indexes
		 *		delimiter: seperator for value and label
		 *		optionDelimiter: seperator for options
		 * }
		 */
		fillOptions : function(divId, option) {
			jQuery(divId).empty();
			if (option.delimiter == undefined) {
				if (option.index == undefined) {
					jQuery.each(option.data, function(index, value) {
						if (value.length > 0) {
							jQuery(divId).append(
									"<option value='" + value + "'>" + value
											+ "</option>");
						}
					});
				} else {
					jQuery.each(option.data, function(index, value) {
						if (value.length > 0) {
							jQuery(divId).append(
									"<option value='" + option.index[index] + "'>"
											+ value + "</option>");
						}
					});
				}
			} else {

				options = option.data.split(option.optionDelimiter);
				jQuery.each(options, function(index, value) {

					values = value.split(option.delimiter);
					optionValue = values[0];
					optionLabel = values[1];
					if (optionLabel != undefined) {
						if (optionLabel.length > 0) {
							jQuery(divId).append(
									"<option value='" + optionValue + "'>"
											+ optionLabel + "</option>");
						}
					}

				});
			}
		},

		/** CHANGE DISTRICT */
		changeDistrict : function() {

			// get the list of upazilas
			upazilaList = "";
			selectedDistrict = jQuery("#districts option:checked").val();
			jQuery.each(MODEL.districts, function(index, value) {
				if (value == selectedDistrict) {
					upazilaList = MODEL.upazilas[index];
				}
			});

			// fill upazilas into upazila dropdown
			this.fillOptions("#upazilas", {
				data : upazilaList.split(",")
			});
		},

		/** VALIDATE FORM */
		validateRegisterForm : function() {

			if (StringUtils.isBlank(jQuery("#patientName").val())) {
				alert("Please enter patient name");
				return false;
			}
			else {
				value = jQuery("#patientName").val();
				value = value.toUpperCase();
				pattern = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789 -";
				for (i = 0; i < value.length; i++) {
					if (pattern.indexOf(value[i]) < 0) {
						alert("Please enter patient name/identifier in correct format.");
						return false;
					}
				}
			}

			if (StringUtils.isBlank(jQuery("#patientRelativeName").val())) {
				alert("Please enter relative name");
				return false;
			} else {
				if (jQuery("#patientRegistrationForm input[name=person.attribute.15]:checked").length == 0) {
					alert("Please select relative name type");
					return false;
				}
			}

			if (StringUtils.isBlank(jQuery("#birthdate").val())) {
				alert("Please enter birthdate or age");
				return false;
			}

			if (jQuery("#patientGender").val() == "Any") {
				alert("Please select gender");
				return false;
			}
			
			if (jQuery("#patientMaritalStatus").val() == "Marital") {
				alert("Please select Marital Status of Patient");
				return false;
			} 
			
			if (StringUtils.isBlank(jQuery("#patientPostalAddress").val())) {
				alert("Please enter physical address of Patient");
				return false;
			} 
			
			if (jQuery("#patientOtherName").val() == "") {
				alert("Please select patients other name");
				return false;
			} 
            //ghanshyam 25-feb-2013 New Requirement #966[Billing]Add Paid Bill/Add Free Bill for Bangladesh module(removed Patient Category)
            /*
			if (!VALIDATORS.validatePatientCategory()) {
				return false;
			}
			*/

			if (!StringUtils.isBlank(jQuery("#patientPhoneNumber").val())) {
				if (!StringUtils.isDigit(jQuery("#patientPhoneNumber").val())) {
					alert("Please enter phone number in correct format");
					return false;
				}
			}

			if (!StringUtils.isBlank(jQuery("#relativePhoneNumber").val())) {
				if (!StringUtils.isDigit(jQuery("#relativePhoneNumber").val())) {
					alert("Please enter relative phone number in correct format");
					return false;
				}
			}


			if (jQuery("#patCatGeneral").attr('checked') == false
					&& jQuery("#patCatChildLessThan5yr").attr('checked') == false
					&& jQuery("#CCC").attr('checked') == false
					&& jQuery("#patCatMother").attr('checked') == false
					&& jQuery("#patCatFree").attr('checked') == false
					&& jQuery("#patCatNHIF").attr('checked') == false) {
				alert('You didn\'t choose any of the patient categories!');
				return false;
			} else {
				if (jQuery("#patCatChildLessThan5yr").attr('checked')) {
					if (jQuery("#exemptionNumber1").val().length <= 0) {
						alert('Please fill Exemption number');
						return false;
					}
				}
				if (jQuery("#CCC").attr('checked')) {
					if (jQuery("#exemptionNumber2").val().length <= 0) {
						alert('Please fill Exemption number');
						return false;
					}
				}

				if (jQuery("#patCatMother").attr('checked')) {
					if (jQuery("#exemptionNumber3").val().length <= 0) {
						alert('Please fill Exemption number');
						return false;
					}
				}
				
				if (jQuery("#patCatFree").attr('checked')) {
					if (jQuery("#waverNumber").val().length <= 0) {
						alert('Please fill Waver number');
						return false;
					}
				}
				
				if (jQuery("#patCatNHIF").attr('checked')) {
					if (jQuery("#exemptionNumber4").val().length <= 0 || jQuery("#nhifCardNumber").val().length <= 0) {
						alert('Please fill Both Exemption number and NHIF Card Number');
						return false;
					}
				}
			}		
			
		/*	        //ghanshya,3-july-2013 #1962 Create validation for length of Health ID and National ID
			       //Add Validation for checking duplicate National Id and Health Id
			        PAGE.checkHealthNationalID();
		            alert("click ok to proceed");
		            abc=jQuery("#abc").val();
					def=jQuery("#def").val();
					nd=jQuery("#nId").val();
					hd=jQuery("#hId").val();
					nId=jQuery("#nId").val();
					hId=jQuery("#hId").val();
				
					if(typeof nId!="undefined" || typeof hId!="undefined"){
					if(nId=="1" && hId=="1"){
					//document.getElementById("nationalIdValidationMessage").innerHTML="Patient already registered with this National id";
					//document.getElementById("healthIdValidationMessage").innerHTML="Patient already registered with this Health id";
                    //jQuery("#nationalIdValidationMessage").show();
                    //jQuery("#healthIdValidationMessage").show();
		            alert("Patient already registered with this National id and Health id");
					return false
		            }
		            else if(nId=="1"){
                    //document.getElementById("nationalIdValidationMessage").innerHTML="Patient already registered with this National id";
                    //jQuery("#nationalIdValidationMessage").show();
                    //jQuery("#healthIdValidationMessage").hide();
		            alert("Patient already registered with this National id");
                    return false;					
		            }
		            else if(hId=="1"){
		             //document.getElementById("healthIdValidationMessage").innerHTML="Patient already registered with this Health id";
                     //jQuery("#healthIdValidationMessage").show();
                     //jQuery("#nationalIdValidationMessage").hide();
		             alert("Patient already registered with this Health id");	
					 return false;
		            }
		            }
		            else{
		            alert("please try again");
		            return false;
		            }
*/
			return true;
		}
	};

	/**
	 ** VALIDATORS
	 **/
	 VALIDATORS = {

	/** VALIDATE PATIENT CATEGORY */
		
		validatePatientCategory : function() {
			if (jQuery("#patCatGeneral").attr('checked') == false
					&& jQuery("#patCatChildLessThan5yr").attr('checked') == false
					&& jQuery("#CCC").attr('checked') == false
					&& jQuery("#patCatMother").attr('checked') == false
					&& jQuery("#patCatFree").attr('checked') == false
					&& jQuery("#patCatNHIF").attr('checked') == false) {
				alert('You didn\'t choose any of the patient categories!');
				return false;
			} else {
				if (jQuery("#patCatChildLessThan5yr").attr('checked')) {
					if (jQuery("#exemptionNumber1").val().length <= 0) {
						alert('Please fill Exemption number');
						return false;
					}
				}
				if (jQuery("#CCC").attr('checked')) {
					if (jQuery("#exemptionNumber2").val().length <= 0) {
						alert('Please fill Exemption number');
						return false;
					}
				}

				if (jQuery("#patCatMother").attr('checked')) {
					if (jQuery("#exemptionNumber3").val().length <= 0) {
						alert('Please fill Exemption number');
						return false;
					}
				}
				
				if (jQuery("#patCatFree").attr('checked')) {
					if (jQuery("#waverNumber").val().length <= 0) {
						alert('Please fill Waver number');
						return false;
					}
				}
				
				if (jQuery("#patCatNHIF").attr('checked')) {
					if (jQuery("#exemptionNumber4").val().length <= 0 || jQuery("#nhifCardNumber").val().length <= 0) {
						alert('Please fill Both Exemption number and NHIF Card Number');
						return false;
					}
				}
				
				return true;
			}
		},

		/** CHECK WHEN child < 5 yr CATEGORY IS SELECTED */
		childYearCheck : function() {
			if (jQuery("#patCatChildLessThan5yr").is(':checked')) {
				jQuery("#exemptionField1").show();
				if (jQuery("#patCatGeneral").is(":checked")) {
					jQuery("#patCatGeneral").removeAttr("checked");
				}
				
					jQuery("#CCC").removeAttr("checked");
					jQuery("#exemptionNumber2").val("");
					jQuery("#exemptionField2").hide();
				
					jQuery("#patCatMother").removeAttr("checked");
				    jQuery("#exemptionNumber3").val("");
					jQuery("#exemptionField3").hide();
				
					jQuery("#patCatFree").removeAttr("checked");
					jQuery("#waverNumber").val("");
					jQuery("#waverField").hide();
				
					jQuery("#patCatNHIF").removeAttr("checked");
					jQuery("#exemptionNumber4").val("");
					jQuery("#exemptionField4").hide();
					jQuery("#nhifCardNumber").val("");
					jQuery("#nhifCardField").hide();
			}
			else {
			jQuery("#exemptionNumber1").val("");
			jQuery("#exemptionField1").hide();
			}
		},

		/** CHECK WHEN CCC CATEGORY IS SELECTED */
		cccCheck : function() {
			if (jQuery("#CCC").is(':checked')) {
				jQuery("#exemptionField2").show();
				if (jQuery("#patCatGeneral").is(":checked")) {
					jQuery("#patCatGeneral").removeAttr("checked");
				}
				
					jQuery("#patCatChildLessThan5yr").removeAttr("checked");
					jQuery("#exemptionNumber1").val("");
					jQuery("#exemptionField1").hide();
				
					jQuery("#patCatMother").removeAttr("checked");
				    jQuery("#exemptionNumber3").val("");
					jQuery("#exemptionField3").hide();
				
					jQuery("#patCatFree").removeAttr("checked");
					jQuery("#waverNumber").val("");
					jQuery("#waverField").hide();
				

					jQuery("#patCatNHIF").removeAttr("checked");
					jQuery("#exemptionNumber4").val("");
					jQuery("#exemptionField4").hide();
					jQuery("#nhifCardNumber").val("");
					jQuery("#nhifCardField").hide();
			}
			else {
			jQuery("#exemptionNumber2").val("");
			jQuery("#exemptionField2").hide();
			}
		},
		
		/** CHECK WHEN GENERAL CATEGORY IS SELECTED */
		generalCheck : function(obj) {
			if (jQuery("#patCatGeneral").is(':checked')) {
				
					jQuery("#CCC").removeAttr("checked");
					jQuery("#exemptionNumber2").val("");
					jQuery("#exemptionField2").hide();
				
					jQuery("#patCatChildLessThan5yr").removeAttr("checked");
					jQuery("#exemptionNumber1").val("");
					jQuery("#exemptionField1").hide();
				
					jQuery("#patCatMother").removeAttr("checked");
					jQuery("#exemptionNumber3").val("");
					jQuery("#exemptionField3").removeAttr("checked");
				
					jQuery("#patCatFree").removeAttr("checked");
					jQuery("#waverNumber").val("");
					jQuery("#waverField").hide();
				
					jQuery("#patCatNHIF").removeAttr("checked");
					jQuery("#exemptionNumber4").val("");
					jQuery("#exemptionField4").hide();
					jQuery("#nhifCardNumber").val("");
					jQuery("#nhifCardField").hide();

			}
		},
		
		/** CHECK WHEN Expectant mother CATEGORY IS SELECTED */
		motherCheck : function() {
			if (jQuery("#patCatMother").is(':checked')) {
				jQuery("#exemptionField3").show();
				if (jQuery("#patCatGeneral").is(":checked")) {
					jQuery("#patCatGeneral").removeAttr("checked");
				}
				
					jQuery("#patCatChildLessThan5yr").removeAttr("checked");
					jQuery("#exemptionNumber1").val("");
					jQuery("#exemptionField1").hide();
				
					jQuery("#CCC").removeAttr("checked");
				    jQuery("#exemptionNumber2").val("");
					jQuery("#exemptionField2").hide();
				
					jQuery("#patCatFree").removeAttr("checked");
					jQuery("#waverNumber").val("");
					jQuery("#waverField").hide();
				
					jQuery("#patCatNHIF").removeAttr("checked");
					jQuery("#exemptionNumber4").val("");
					jQuery("#exemptionField4").hide();
					jQuery("#nhifCardNumber").val("");
					jQuery("#nhifCardField").hide();

				
				if (jQuery("#patientGender").val() == "M") {
					jQuery("#patCatMother").removeAttr("checked");
					jQuery("#exemptionNumber3").val("");
					jQuery("#exemptionField3").hide();
					alert("Expectant Mother can not be Male");
				}

			}
			else {
			jQuery("#exemptionNumber3").val("");
			jQuery("#exemptionField3").hide();
			}
		},

		/** CHECK WHEN Free CATEGORY IS SELECTED */
		freeCheck : function() {
			if (jQuery("#patCatFree").is(':checked')) {
				jQuery("#waverField").show();
				if (jQuery("#patCatGeneral").is(":checked")) {
					jQuery("#patCatGeneral").removeAttr("checked");
				}
				
					jQuery("#patCatChildLessThan5yr").removeAttr("checked");
					jQuery("#exemptionNumber1").val("");
					jQuery("#exemptionField1").hide();
				
					jQuery("#CCC").removeAttr("checked");
				    jQuery("#exemptionNumber2").val("");
					jQuery("#exemptionField2").hide();
				
					jQuery("#patCatMother").removeAttr("checked");
					jQuery("#exemptionNumber3").val("");
					jQuery("#exemptionField3").hide();
				
					jQuery("#patCatNHIF").removeAttr("checked");
					jQuery("#exemptionNumber4").val("");
					jQuery("#exemptionField4").hide();
					jQuery("#nhifCardNumber").val("");
					jQuery("#nhifCardField").hide();

			}
			else {
			jQuery("#waverNumber").val("");
			jQuery("#waverField").hide();
			}
		},

		/** CHECK WHEN Free CATEGORY IS SELECTED */
		nhifCheck : function() {
			if (jQuery("#patCatNHIF").is(':checked')) {
				jQuery("#exemptionField4").show();
				jQuery("#nhifCardField").show();
				if (jQuery("#patCatGeneral").is(":checked")) {
					jQuery("#patCatGeneral").removeAttr("checked");
				}
				
					jQuery("#patCatChildLessThan5yr").removeAttr("checked");
					jQuery("#exemptionNumber1").val("");
					jQuery("#exemptionField1").hide();
				
					jQuery("#CCC").removeAttr("checked");
				    jQuery("#exemptionNumber2").val("");
					jQuery("#exemptionField2").hide();
				
					jQuery("#patCatMother").removeAttr("checked");
					jQuery("#exemptionNumber3").val("");
					jQuery("#exemptionField3").hide();
				
					jQuery("#patCatFree").removeAttr("checked");
					jQuery("#waverNumber").val("");
					jQuery("#waverField").hide();
				
			}
			else {
			jQuery("#exemptionNumber4").val("");
			jQuery("#exemptionField4").hide();
			jQuery("#nhifCardNumber").val("");
			jQuery("#nhifCardField").hide();
			
			}
			
		},

		
		copyaddress : function () {
			if (jQuery("#sameAddress").is(':checked')) {
				jQuery("#relativePostalAddress").val(jQuery("#patientPostalAddress").val());
					
			
		}
		},
		
		checkPatientAgeForChildLessThan5yr : function() {
			// check whether patient age less than five year
			estAge = jQuery("#estimatedAge").html();
			var digitPattern = /year/;
			var age = digitPattern.exec(estAge);
			if (age) {
				if (jQuery("#patCatChildLessThan1yr").is(':checked')) {
					alert("Child less than one year is only for patient under 5 year!");
					return false;
				}
			}
			return true;
		},

				/*
				 * Check patient gender
				 */
				genderCheck : function() {

					jQuery("#patientRelativeNameSection").empty();
					if (jQuery("#patientGender").val() == "M") {
						jQuery("#patientRelativeNameSection")
								.html(
										'<input type="radio" name="person.attribute.15" value="Son of" checked="checked"/> Son of');
					} else if(jQuery("#patientGender").val() == "F"){
						jQuery("#patientRelativeNameSection")
								.html(
										'<input type="radio" name="person.attribute.15" value="Daughter of"/> Daughter of <input type="radio" name="person.attribute.15" value="Wife of"/> Wife of');
					}
				},
			};
</script>
<h3 align="center" style="color:red">WORK IN PROGRESS</h3>
<h2>Patient Registration</h2>
<div id="patientSearchResult"></div>
<form id="patientRegistrationForm" method="POST">
	<table cellspacing="0">
		<tr>
			<td valign="top" class="cell"><b>Patient Surname *</b></td>
			<td class="cell"><input id="patientName" name="patient.name" style="width: 300px;"/>
			<td class="cell"><b>ID Number * &nbsp;&nbsp; <input readonly
					name="patient.identifier" style="border: none; width: 250px;" /> </b>
			</td>

		</tr>
		
		<tr>
			<td valign="top" class="cell"><b>Other Name *</b></td>
			<td class="cell"><input id="patientOtherName" name="patient.attribute.25"  style="width: 300px;"/>
			<td><b>&nbsp;&nbsp; &nbsp;  National ID:</b><input id="patientNationalId" name="patient.attribute.20" />
			<td><span style="color: red;" id="nationalIdValidationMessage"> </span>
			</td>
			</td>	
		</tr>
		
		<tr>
			<td class="cell"><b>Demographics *</b></td>
			<td class="cell">dd/mm/yyyy<br />
				<table>
					<tr>
						<td>Age Or Date of Birth</td>
						<td></td>
						<td>Gender</td>
					</tr>
					<tr>
						<td><input type="hidden" id="calendar" /> <input
							id="birthdate" name="patient.birthdate" /> <img
							id="calendarButton"
							src="moduleResources/registration/calendar.gif" /> <input
							id="birthdateEstimated" type="hidden"
							name="patient.birthdateEstimate" value="true" /></td>
						<td><span id="estimatedAge"></span></td>
							<td><select id="patientGender" name="patient.gender">
								<option value="Any"></option>
								<option value="M">Male</option>
								<option value="F">Female</option>
						</select></td>

					</tr>
					<tr>
						<td>Marital Status</td>
					</tr>
					<tr>	
						<td><select id="patientMaritalStatus" name="person.attribute.26">
										<option value="Marital"></option>
										<option value="Single">Single</option>
										<option value="Married">Married</option>
										<option value="Divorced">Divorced</option>
										<option value="Spouse Dead">Spouse Dead</option>
								</select></td>
					</tr>
				</table>
				</td>
			
				<td rowspan="3" class="border">
					<b>&nbsp;&nbsp;Patient category</b><br />
					<table cellspacing="5">
						<tr>
							<td><input id="patCatGeneral" type="checkbox"
								name="person.attribute.14" value="General" /> General</td>
							<td><input id="patCatChildLessThan5yr" type="checkbox"
								name="person.attribute.14" value="Child Less Than 5 yr" />Child less than 5 year old</td>
							<td><span id="exemptionField1">Exemption Number <input
									id="exemptionNumber1" name="person.attribute.31" />
							</span>
							</td>	
						</tr>
						<tr>
						<td></td>
						<td><input id="CCC" type="checkbox"
								name="person.attribute.14" value="CCC" /> Comprehensive Care Clinic (CCC) Patient</td>
							<td><span id="exemptionField2">Exemption Number <input
									id="exemptionNumber2" name="person.attribute.34" />
							</span>
							</td>
						</tr>
						<tr>
							<td></td>
							<td><input id="patCatMother" type="checkbox"
								name="person.attribute.14" value="Expectant Mother" /> Expectant Mothers </td>
								<td><span id="exemptionField3">Exemption Number <input
									id="exemptionNumber3" name="person.attribute.35" />
							</span>
							</td>
						</tr>
						
						<tr>
							<td></td>
							<td><input id="patCatFree" type="checkbox"
								name="person.attribute.14" value="Waver" /> Waiver</td>
								<td><span id="waverField">Waiver Number&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; <input
									id="waverNumber" name="person.attribute.32" />
							</span>
							</td>
						</tr>
						<tr>
							<td></td>
							<td><input id="patCatNHIF" type="checkbox"
								name="person.attribute.14" value="NHIF" /> NHIF Card Holder</td>
							<td><span id="exemptionField4">Exemption Number <input
									id="exemptionNumber4" name="person.attribute.36" />
							</span>
							</td>
						</tr>
						<tr>
							<td>&nbsp;</td>
							<td>&nbsp;</td>
							<td><span id="nhifCardField">NHIF Card ID &nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp; <input
									id="nhifCardNumber" name="person.attribute.33" />
							</span>
							</td>
						</tr>

					</table>
				</td>
				
			
			
		</tr>

		<tr>
		</tr>

		<tr>
			<td class="cell"><b>Address</b></td>
			<td class="cell">
				<table>
					<tr>
						<td>Physical Residence *</td>
						<td><input id="patientPostalAddress"
							name="patient.address.postalAddress" style="width: 300px;" /></td>
					</tr>
					<tr>
						<td>County:</td>
						<td><select id="districts" name="patient.address.district"
							onChange="PAGE.changeDistrict();" style="width: 200px;">
						</select></td>
					</tr>
					<tr>
						<td>Sub-County:</td>
						<td><select id="upazilas" name="patient.address.upazila"
							style="width: 200px;">
						</select></td>
					</tr>
					<tr>
						<td>Nationality:</td>
						<td><select id="patientNation" name="person.attribute.27">
										<option value="Nation"></option>
										<option value="S">East Africa Kenya</option>
										<option value="M">East Africa</option>
										<option value="D">Kenyan</option>
						</select></td>
						</tr>

				</table>
			</td>
		</tr>
		<tr>
			<td class="cell"><b>Contact Number</b></td>
			<td class="cell"><input id="patientPhoneNumber"
				name="person.attribute.16" style="width: 200px;" /></td>
		</tr>
		
		<tr>
			<td class="cell"><b>Next of Kin (NOK) Information</b></td>
			<td class="cell">
				<table>
					<tr>
						<td>&nbsp;</td><td>
						<div id="patientRelativeNameSection"></div> </td>
					</tr>
					<tr>
						<td>Relative Name</td>
						<td>
							<input
							id="patientRelativeName" name="person.attribute.8"
							style="width: 200px;" />
						</td>
					</tr>
					<tr>
						<td>Physical Residence</td>
						<td><input type="text" id="relativePostalAddress"
							name="person.attribute.28" style="width: 200px;" /></td>
						<td><input id="sameAddress" type="checkbox"/> Same as Above</td>
					</tr>
					<tr>
						<td>Contact Number</td>
						<td><input id="relativePhoneNumber"
							name="person.attribute.29" style="width: 200px;" /></td>
						</select></td>
					</tr>
					<tr>
						<td>Email Address</td>
						<td><input id="relativeEmail"
							name="person.attribute.30" style="width: 200px;" /></td>
					</tr>
				</table>
			
		</tr>
		<tr>
		</tr>
		<tr>
			<td colspan="3" style="padding: 0em 30em 0em 30em;"><input
				type="button" value="Save" onclick="PAGE.submit();" /> <input
				type="button" value="Reset"
				onclick="window.location.href=window.location.href" />
			</td>
		</tr>
	</table>
</form>