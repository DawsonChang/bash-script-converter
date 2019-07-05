# bash-script-converter

> test

# Usage
`./converter.sh [ -f currency ] [ -t currency ] [ -d date ] [ number ]`

## Default
#### The default will change the `EUR` to `USD`
`./converter.sh 100`

## Argument
#### Set the number how much you want to converting(It can not be empty)
`./converter.sh [number]`

#### Set the base currency
`./converter.sh [-f currency]`

#### Set the target currency
`./converter.sh [-t currency]`

#### Get the rate from specific date of both currency
`./converter.sh [-d date]`

## Example
`./converter.sh -f USD -t HKD -d 2019-03-05 500`
##### It means that we want to change USD to HKD, on the date of 2019-03-05, and the number of base currency

## Others
##### Due to the limitation of API, you only can change following currencies:
  `AUD`, `BGN`, `BRL`, `CAD`, `CHF`, `CNY`, `CZK`, `DKK`, `GBP`, `HKD`, `HRK`, `HUF`, `IDR`, `ILS`, `INR`, `ISK`, `JPY`, `KRW`, `MXN`, `MYR`, `NOK`, `NZD`, `PHP`, `PLN`, `RON`, `RUB`, `SEK`, `SGD`, `THB`, `TRY`, `USD`, `ZAR`
