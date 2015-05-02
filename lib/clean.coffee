workspace = atom.workspaceView
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
      default:0


  getMinimap: () ->
    if atom.packages.activePackages.minimap?
      minimap = atom.workspaceView.panes.
      find('atom-text-editor')[0]
      .shadowRoot.querySelector('atom-text-editor-minimap')
    else
      minimap = false
    minimap


  applyOpacity: (opacity) ->
    minimap = @getMinimap()
    percent = opacity / 100
    if minimap? then minimap.style.opacity = percent else false


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
        workspace.removeClass 'clean2-show-tabs'
      else
        workspace.addClass 'clean2-show-tabs'
      if conf.hideGutter
        workspace.removeClass 'clean2-show-gutter'
      else
        workspace.addClass 'clean2-show-gutter'
      if conf.hoverTabs
        workspace.addClass 'clean2-hover-tabs'
      else
        workspace.removeClass 'clean2-hover-tabs'
      if cleanActive
        if @applyOpacity?
          @applyOpacity conf.minimapOpacity
      else
        @restoreOpacity()


  activate: (state) ->
    atom.workspaceView.command "clean2:toggle", => @toggle()
    atom.setFullScreen false
    atom.config.observe 'Clean2', (conf) => @applyConfig.apply @,[conf]


  toggle: ->
    if cleanActive then cleanActive = false else cleanActive = true
    conf = atom.config.get('Clean2')
    workspace.toggleClass 'clean2'
    @applyConfig(conf)
