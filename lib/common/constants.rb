require_relative '../../spec/spec_helper'


module Constants

  #-------------------------------
  # PAGE OBJECTS FILE PATH       |
  #-------------------------------

  AMAZON_PAGE_OBJECTS = 'page_objects_and_ui_html_locators/uilocators/amazon/amazon.yml'
  CONFIG_PROPERTIES = 'config/QAconfig.properties'

  #-------------------
  # HTML ATTRIBUTES  |
  #-------------------

  HTML_ATTRIB_VALUE = 'value'
  HTML_ATTRIB_ID = 'id'
  HTML_ATTRIB_DATA_URL = 'data-url'
  HTML_ATTRIB_SRC = 'src'
  HTML_ATTRIB_CLASS = 'class'
  HTML_ATTRIB_DATA_CONTENT = 'data-content'
  HTML_ATTRIB_DATA_MINI = 'data-mini'
  HTML_ATTRIB_DATA_ORIGINAL = 'data-original'
  HTML_ATTRIB_CHECKED = 'checked'
  HTML_ATTRIB_INNER_HTML = 'innerHTML'
  HTML_ATTRIB_HREF = 'href'
  HTML_ATTRIB_DATA_COLOR = 'data-color'
  HTML_ATTRIB_TITLE = 'title'
  HTML_ATTRIB_DATA_ID = 'data-id'
  HTML_ATTRIB_DISABLED = 'disabled'
  HTML_ATTRIB_DATA_POS = 'data-pos'

  #------------------
  # TIMEOUT VALUES  |
  #------------------
  FIVE_SECONDS_TIMEOUT_VALUE = 5
  SHORT_TIMEOUT_VALUE = 10
  MEDIUM_TIMEOUT_VALUE = 30
  LONG_TIMEOUT_VALUE = 60
  FORTY_FIVE_SECOND_TIMEOUT_VALUE = 45
  TOO_LONG_TIMEOUT_VALUE = 180

end
