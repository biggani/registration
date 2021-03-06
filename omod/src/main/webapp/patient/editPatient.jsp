 <%--
 *  Copyright 2009 Society for Health Information Systems Programmes, India (HISP India)
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
--%> 
<%@ include file="/WEB-INF/template/include.jsp" %>
<%@ include file="/WEB-INF/template/header.jsp" %>
<%@ include file="../includes/js_css.jsp" %>
<openmrs:require privilege="Edit Patients" otherwise="/login.htm" redirect="/module/registration/editPatient.form" />
<openmrs:globalProperty key="hospitalcore.hospitalName" defaultValue="ddu" var="hospitalName"/>
<br/>

<script type="text/javascript">

	// Districts
	var _districts = new Array();
	<c:forEach var="district" items="${districts}" varStatus="status">
		_districts[${status.index}] = "${district}";
	</c:forEach>
	
	// Tehsils
	var _tehsils = new Array();
	<c:forEach var="tehsil" items="${tehsils}" varStatus="status">
		_tehsils[${status.index}] = "${tehsil}";
	</c:forEach>	
	
	// Patient Attribute
	var _attributes = new Array();
	<c:forEach var="entry" items="${patient.attributes}">
		_attributes[${entry.key}] = "${entry.value}";
	</c:forEach>
	
	/**
	 ** MODEL FROM CONTROLLER
	 **/
	MODEL = {
		patientId: "${patient.patientId}",
		patientIdentifier: "${patient.identifier}",
		patientName: "${patient.fullname}",
		patientAge: "${patient.age}",
		patientGender: "${patient.gender}",
		patientAddress: "${patient.address}",
		patientBirthdate: "${patient.birthdate}",
		patientAttributes: _attributes,
		districts: _districts,
		tehsils: _tehsils
	};
</script>

<jsp:include page="../includes/${hospitalName}/editPatientForm.jsp"/>

<%@ include file="/WEB-INF/template/footer.jsp" %>  