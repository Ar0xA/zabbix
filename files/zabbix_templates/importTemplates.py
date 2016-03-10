#!/usr/bin/python
import sys
sys.path.append('./lib')
import xmltodict
from zabbix_api import ZabbixAPI, ZabbixAPIException
from lxml import etree #Used to convert xmlfile to singleline string

APIfrontend = 'http://localhost/zabbix'
APIuser     = 'Admin'
APIpassword = 'zabbix'

def getTemplateNameFromXml(xmlfile):
	with open(xmlfile) as fd:
		template = xmltodict.parse(fd.read())
	try:
		templateName = template['zabbix_export']['templates']['template']['name']
	except:
		sys.stderr.write("Template name not found. Is this a zabbix template XML?\n")
		sys.exit(1)
	return templateName

def convertXmlToSingleLineString(xmlfile):
	parser = etree.XMLParser(remove_blank_text=True)
	tree = etree.parse(xmlfile, parser)
	return etree.tostring(tree)

def getTemplates():
	params = {'output': ['name'], 'sortfield': 'name'}
	return zapi.template.get(params)

def importTemplate(xmlfile, createMissingGroups = 'true', updateExistingHosts = 'false', createMissingHosts = 'false', updateExistingTemplates = 'true', createMissingTemplates = 'true', updateExistingTemplateScreens = 'true', createMissingTemplateScreens = 'true', deleteMissingTemplateScreens = 'false', createMissingTemplateLinkage = 'true', updateExistingApplications = 'true', createMissingApplications = 'true', deleteMissingApplications = 'false', updateExistingItems = 'true', createMissingItems = 'true', deleteMissingItems = 'false', updateExistingDiscoveryRules = 'true', createMissingDiscoveryRules = 'true', deleteMissingDiscoveryRules = 'false', updateExistingTriggers = 'true', createMissingTriggers = 'true', deleteMissingTriggers = 'false', updateExistingGraphs = 'true', createMissingGraphs = 'true', deleteMissingGraphs = 'false', updateExistingScreens = 'false', createMissingScreens = 'false', updateExistingMaps = 'false', createMissingMaps = 'false', updateExistingImages = 'false', createMissingImages = 'false'):
	#This function assumes the same defaults as the web frontend
	#It may look inefficient, but it is done this way for readability
	params = {}
	params['format'] = 'xml'
	sub_params = {}
	sub_params['groups'] = {}
	sub_params['groups']['createMissing'] = createMissingGroups
	sub_params['hosts'] = {}
	sub_params['hosts']['updateExisting'] = updateExistingHosts
	sub_params['hosts']['createMissing'] = createMissingHosts
	sub_params['templates'] = {}
	sub_params['templates']['updateExisting'] = updateExistingTemplates
	sub_params['templates']['createMissing'] = createMissingTemplates
	sub_params['templateScreens'] = {}
	sub_params['templateScreens']['updateExisting'] = updateExistingTemplateScreens
	sub_params['templateScreens']['createMissing'] = createMissingTemplateScreens
#	sub_params['templateScreens']['deleteMissing'] = deleteMissingTemplateScreens #Commented out. Probably a bug in Zabbix API
	sub_params['templateLinkage'] = {}
	sub_params['templateLinkage']['createMissing'] = createMissingTemplateLinkage
	sub_params['applications'] = {}
	sub_params['applications']['updateExisting'] = updateExistingApplications
	sub_params['applications']['createMissing'] = createMissingApplications
	sub_params['applications']['deleteMissing'] = deleteMissingApplications
	sub_params['items'] = {}
	sub_params['items']['updateExisting'] = updateExistingItems
	sub_params['items']['createMissing'] = createMissingItems
	sub_params['items']['deleteMissing'] = deleteMissingItems
	sub_params['discoveryRules'] = {}
	sub_params['discoveryRules']['updateExisting'] = updateExistingDiscoveryRules
	sub_params['discoveryRules']['createMissing'] = createMissingDiscoveryRules
	sub_params['discoveryRules']['deleteMissing'] = deleteMissingDiscoveryRules
	sub_params['triggers'] = {}
	sub_params['triggers']['updateExisting'] = updateExistingTriggers
	sub_params['triggers']['createMissing'] = createMissingTriggers
	sub_params['triggers']['deleteMissing'] = deleteMissingTriggers
	sub_params['graphs'] = {}
	sub_params['graphs']['updateExisting'] = updateExistingGraphs
	sub_params['graphs']['createMissing'] = createMissingGraphs
	sub_params['graphs']['deleteMissing'] = deleteMissingGraphs
	sub_params['screens'] = {}
	sub_params['screens']['updateExisting'] = updateExistingScreens
	sub_params['screens']['createMissing'] = createMissingScreens
	sub_params['maps'] = {}
	sub_params['maps']['updateExisting'] = updateExistingMaps
	sub_params['maps']['createMissing'] = createMissingMaps
	sub_params['images'] = {}
	sub_params['images']['updateExisting'] = updateExistingImages
	sub_params['images']['createMissing'] = createMissingImages
	params['rules'] = sub_params
	params['source'] = convertXmlToSingleLineString(xmlfile)
	return zapi.configuration.import_(params)

def deleteTemplate(templateid):
	zapi.template.delete([templateid])

if __name__ == "__main__":

	zapi = ZabbixAPI(server=APIfrontend,log_level=0)
	try:
		zapi.login(APIuser, APIpassword)
	except ZabbixAPIException, e:
		sys.stderr.write(str(e) + '\n')
		sys.exit(1)

	import glob
	xmlfiles = glob.glob("./*.xml")

	for xmlfile in xmlfiles:
		result = importTemplate(xmlfile, updateExistingHosts = 'true', deleteMissingTemplateScreens = 'true', deleteMissingApplications = 'true', deleteMissingItems = 'true', deleteMissingDiscoveryRules = 'true', deleteMissingTriggers = 'true', deleteMissingGraphs = 'true')
		if not result:
			sys.stderr.write("Something went wrong with: '%s'\n" % xmlfile)
