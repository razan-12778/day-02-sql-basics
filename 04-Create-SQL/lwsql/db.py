from lwsql.btree import DiskBTree
from lwsql.parser import SQLParser


class DB:
    def __init__(self, filename, t=2):
        self.filename = filename
        self.btree = DiskBTree(t, filename)
        self.sql_parser = SQLParser()

    def __enter__(self):
        return self

    def __exit__(self, exc_type, exc_value, traceback):
        self.close()

    @staticmethod
    def map_data_type(data_type_str):
        if data_type_str == "int":
            return int
        elif data_type_str == "str":
            return str
        else:
            raise ValueError(f"Invalid data type: {data_type_str}")

    def execute_sql(self, sql):
        parsed_sql = self.sql_parser.parse(sql)

        if parsed_sql is None:
            raise Exception(f"Invalid SQL statement: {sql}")

        if parsed_sql[0] == "CREATE TABLE":
            table_name = parsed_sql[1]
            schema = {}

            for i in range(2, len(parsed_sql)):
                column = parsed_sql[i]
                data_type_str = column[1]
                data_type = self.map_data_type(data_type_str)
                schema[column[0]] = data_type

            metadata = self.btree.read_metadata()

            if table_name in metadata["tables"]:
                raise Exception(f"Table {table_name} already exists.")

            self.btree.select_table(table_name, schema)

        elif parsed_sql[0] == "INSERT INTO":
            table_name = parsed_sql[1]
            values = parsed_sql[2:]

            self.btree.select_table(table_name)

            row_data = {}

            for column, value in zip(self.btree.schema.keys(), values):
                data_type = self.btree.schema[column]
                row_data[column] = data_type(value)

            key = row_data[list(self.btree.schema.keys())[0]]

            self.btree.insert(key, row_data)

        elif parsed_sql[0] == "SELECT":
            selected_columns = []

            i = 1
            while i < len(parsed_sql) and parsed_sql[i] != "FROM":
                selected_columns.append(parsed_sql[i])
                i += 1

            table_name = parsed_sql[i + 1]

            self.btree.select_table(table_name)

            def get_all_rows(offset):
                node = self.btree.read_node(offset)
                rows = []

                if node.leaf:
                    rows.extend(node.rows)
                else:
                    for child_offset in node.child_offsets:
                        rows.extend(get_all_rows(child_offset))

                    rows.extend(node.rows)

                return rows

            all_rows = get_all_rows(self.btree.root_offset)

            result = []

            for row in all_rows:
                selected_row = {}

                for column in selected_columns:
                    if column not in row:
                        raise Exception(f"Column {column} does not exist.")

                    selected_row[column] = row[column]

                result.append(selected_row)

            return result

        else:
            raise Exception(f"Invalid SQL statement: {sql}")

    def close(self):
        self.btree.close()
