Random ideas and structure
==========================

* API 
  * REST
  * Endpoints
    * /config/<user>
      * POST/GET - Put/Get config json blob for user
    * /link/<idA>/<idB>
      * POST
	* Create link from <idA> to <idB>
	* Store json block from Body as link object
    * /object/<id>
      * POST
	* Replace object
      * GET
	* Get object
	* Remove tags based on users READ permissions
	  * Add list of removed tags
      * DELETE 
	* Delete object including links
    * /query 
      * POST
      * Post a complex query
    * /search
      * q=? passed on to opensearch
* Perl middleware
  * Opensearch integration
    * Feed changed objects to opensearch
    * Delete objects in opensearch
    * On startup feed ALL objects to opensearch
    * Pass on the /search API endpoint to opensearch
  * Manages permissions to objects/tags
    * Zensor read operations (Remove tags not allowed to read)
    * Merge write operations (User will not write tags now allowed to read)
    * Disallow modifying objects
    * Disallow reading objects
      * Unclear how to handle in frontend if links attach to protected objects
  * Config/Blob store for client
    * Client may use config store for storing "last seen objects"
  * Handles complex queries see /query
    * May need multiple database operations
  * MQTT event notification
    * No changes feed via HTTP
    * Simple changes messages
      * For webclients to invalidate their objects
      * "Somebody changed this object"
    * Changes old/new object, who, when
      * Priviledged feed because all attributes
  * Auditing tables
    * old/new object, who, when


Things to evaluate, describe and integrate
==========================================
* File Blob Store
  * Protocols for Fiber Measurements etc
  * Every object may have file attachments
  * Integration into search?
    * May need something like tika-server?
  * Need their own "object" linked to original object
* Graphviz alike visualisation
* Attribute validation/syntax check helper
  * Either in javascript or perl middleware
