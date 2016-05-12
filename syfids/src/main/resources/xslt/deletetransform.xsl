<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xs="http://www.w3.org/2001/XMLSchema">
	<xsl:output method="xml" indent="yes"/>
	<xsl:variable name="arrivalOrDeparture">
		<xsl:choose>
			<xsl:when test="Flight/ArrivalStationCode = 'MSP'">
				<xsl:text>Arrival</xsl:text>
			</xsl:when>
			<xsl:otherwise>
				<xsl:text>Departure</xsl:text>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	
	<xsl:variable name="operationQualifier">
		<xsl:choose>
			<xsl:when test="Flight/ArrivalStationCode = 'MSP'">
				<xsl:text>ONB</xsl:text>
			</xsl:when>
			<xsl:otherwise>
				<xsl:text>OFB</xsl:text>
			</xsl:otherwise>			
		</xsl:choose>			
	</xsl:variable>
	
	<xsl:variable name="codeContext">
		<xsl:choose>
		  	<xsl:when test="Flight/LegStatus = 'Cancelled'">
		    	<xsl:text>2005</xsl:text>
		  	</xsl:when>
		  	<xsl:when test="Flight/LegStatus = 'Diverted'">
		    	<xsl:text>2005</xsl:text>
		  	</xsl:when>
		  	<xsl:otherwise>
		    	<xsl:text>9750</xsl:text>
		  	</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	
	<xsl:variable name="originDate">
		<xsl:choose>
			<xsl:when test="arrivalOrDeparture = 'Arrival'">
				<xsl:choose>
					<xsl:when test="Flight/LinkFlightDepartureOriginDate/text()">						
						<xsl:call-template name="str-to-date">
							<xsl:with-param name="strDate" select="Flight/LinkFlightDepartureOriginDate/text()"/>
							<xsl:with-param name="format" select="'[Y0001]-[M01]-[D01]'"/>
						</xsl:call-template>
					</xsl:when>
					<xsl:otherwise>
						<xsl:call-template name="str-to-date">
							<xsl:with-param name="strDate" select="Flight/ScheduledArrivalDateTime/text()"/>
							<xsl:with-param name="format" select="'[Y0001]-[M01]-[D01]'"/>
						</xsl:call-template>						
					</xsl:otherwise>
				</xsl:choose>	
			</xsl:when>
			<xsl:otherwise>
				<xsl:choose>
					<xsl:when test="Flight/LinkFlightArrivalOriginDate/text()">
						<xsl:call-template name="str-to-date">
							<xsl:with-param name="strDate" select="Flight/LinkFlightArrivalOriginDate/text()"/>
							<xsl:with-param name="format" select="'[Y0001]-[M01]-[D01]'"/>
						</xsl:call-template>
					</xsl:when>
					<xsl:otherwise>
						<xsl:call-template name="str-to-date">
							<xsl:with-param name="strDate" select="Flight/ScheduledDepartureDateTime/text()"/>
							<xsl:with-param name="format" select="'[Y0001]-[M01]-[D01]'"/>
						</xsl:call-template>						
					</xsl:otherwise>
				</xsl:choose>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	
	<xsl:variable name="tailNumber">
		<xsl:choose>
			<xsl:when test="Flight/LegStatus = 'Cancelled'">
				<xsl:text>0</xsl:text>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select='Flight/TailNumber'/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	
	<xsl:variable name="remarkCode">
		<xsl:choose>
		  <xsl:when test="Flight/LegStatus = 'Arrived'">
		  	<xsl:text>ONB</xsl:text>
		  </xsl:when>
		  <xsl:when test="Flight/LegStatus = 'Boarding'">
		    <xsl:text>BST</xsl:text>
		  </xsl:when>
		  <xsl:when test="Flight/LegStatus = 'Final Boarding'">
		    <xsl:text>BEN</xsl:text>
		  </xsl:when>
		  <xsl:when test="Flight/LegStatus = 'Gate Closed'">
		    <xsl:text>GCL</xsl:text>
		  </xsl:when>
		  <xsl:when test="Flight/LegStatus = 'FlightClosed'">
		    <xsl:text>FCL</xsl:text>
		  </xsl:when>
		  <xsl:when test="Flight/LegStatus = 'Departed'">
		    <xsl:text>OFB</xsl:text>
		  </xsl:when>
		  <xsl:when test="Flight/LegStatus = 'InRange'">
		    <xsl:text>THM</xsl:text>
		  </xsl:when>
		  <xsl:when test="Flight/LegStatus = 'Approach'">
		    <xsl:text>TEN</xsl:text>
		  </xsl:when>
		  <xsl:when test="Flight/LegStatus = 'Landed'">
		    <xsl:text>LAN</xsl:text>
		  </xsl:when>
		  <xsl:when test="Flight/LegStatus = 'Early'">
		    <xsl:text>EAR</xsl:text>
		  </xsl:when>
		  <xsl:when test="Flight/LegStatus = 'OnTime'">
		    <xsl:text>SCT</xsl:text>
		  </xsl:when>
		  <xsl:when test="Flight/LegStatus = 'Delayed'">
		    <xsl:text>DEL</xsl:text>
		  </xsl:when>
		  <xsl:when test="Flight/LegStatus = 'InFlight'">
		    <xsl:text>SCT</xsl:text>
		  </xsl:when>
		  <xsl:when test="Flight/LegStatus = 'Cancelled'">
		    <xsl:text>DX</xsl:text>
		  </xsl:when>
		  <xsl:when test="Flight/LegStatus = 'Diverted'">
		    <xsl:text>DV</xsl:text>
		  </xsl:when>
		  <xsl:when test="Flight/LegStatus = 'AwaitingTakeOff'">
		    <xsl:text>SCT</xsl:text>
		  </xsl:when>
		</xsl:choose>
	</xsl:variable>	
	
	<xsl:template name="str-to-date">
		<xsl:param name="strDate" />
		<xsl:param name="format" />
		
		<xsl:if test="$format">
			<xsl:variable name="convDate" as="xs:dateTime" select="xs:dateTime($strDate)" />
			<xsl:value-of select="format-dateTime($convDate, $format)" />
		</xsl:if>
	</xsl:template>
	
	<xsl:template match="/">
		<IATA_AIDX_FlightLegNotifRQ AltLangID="en-US" RetransmissionIndicator="true" Version="10.0" EchoToken="a" CodeContext="3" xmlns="http://www.iata.org/IATA/2007/00">
			<xsl:attribute name="CorrelationID">
				<xsl:value-of select="Flight/@CorrelationID" />
			</xsl:attribute>
			<xsl:attribute name="TimeStamp">
				<xsl:value-of select="current-dateTime()" />
			</xsl:attribute>
			<Originator CodeContext="3" Code="a" CompanyShortName="MULE" />
			<FlightLeg>
				<LegIdentifier>
					<Airline CodeContext="3">
						<xsl:value-of select='Flight/Airline'/>
					</Airline>
					<FlightNumber>
						<xsl:value-of select='Flight/FlightNumber'/>
					</FlightNumber>
					<DepartureAirport CodeContext="3">
						<xsl:value-of select='Flight/DepartureStationCode'/>
					</DepartureAirport>
					<ArrivalAirport CodeContext="3">
						<xsl:value-of select='Flight/ArrivalStationCode'/>
					</ArrivalAirport>
					<OriginDate>
						<xsl:value-of select="$originDate"/>
					</OriginDate>					
				</LegIdentifier>
				<SpecialAction>Delete</SpecialAction>
				<LegData>					
					<xsl:choose>
						<xsl:when test="$arrivalOrDeparture = 'Arrival'">
							<xsl:if test="Flight/EstimatedArrivalDateTime/text()">
								<OperationTime TimeType="EST" RepeatIndex="1" CodeContext="2005">
									<xsl:attribute name="OperationQualifier" select='$operationQualifier'/>
									<xsl:value-of select="Flight/EstimatedArrivalDateTime/text()"/>
								</OperationTime>
							</xsl:if>
							<xsl:if test="Flight/ScheduledArrivalDateTime/text()">
								<OperationTime TimeType="SCT" RepeatIndex="1" CodeContext="2005">
									<xsl:attribute name="OperationQualifier" select='$operationQualifier'/>
									<xsl:value-of select="Flight/ScheduledArrivalDateTime/text()"/>
								</OperationTime>
							</xsl:if>				
							<xsl:if test="Flight/ActualArrivalDateTime/text()">
								<OperationTime TimeType="ACT" RepeatIndex="1" CodeContext="2005">
									<xsl:attribute name="OperationQualifier" select='$operationQualifier'/>
									<xsl:value-of select="Flight/ActualArrivalDateTime/text()"/>
								</OperationTime>
							</xsl:if>
						</xsl:when>
						<xsl:otherwise>
							<xsl:if test="Flight/EstimatedDepartureDateTime/text()">
								<OperationTime TimeType="EST" RepeatIndex="1" CodeContext="2005">
									<xsl:attribute name="OperationQualifier" select='$operationQualifier'/>
									<xsl:value-of select="Flight/EstimatedDepartureDateTime/text()"/>
								</OperationTime>
							</xsl:if>
							<xsl:if test="Flight/ScheduledDepartureDateTime/text()">
								<OperationTime TimeType="SCT" RepeatIndex="1" CodeContext="2005">
									<xsl:attribute name="OperationQualifier" select='$operationQualifier'/>
									<xsl:value-of select="Flight/ScheduledDepartureDateTime/text()"/>
								</OperationTime>
							</xsl:if>				
							<xsl:if test="Flight/ActualDepartureDateTime/text()">
								<OperationTime TimeType="ACT" RepeatIndex="1" CodeContext="2005">
									<xsl:attribute name="OperationQualifier" select='$operationQualifier'/>
									<xsl:value-of select="Flight/ActualDepartureDateTime/text()"/>
								</OperationTime>
							</xsl:if>
						</xsl:otherwise>
					</xsl:choose>
				</LegData>
			</FlightLeg>			
		</IATA_AIDX_FlightLegNotifRQ>
	</xsl:template>
</xsl:stylesheet>