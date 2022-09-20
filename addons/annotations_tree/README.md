A godot plugin showing comment annotations in your project

The plugin settings can be changed in the `plugin.cfg` file.

```
[parameters]

dock_name="Annotations"
annotations_list=["TODO", "FIXME", "BUG"]
folders_excluded=["res://addons"]
refresh_time=10.0
```


`dock_name` defines the name of the dock container.

`annotations_list` defines the list of annotations that will be processed by the plugin.

`folders_excluded` defines a list of folders that should be ignored when searching for annotations.

`refresh_time` defines the time between two refreshes of the annotation tree, in seconds.

![Screenshot of the annotation tree](addons/annotations_tree/img/dock.png)
![Screenshot of the filtering](addons/annotations_tree/img/filter.png)
