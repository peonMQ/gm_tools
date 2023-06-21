# GM tools for Emu

LUA script that simplifies certain GM commands for Emu

## Requirements

- MQ
- MQ2Lua

## Installation
Download the latest `gm.zip` from the latest [release](https://github.com/peonMQ/gm_tools/releases) and unzip the contents to its own directory inside `lua` folder of your MQ directory. 

ie `lua\gm`

## Usage

Start the application by running the following command in-game (using the foldername inside the lua folder as the scriptname to start).
```bash
/lua run gm
```

### Logging
User/character configs are located at `{MQConfigDir}\{ServerName}\{CharacterName}.json`
Each list is one group, which gets sorted in HUD and spaced out.
Default log level: `warn`
```json
{
  "grouplayout": [
    ["Eredhrin", "Hamfast", "Newt", "Bill", "Marillion", "Ithildin"]
    ,["Renaissance", "Magica", "Tedd", "Araushnee", "Freyja", "Milamber"]
    ,["Soundgarden", "Lolth", "Ronin", "Tyrion", "Sheperd", "Valsharess"]
    ,["Genesis", "Vierna", "Osiris", "Eilistraee", "Regis", "Aredhel"]
    ,["Mizzfit", "Komodo", "Izzy", "Lulz", "Tiamat", "Nozdormu"]
  ]
}
```
