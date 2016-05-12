<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xs="http://www.w3.org/2001/XMLSchema"
	xpath-default-namespace="http://www.iata.org/IATA/2007/00">
	
	<xsl:output method="xml" indent="yes"/>
	
	<xsl:template match="/IATA_AIDX_FlightLegNotifRQ">
		<IATA_AIDX_FlightLegNotifRQ AltLangID="en-US" RetransmissionIndicator="true" Version="10.0" EchoToken="a" CodeContext="3" Target="Production" xmlns="http://www.iata.org/IATA/2007/00">
			<xsl:attribute name="CorrelationID">
				<xsl:value-of select="@CorrelationID" />
			</xsl:attribute>
			<xsl:attribute name="TimeStamp">
				<xsl:value-of select="current-dateTime()" />
			</xsl:attribute>
			<Originator CodeContext="3" Code="a" CompanyShortName="MULE" />
			<FlightLeg>
				<LegIdentifier>
					<Airline CodeContext="3">
						<xsl:value-of select='FlightLeg/LegIdentifier/Airline'/>
					</Airline>
					<FlightNumber>
						<xsl:value-of select='FlightLeg/LegIdentifier/FlightNumber'/>
					</FlightNumber>
					<DepartureAirport CodeContext="3">
						<xsl:value-of select='FlightLeg/LegIdentifier/DepartureAirport'/>
					</DepartureAirport>
					<ArrivalAirport CodeContext="3">
						<xsl:value-of select='FlightLeg/LegIdentifier/ArrivalAirport'/>
					</ArrivalAirport>
					<OriginDate>
						<xsl:value-of select="FlightLeg/LegIdentifier/OriginDate"/>
					</OriginDate>
				</LegIdentifier>
				<LegData>				
					<xsl:attribute name="InternationalStatus">
						<xsl:value-of select='FlightLeg/LegData/@InternationalStatus' />
					</xsl:attribute>
					<ServiceType>
						<xsl:value-of select='FlightLeg/LegData/ServiceType' />
					</ServiceType>					
					<RemarkTextCode RepeatIndex="1" Qualifier="TER">
						<xsl:attribute name="CodeContext">
							<xsl:value-of select="FlightLeg/LegData/RemarkTextCode/@CodeContext" />
						</xsl:attribute>				
						<xsl:value-of select='FlightLeg/LegData/RemarkTextCode' />
					</RemarkTextCode>
					<AirportResources>
						<xsl:attribute name="Usage">
							<xsl:value-of select='FlightLeg/LegData/AirportResources/@Usage' />
						</xsl:attribute>
						<Resource>
							<xsl:attribute name="DepartureOrArrival">
								<xsl:value-of select='FlightLeg/LegData/AirportResources/Resource/@DepartureOrArrival' />
							</xsl:attribute>
							<AircraftTerminal>
								<xsl:value-of select='FlightLeg/LegData/AirportResources/Resource/AircraftTerminal' />
							</AircraftTerminal>			
						</Resource>
					</AirportResources>	
					<xsl:for-each select="FlightLeg/LegData/OperationTime">
						<OperationTime>
							<xsl:attribute name="TimeType">
								<xsl:value-of select="@TimeType" />
							</xsl:attribute>
							<xsl:attribute name="RepeatIndex">
								<xsl:value-of select="@RepeatIndex" />
							</xsl:attribute>
							<xsl:attribute name="CodeContext">
								<xsl:value-of select="@CodeContext" />
							</xsl:attribute>
							<xsl:attribute name="OperationQualifier">
								<xsl:value-of select="@OperationQualifier" />
							</xsl:attribute>
							<xsl:value-of select="." />
						</OperationTime>
					</xsl:for-each>										
					<AircraftInfo>
						<AircraftSubType>
							<xsl:value-of select='FlightLeg/LegData/AircraftInfo/AircraftSubType' />
						</AircraftSubType>
						<TailNumber>
							<xsl:value-of select='FlightLeg/LegData/AircraftInfo/TailNumber' />
						</TailNumber>
					</AircraftInfo>
				</LegData>
			</FlightLeg>			
		</IATA_AIDX_FlightLegNotifRQ>		
	</xsl:template>	
</xsl:stylesheet>