% Tue  2 Feb 14:00:43 CET 2021
function export_config_xml(obj)
	w     = what(class(obj));
	iname = [w.path,'/delft3d.xml']
	if (isempty(obj.ddb))
		copyfile(iname,obj.folder);
	else
		oname = [obj.folder,'/delft3d.xml'];
		f    = xmlread(iname);
		% '/home/pia/phd/src/lib/interface/delft3d/@Delft3D/delft3d.xml');
		c    = f.item(0);
		c    = c.getChildNodes;
		d    = c.getElementsByTagName('flow2D3D').item(0);
		dd   = d.getElementsByTagName('mdfFile').item(0);
		dd.getParentNode.removeChild(dd);
		node = f.createElement('ddbFile');  
		node.setTextContent('d.ddb');
		d.appendChild(node);
		xmlwrite(oname,f);
	end % of if
end % export_config_xml

