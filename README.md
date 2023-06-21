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

Valid log levels: `trace | debug | info | warn | error | fatal | help`
Default log level: `warn`
```json
{
	"logging": {
		"loglevel": "debug" 
	}
}
```
