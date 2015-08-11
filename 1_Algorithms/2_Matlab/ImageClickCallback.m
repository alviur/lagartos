function coordinates=ImageClickCallback ( objectHandle , eventData )
axesHandle  = get(objectHandle,'Parent');
coordinates = get(axesHandle,'CurrentPoint'); 
coordinates = coordinates(1,1:2);
end