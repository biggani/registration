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

<script type="text/javascript">
	jQuery(document).ready(function(){		
		jQuery("#patientId").val(MODEL.patientId);
		jQuery("#revisit").val(MODEL.revisit);
		jQuery("#identifier").html(MODEL.patientIdentifier);
		jQuery("#age").html(MODEL.patientAge);
		jQuery("#name").html(MODEL.patientName);
		
	    //ghanshyam  20-may-2013 #1648 capture Health ID and Registration Fee Type
		jQuery("#freeRegField").hide();
		//ghanshyam 17-june-2013 (note:commented below line as per chahat suggestion for issue #1648)
	    //jQuery("#paidReg").attr("checked", "checked");
	    jQuery("#freeReg").click(function() {
		VALIDATORS.freeRegCheck();
		});
		jQuery("#paidReg").click(function() {
		VALIDATORS.paidRegCheck();
		});
				
		
		// ghanshyam 27-02-2013 Feedback #966[Billing]Add Paid Bill/Add Free Bill for Bangladesh module(remove category from registration,OPD,IPD,Inventory)
		/*
		if(MODEL.patientAttributes[14]){
			pattern = /[A-Z]+[,][A-Z]/;
			if(pattern.test(MODEL.patientAttributes[14])){

				jQuery("#FREE").html("Free Reason.: " + MODEL.patientAttributes[19]);


			}else{			
				if("Free" == MODEL.patientAttributes[14])
					jQuery("#FREE").html(MODEL.patientAttributes[19]);
			
                jQuery("#category").html(MODEL.patientAttributes[14]);
			}
								
		}
		*/
		
        jQuery("#nationalId").html(MODEL.patientAttributes[20]);
        //ghanshyam  20-may-2013 #1648 capture Health ID and Registration Fee Type
        jQuery("#healthId").html(MODEL.patientAttributes[24]);
		jQuery("#phoneNumber").html(MODEL.patientAttributes[16]);
		jQuery("#maritalStatus").html(MODEL.patientAttributes[26]);
		jQuery("#othername").html(MODEL.patientAttributes[25]);
		jQuery("#gender").html(MODEL.patientGender);
		jQuery("#datetime").html(MODEL.currentDateTime);
		jQuery("#othername1").html(MODEL.patientAttributes[25]+" "+MODEL.patientName);
		//ghanshyam,11-dec-2013,#3327 Defining patient categories based on Kenyan requirements
		if(!StringUtils.isBlank(MODEL.selectedCategory)){			
			jQuery("#patientCategory").val(MODEL.selectedCategory);
			jQuery("#patientCategory").attr("disabled", "disabled");
		}
		MODEL.OPDs = " ,Please select an Triage to visit|" + MODEL.OPDs;
		PAGE.fillOptions("#opdWard", {
			data:MODEL.OPDs,
			delimiter: ",",
			optionDelimiter: "|"
		});
		
		// Set the selected OPD
		if(!StringUtils.isBlank(MODEL.selectedOPD)){			
			jQuery("#opdWard").val(MODEL.selectedOPD);
			jQuery("#opdWard").attr("disabled", "disabled");
		}
		
		jQuery("#buySlip").hide();
		

		
		jQuery("#exe_wav_number").hide();
		jQuery("#nhif_number").hide();
		jQuery("#exemptionField2").hide();
		jQuery("#waiverField").hide();
		jQuery("#exemptionField1").hide();
		jQuery("#exemptionField3").hide();
		jQuery("#exemptionField4").hide();
		jQuery("#nhif").hide();
		
		//Category Check
		jQuery("#patientCategory").change(function() {
			VALIDATORS.categoryCheck();
		});

		
		// Set data for reprint page
		if(MODEL.reprint=="true"){
			var opdWardId=MODEL.opdWardId;
		jQuery("#opdWard").val(MODEL.observations[opdWardId]);
		
			var tempCategoryId=MODEL.tempCategoryId;
			if(!StringUtils.isBlank(MODEL.observations[tempCategoryId])){
			
				jQuery.each(MODEL.observations[tempCategoryId].split(","), function(index, value){
					jQuery("input[name=temporary.attribute.11][value='" + value + "']").attr("checked", "checked");
				});	}
			jQuery("#printSlip").hide();
			jQuery("#save").hide();
			//ghanshyam  20-may-2013 #1648 capture Health ID and Registration Fee Type
			jQuery("#regFee").hide()
			jQuery("#tempCat").hide();
		} else {
			jQuery("#reprint").hide();
			//ghanshyam  20-may-2013 #1648 capture Health ID and Registration Fee Type
			jQuery("#regFee").hide()
			jQuery("#tempCat").hide();
		}
		
	});
	
	/**
	 ** PAGE METHODS
	 **/
	PAGE = {
		/** Validate and submit */
		submit: function(reprint){
		
			if(PAGE.validate()){
				
				// Hide print button
				jQuery("#printSlip").hide();
				jQuery("#reprint").hide();
				
				// Convert OPDWard dropdown to printable format
				jQuery("#opdWard").hide();
				jQuery("#opdWard").after("<span>" + jQuery("#opdWard option:checked").html() +  "</span>");	
				
				//ghanshyam  20-may-2013 #1648 capture Health ID and Registration Fee Type	
                 jQuery("#regFeeType input").each(function(index, value){				
					if(jQuery(value).is(":checked")){
						jQuery("#printableRegFee").append("<span style='margin:5px;'>" + jQuery(value).val() + "</span>");
						jQuery("#regFee").show();		
					}
				});
				jQuery("#regFeeType").hide();
				
				// Convert temporary categories to printable format
				jQuery("#temporaryCategories input").each(function(index, value){				
					if(jQuery(value).is(":checked")){
						jQuery("#printableTemporaryCategories").append("<span style='margin:5px;'>" + jQuery(value).val() + "</span>");
						jQuery("#tempCat").show();		
					}
				});
				
/*				Sagar Bele, 11-01-2013: Issue #663 Registration alignment				
				if(!StringUtils.isBlank(jQuery("#printableTemporaryCategories").html())){
					jQuery("#printableTemporaryCategories").prepend("<b>Temporary Categories:</b>");
				}
*/				
				jQuery("#temporaryCategories").hide();
//				jQuery("#tempCat").show();
				
				// submit form and print		
				if(!reprint){
					jQuery("#patientInfoForm").ajaxSubmit({
						success: function (responseText, statusText, xhr){
							if(responseText=="success"){						
								PAGE.print();
								window.location.href = getContextPath() + "/findPatient.htm";
							}					
						}
					});
				} else {
					PAGE.print();
					window.location.href = getContextPath() + "/findPatient.htm";
				}
				
			}
		},
		
		// Print the slip
		print: function(){
			jQuery("#patientInfoPrintArea").printArea({
				mode : "popup",
				popClose : true
			});
		},
		
		// harsh #244 Added a save button.
		save: function(){
			if (PAGE.validate()){
			var save=document.getElementById("save");
			if(save==save){
			document.getElementById("save").disabled = true;
			}
			jQuery("#patientInfoForm").ajaxSubmit({
				success: function (responseText, statusText, xhr){
					if(responseText=="success"){						
					
						window.location.href = getContextPath() + "/findPatient.htm";
					}					
				}
			});
			}
			},

		
		
		/** FILL OPTIONS INTO SELECT 
		 * option = {
		 * 		data: list of values or string
		 *		index: list of corresponding indexes
		 *		delimiter: seperator for value and label
		 *		optionDelimiter: seperator for options
		 * }
		 */
		fillOptions: function(divId, option) {
			jQuery(divId).empty(); 
			if(option.delimiter == undefined){
				if(option.index == undefined){
					jQuery.each(option.data, function(index, value){	
						if(value.length>0){
							jQuery(divId).append("<option value='" + value + "'>" + value + "</option>");
						}
					});				
				} else {
					jQuery.each(option.data, function(index, value){	
						if(value.length>0){
							jQuery(divId).append("<option value='" + option.index[index] + "'>" + value + "</option>");
						}
					});
				}
			} else {
				options = option.data.split(option.optionDelimiter);
				jQuery.each(options, function(index, value){
					values = value.split(option.delimiter);
					optionValue = values[0];
					optionLabel = values[1];
					if(optionLabel != undefined){
						if(optionLabel.length>0){
							jQuery(divId).append("<option value='" + optionValue + "'>" + optionLabel + "</option>");
						}
					}					
				});
			}
		},
		
		/** Buy A New Slip */		
		buySlip: function(){
			jQuery.ajax({
				type : "GET",
				url : openmrsContextPath + "/module/registration/ajax/buySlip.htm",
				data : ({
					patientId: MODEL.patientId
				}),				
				success : function(data) {										
					window.location.href = window.location.href;
				},
				error : function(xhr, ajaxOptions, thrownError) {
					alert(thrownError);
				}
			});
		},
		
		/** Validate Form */
		validate: function(){
			if(StringUtils.isBlank(jQuery("#opdWard").val())){
				alert("Please select Triage");
				return false;
			};
			
			//ghanshyam  20-may-2013 #1648 capture Health ID and Registration Fee Type
			if (jQuery("#paidReg").attr('checked') == false
					&& jQuery("#freeReg").attr('checked') == false) {
				alert('Please select Registration Type!');
				return false;
			} else {
				if (jQuery("#freeReg").attr('checked')) {
					if (jQuery("#freeRegReason").val().length <= 0) {
						alert('Please enter Free reason');
						return false;
					} 
				}
		   }
		
			return true;
		}
	};
	
	//ghanshyam  20-may-2013 #1648 capture Health ID and Registration Fee Type
	VALIDATORS = {
	
		categoryCheck : function() {
			
			if (jQuery("#patientCategory").val() == "General") {
				
				jQuery("#exemptionField2").val("");
				jQuery("#waiverField").val("");
				jQuery("#exemptionField1").val("");
				jQuery("#exemptionField3").val("");
				jQuery("#exemptionField4").val("");
				jQuery("#nhif").val("");
				
				jQuery("#exe_wav_number").hide();
				jQuery("#nhif_number").hide();
				jQuery("#exemptionField2").hide();
				jQuery("#waiverField").hide();
				jQuery("#exemptionField1").hide();
				jQuery("#exemptionField3").hide();
				jQuery("#exemptionField4").hide();
				jQuery("#nhif").hide();
		
			} else if(jQuery("#patientCategory").val() == "Child Less Than 5 yr"){
				jQuery("#exe_wav_number").show();
				jQuery("#exemptionField1").show();
				jQuery("#exemptionField2").val("");
				jQuery("#waiverField").val("");
				jQuery("#exemptionField3").val("");
				jQuery("#exemptionField4").val("");
				jQuery("#nhif").val("");
				jQuery("#nhif_number").hide();
				jQuery("#exemptionField2").hide();
				jQuery("#waiverField").hide();
				jQuery("#exemptionField3").hide();
				jQuery("#exemptionField4").hide();
				jQuery("#nhif").hide();
		
			
			}else if(jQuery("#patientCategory").val() == "CCC"){
				
				jQuery("#exe_wav_number").show();
				jQuery("#exemptionField1").val("");
				jQuery("#exemptionField1").hide();
				jQuery("#exemptionField2").show();
				jQuery("#waiverField").val("");
				jQuery("#exemptionField3").val("");
				jQuery("#exemptionField4").val("");
				jQuery("#nhif").val("");
				jQuery("#nhif_number").hide();
				jQuery("#waiverField").hide();
				jQuery("#exemptionField3").hide();
				jQuery("#exemptionField4").hide();
				jQuery("#nhif").hide();
		
			
			}else if(jQuery("#patientCategory").val() == "Expectant Mother"){
				jQuery("#exe_wav_number").show();
				jQuery("#exemptionField3").show();
				jQuery("#exemptionField2").val("");
				jQuery("#waiverField").val("");
				jQuery("#exemptionField1").val("");
				jQuery("#exemptionField4").val("");
				jQuery("#nhif").val("");
				jQuery("#nhif_number").hide();
				jQuery("#exemptionField2").hide();
				jQuery("#waiverField").hide();
				jQuery("#exemptionField1").hide();
				jQuery("#exemptionField4").hide();
				jQuery("#nhif").hide();
		
			
			}else if(jQuery("#patientCategory").val() == "Waver"){
				jQuery("#exe_wav_number").show();
				jQuery("#waiverField").show();
				jQuery("#exemptionField2").val("");
				jQuery("#exemptionField1").val("");
				jQuery("#exemptionField3").val("");
				jQuery("#exemptionField4").val("");
				jQuery("#nhif").val("");
				jQuery("#nhif_number").hide();
				jQuery("#exemptionField2").hide();
				jQuery("#exemptionField1").hide();
				jQuery("#exemptionField3").hide();
				jQuery("#exemptionField4").hide();
				jQuery("#nhif").hide();
		
			
			}else if(jQuery("#patientCategory").val() == "NHIF"){
				jQuery("#exe_wav_number").show();
				jQuery("#exemptionField4").show();
				jQuery("#exemptionField2").val("");
				jQuery("#waiverField").val("");
				jQuery("#exemptionField3").val("");
				jQuery("#exemptionField1").val("");
				jQuery("#nhif_number").show();
				jQuery("#nhif").show();
				jQuery("#exemptionField2").hide();
				jQuery("#waiverField").hide();
				jQuery("#exemptionField3").hide();
				jQuery("#exemptionField1").hide();
			}
		},
		
		freeRegCheck : function() {
			if (jQuery("#freeReg").is(':checked')) {
				jQuery("#freeRegField").show();
				if (jQuery("#paidReg").is(":checked"))
					jQuery("#paidReg").removeAttr("checked");
			} else {
				jQuery("#freeRegReason").val("");
				jQuery("#freeRegField").hide();
			}
		},
		
		paidRegCheck : function(obj) {
			if (jQuery("#paidReg").is(':checked')) {
				if (jQuery("#freeReg").is(":checked")) {
					jQuery("#freeReg").removeAttr("checked");
					jQuery("#freeRegReason").val("");
					jQuery("#freeRegField").hide();
				}
			}
		},
		
	
	};
