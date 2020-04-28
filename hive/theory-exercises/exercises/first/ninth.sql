/*
How from that data I show only the names that the Date "END" is bigger than the next "Begin" Date.

e.g. Peter shouldnt be shown as his first row "END" date is 2019-12-31 and his
next "Begin" Date is 2020-01-01 so 2019<2020.
Now for John first row "End" date is 2021-12-31 wich is bigger than next Row "Begin" date 2020-03-01.

╔═════════╦════════════╦════════════╗
║  name   ║   Begin    ║    End     ║
╠═════════╬════════════╬════════════╣
║ Peter   ║ 2016-01-01 ║ 2019-12-31 ║
║ Peter   ║ 2020-01-01 ║ 2020-12-31 ║
║ John    ║ 2018-01-01 ║ 2021-12-31 ║
║ John    ║ 2020-03-01 ║ 2022-03-01 ║
║ Mary    ║ 2018-02-01 ║ 2022-01-31 ║
║ Mary    ║ 2020-01-01 ║ 2022-01-01 ║
║ Charles ║ 2019-07-01 ║ 2021-06-30 ║
║ Charles ║ 2020-03-01 ║ 2022-03-01 ║
╚═════════╩════════════╩════════════╝

So from this data how do I get only

╔═════════╦════════════╦════════════╗
║  name   ║   Begin    ║    End     ║
╠═════════╬════════════╬════════════╣
║ John    ║ 2018-01-01 ║ 2021-12-31 ║
║ John    ║ 2020-03-01 ║ 2022-03-01 ║
║ Mary    ║ 2018-02-01 ║ 2022-01-31 ║
║ Mary    ║ 2020-01-01 ║ 2022-01-01 ║
║ Charles ║ 2019-07-01 ║ 2021-06-30 ║
║ Charles ║ 2020-03-01 ║ 2022-03-01 ║
╚═════════╩════════════╩════════════╝
*/

select t.name, tLbegin, t.end
from (
    select
        t.*,
        lead(t.begin) over(partition by t.name order by t.begin) lead_begin
    from mytable t
) t
where t.end > t.lead_begin or lead_begin is null