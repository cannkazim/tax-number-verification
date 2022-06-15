<cfcomponent>
   
    <cffunction name="new_token" access="remote" returntype="string" returnFormat="json">
        <cfset dataString = 'assoscmd=cfsession&rtype=json&fskey=intvrg.fix.session&fuserid=INTVRG_FIX&gn=vkndogrulamalar&'>
        
        <cftry>
            <cfhttp url="https://ivd.gib.gov.tr/tvd_server/assos-login" method="POST"  result="apiResponse">
                <cfhttpparam type="header" name="Content-Type" value="application/x-www-form-urlencoded"/>
                <cfhttpparam type="header" name="content-length" value="#len(trim(dataString))#">
                <cfhttpparam type="body"  value="#trim(dataString)#">
            </cfhttp>
            <cfset result.status = true>
            <cfset result.resultApi = deSerializeJSON(apiResponse.filecontent).token>

        <cfcatch type="any">
            <cfset result.status = false>
            <cfset result.error = cfcatch >
        </cfcatch>
        </cftry>

        <cfreturn Replace(SerializeJSON(result),'//','')>
    </cffunction>

    <cffunction name="vkn_verification" access="remote" returntype="string" returnFormat="json">
        <cfargument  name="vkn" type="string" default="">
        <cfargument  name="vergi_dairesi" type="string" >
        <cfargument  name="il" type="string" >
        <cfargument  name="tckn" type="string" default="">
        <cfset token = new_token()>

        <cfset jp= serializeJSON(["dogrulama":[
            "vkn1":"#vkn#",
            "tckn1":"#tckn#",
            "iller":'#il#',
            "vergidaireleri":'#vergi_dairesi#'
        ]])>
        
        <cfset dataString='cmd=vergiNoIslemleri_vergiNumarasiSorgulama&callid=ff81dd010b12d-8&pageName=R_INTVRG_INTVD_VERGINO_DOGRULAMA&token=#deSerializeJSON(token).RESULTAPI#&jp=#jp#'>
        <cftry>
            <cfhttp url="https://ivd.gib.gov.tr/tvd_server/dispatch" method="POST"  result="apiResponse">
                <cfhttpparam type="header" name="Content-Type" value="application/x-www-form-urlencoded"/>
                <cfhttpparam type="header" name="content-length" value="#len(trim(dataString))#">
                <cfhttpparam type="body"  value="#trim(dataString)#">
            </cfhttp>
            <cfset response=deserializeJSON(apiResponse.filecontent)>
            <cfif structKeyExists(response.data, "unvan")>
                <cfset result.resultApi = response>
                <cfset result.status = true>
            <cfelse>
                <cfset result.status = false>
                <cfset result.error = "Eksik Veri" >
            </cfif>
            
            
        <cfcatch type="any">
            <cfset result.status = false>
            <cfset result.error = cfcatch >
        </cfcatch>
        </cftry>
        <cfreturn Replace(SerializeJSON(result),'//','')>
    </cffunction>
        
</cfcomponent>