</script>
<script type="text/javascript">
function paidClick(){
if (jQuery("#paidReg").attr('checked') == true){
document.getElementById("message").innerHTML="Please collect "+${regFee}+" TK";
jQuery("#message").show();
 }
else{
jQuery("#message").hide();
  }
}

function freeClick(){
jQuery("#message").hide();
}
</script>
<!-- ghanshyam  20-may-2013 #1648 capture Health ID and Registration Fee Type -->
<!--  
<tr>
	<FONT SIZE="4" FACE="courier" COLOR=blue><MARQUEE WIDTH=1150
			BEHAVIOR=ALTERNATE BGColor=yellow>
			Please collect <font color="#FF0000">${regFee} TK </font>for Paid
			Registration
		</MARQUEE> </FONT>
</tr>
<br />
-->
<input id="printSlip" type="button" value="Print"
	onClick="PAGE.submit(false);" />
<input id="reprint" type="button" value="Reprint"
	onClick="PAGE.submit(true);" />
<input id="buySlip" type="button" value="Buy a new slip"
	onClick="PAGE.buySlip();" />
<input id="save" type="button" value="Save" onClick="PAGE.save();" />
<span id="validationDate"></span>
<div id="patientInfoPrintArea">
	<center>
		<form id="patientInfoForm" method="POST">
			<table border=0 width="1000">
				<tr>

				</tr>
				<tr>
					<td colspan="1""><b>ID.No:</b></td>
					<td colspan="5""><span id="identifier"></span></td>
				</tr>
				<tr>
					<td colspan="1"><b>Name:</b></td>
					<td><span id="othername1"></span></td>
				</tr>
				<tr>
					<td colspan="1"><b>Age:</b></td>
					<td colspan="5"><span id="age"></span></td>
				</tr>
				<tr>
					<td colspan="1"><b>Gender:</b></td>
					<td colspan="5"><span id="gender"></span></td>
				</tr>
				<tr>
					<td colspan="1"><b>Marital Status:</b></td>
					<td colspan="1"><span id="maritalStatus"></span></td>
					<td id="exe_wav_number"> Exemption/Waiver Number</td>
					<td id="nhif_number"> NHIF Card Id</td>
				</tr>
				<tr>
					<td colspan="1"><b>Patient Category:</b></td>
					<td><select id="patientCategory" name="person.attribute.14">
										<option value="Patient Category"></option>
										<option value="General">General</option>
										<option value="Child Less Than 5 yr">Child less than 5 year old</option>
										<option value="CCC">Comprehensive Care Clinic Patient</option>
										<option value="Expectant Mother">Expectant Mothers</option>
										<option value="Waver">Waiver</option>
										<option value="NHIF">NHIF Card Holder</option>
					</select></td>	
					
					<td id="exemptionField1">
							<span><input id="exemptionNumber1" name="person.attribute.31" />
							</span>
							
					</td>		
					<td id="waiverField">
							<span><input id="waiverNumber" name="person.attribute.32" />
							</span>
					</td>		
					<td id="exemptionField2">
							<span><input id="exemptionNumber2" name="person.attribute.34" />
							</span>
					</td>		
					<td id="exemptionField3">
							<span><input id="exemptionNumber3" name="person.attribute.35" />
							</span>
					</td>		
					
					<td id="exemptionField4">
							<span><input id="exemptionNumber4" name="person.attribute.36" />
							</span>
					</td>		
					
					<td id="nhif">
							<span><input id="nhif" name="person.attribute.33" />
							</span>
							
					</td>		
			
					

				</tr>
				<tr>
					<td colspan="1" valign="top"><b>Phone number:</b></td>
					<td colspan="5"><span id="phoneNumber"></span></td>
				</tr>
				
				<tr id="opdWardLabel">
					<td colspan="1"><b>Triage to visit:</b></td>
					<td colspan="5"><select id="opdWard" name="patient.opdWard">
					</select></td>
				</tr>
				<tr>
					<td colspan="1"><b>Date/Time:</b></td>
					<td colspan="5"><span id="datetime"></span></td>
				</tr>
				<%-- ghanshyam 27-02-2013 Feedback #966[Billing]Add Paid Bill/Add Free Bill for Bangladesh module(remove category from registration,OPD,IPD,Inventory)--%>
				<%--
				<tr>
					<td colspan="1"><b>Category:</b></td>
					<td colspan="2"><span id="category" /></td>
					<td><span id="FREE" /></td>
				</tr>
				--%>
				<tr>
					<td colspan="1"><b>National ID:</b></td>
					<td colspan="2"><span id="nationalId"></span></td>
				</tr>
				<%-- ghanshyam  20-may-2013 #1648 capture Health ID and Registration Fee Type 
				
				<tr id="regFeeType">
					<td><b> <font color="red"> Registration Fee Type:</font> </b>
					</td>
					<td><input id="paidReg" type="checkbox"
						name="patient.registration.fee.attribute.${regFeeConId}" value="${regFee}" onClick="paidClick();" />
						Paid</td>
					<td><input id="freeReg" type="checkbox"
						name="patient.registration.fee.attribute.${regFeeConId}" value="0" onClick="freeClick();" /> Free</td>
					<td><span id="freeRegField">Reason <input
							id="freeRegReason"
							name="patient.registration.fee.free.reason.attribute.${regFeeReasonConId}" /> </span></td>
					<td><span style="color:red;" id="message" > </span></td>
				</tr> --%>
				
				<tr id="temporaryCategories">
					<td colspan="1" valign="top"><b> <font color="red">Temporary
								Categories: </font> </b></td>
					<td colspan="5"><input type="checkbox"
						name="temporary.attribute.11" value="Rape Case" /> Rape Case <br /> <input
						type="checkbox" name="temporary.attribute.11" value="Road Traffic Accident" /> Road Traffic Accident <br />
					</td>
				</tr>
				<!-- ghanshyam  20-may-2013 #1648 capture Health ID and Registration Fee Type 
				<tr id="regFee">
					<td colspan="1" valign="top"><b>Registration Fee:</b></td>
					<td colspan="5">
						<div id="printableRegFee">TK</div>
					</td>
				</tr> -->
				<!-- Sagar Bele, 11-01-2013: Issue #663 Registration alignment -->
				<tr id="tempCat">
					<td colspan="1" valign="top"><b>Temporary Categories:</b></td>
					<td colspan="5">
						<div id="printableTemporaryCategories"></div>
					</td>
				</tr>
			</table>
		</form>
	</center>
</div>