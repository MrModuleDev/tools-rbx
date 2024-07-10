# tools-rbx

## What is T.O.O.L.S.?
T.O.O.L.S. (Tools) stands for *"Typed Object-Oriented Lua System/Standard"*.

Tools is a ModuleScript that introduces Object Oriented Programming (**OOP**) paradigm to Roblox Studio.

## Why would I want to use Tools?

### OOP has many benefits when developing:
- Organization/Scalability
- Better Code Quality
- Better Productivity

### Tools includes built-in OOP Features:
- Classes
- Inheritance (Includes Typed inheritance)
- Design patterns (Singleton, Multiton, Abstract)
  
### Tools includes packages that include helpful Classes:
- Signal Connection Handlers (Helps mitigate memory leaks)
- Session Locked Data Stores with Auto Saving (SaveStores)
- Camera wrapper class for easier camera manipulation
- And much more!

## What makes Tools better than conventional Lua OOP?
Tools can be used as a standard for how Classes should function and be formatted in Roblox Studio

### With conventional OOP:
- You must set metatables and add metatable functionality (class definitions) to each class script
- Typed inheritance is usually not included
- Design patterns must be programmed in each class when needed

### With Tools:
- Class definition is included in Tools. If you need to change the class definition, you only need to change it in one place
- Typed inheritance is included
- Design patterns are included and can be specified through a single parameter

## How do I add Tools to my Roblox Studio Game?
There are two ways you can add Tools to your Roblox Studio
### Tools.RBXMX file (Recommended):
1. Find the Tools.RBXMX file within the GitHub Repository
2. In Roblox Studio right-click ReplicatedStorage, and choose "Insert from file..."
3. Select the downloaded RBXMX file to insert Tools into Roblox Studio

### Roblox Creator Store (Disclaimer: might not be updated to the newest version, compare versions first):
1. Find the Roblox Script on the Creator Store here: https://create.roblox.com/store/asset/18415201971/Tools-v100 
2. On the creator store page press the "Get Model" Button
3. On Roblox Studio, under the view tab, open the Toolbox panel
4. Within your models, locate the Tools Model and click it to add it to Roblox Studio
