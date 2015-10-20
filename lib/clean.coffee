{CompositeDisposable} = require 'atom'
workspace = atom.workspace
workspaceElem = document.querySelector 'atom-workspace'
cleanActive = false

module.exports =

  config:
    fullScreen:
      description:"Go to fullScreen?"
      type:"boolean"
      default:true

    autoHideTabs:
      description:"Auto Hide tabs?"
      type:"boolean"
      default:true

    hoverTabs:
      description:"If you have auto-hide-tabs option off - then you can hide
      labels of tabs until you point them."
      type:"boolean"
      default:false

    hideGutter:
      description:"Hide line numbers"
      type:"boolean"
      default:true

    minimapOpacity:
      description:"If you have minimap plugin, you can set the initial
      opacity PERCENT % :)"
      type:"integer"
      default:10


  getMinimap: () ->
    available = atom.packages.getAvailablePackageNames()
    if available.indexOf 'minimap' != -1
      minimap = document.querySelector('atom-text-editor::shadow atom-text-editor-minimap')
      if !minimap?
        minimap = document.querySelector('atom-text-editor atom-text-editor-minimap')
        if !minimap?
          minimap = false
    else
      minimap = false
    minimap


  applyOpacity: (opacity) ->
    minimap = @getMinimap()
    percent = (opacity / 100).toFixed(2)
    console.log 'percent',percent
    if minimap then minimap.style.opacity = percent else false


  restoreOpacity: ->
    minimap = @getMinimap()
    if minimap? then minimap.style.opacity = 1


  applyConfig: (conf) ->
    if conf?
      if conf.fullScreen
        atom.setFullScreen cleanActive
      else
        atom.setFullScreen false
      if conf.autoHideTabs
        workspaceElem.classList.add 'clean2-show-tabs'
      else
        workspaceElem.classList.add 'clean2-show-tabs'
      if conf.hideGutter
        workspaceElem.classList.remove 'clean2-show-gutter'
      else
        workspaceElem.classList.add 'clean2-show-gutter'
      if conf.hoverTabs
        workspaceElem.classList.add 'clean2-hover-tabs'
      else
        workspaceElem.classList.remove 'clean2-hover-tabs'
      if cleanActive
        if @applyOpacity?
          @applyOpacity conf.minimapOpacity
      else
        @restoreOpacity()


  activate: (state) ->
    @subs = new CompositeDisposable
    @subs.add atom.commands.add 'atom-workspace',
      'clean2:toggle': => @toggle()
    atom.setFullScreen false
    atom.config.observe 'Clean2', (conf) => @applyConfig.apply @,[conf]


  toggle: ->
    if cleanActive then cleanActive = false else cleanActive = true
    conf = atom.config.get('Clean2')
    workspaceElem.classList.toggle 'clean2'
    @applyConfig(conf)
