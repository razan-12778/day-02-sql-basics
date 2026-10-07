from pyparsing import (
    Word,
    Literal,
    Group,
    delimitedList,
    Optional,
    ParseException,
    QuotedString,
    alphanums,
    alphas,
    nums,
    Suppress,
)


class SQLParser:
    def __init__(self):
        self.parser = self._create_parser()

    def _create_parser(self):
        table_name = Word(alphanums)("table_name")
        integer = Word(nums)("integer")
        string_literal = QuotedString(quoteChar="'", escChar="\\")("string_literal")
        column_info = Group(Word(alphanums)("column_name") + Word(alphas)("data_type"))
        columns = delimitedList(column_info, ",")("columns")

        create_table_stmt = (
            Literal("CREATE TABLE")
            + table_name
            + Suppress("(")
            + columns
            + Suppress(")")
        )

        insert_stmt = (
            Literal("INSERT INTO")
            + table_name
            + Suppress(Literal("VALUES"))
            + Suppress("(")
            + delimitedList(string_literal | integer)
            + Suppress(")")
        )

        select_stmt = (
            Literal("SELECT")
            + delimitedList(Word(alphanums))
            + Literal("FROM")
            + table_name
            + Optional(
                Literal("JOIN")
                + table_name
                + Literal("ON")
                + Word(alphanums)
            )
        )

        return create_table_stmt | insert_stmt | select_stmt

    def parse(self, sql):
        try:
            result = self.parser.parseString(sql)
            return result.asList()
        except ParseException as e:
            return {"error": f"Parse error: {e}"}