from multicorn import ForeignDataWrapper
from kafka import KafkaConsumer
import json


class KafkaFDW(ForeignDataWrapper):
    def __init__(self, options, columns):
        super(KafkaFDW, self).__init__(options, columns)
        self.columns = columns
        self.topic = options.get('topic')
        self.bootstrap_servers = options.get('bootstrap_servers', 'localhost:9092')
        self.group_id = options.get('group_id', 'postgres_fdw')
        self.max_messages = int(options.get('max_messages', 100))

    def execute(self, quals, columns):
        consumer = KafkaConsumer(
            self.topic,
            bootstrap_servers=self.bootstrap_servers,
            group_id=self.group_id,
            auto_offset_reset='earliest',
            enable_auto_commit=False,
            value_deserializer=lambda m: json.loads(m.decode('utf-8'))
        )

        count = 0
        for message in consumer:
            if count >= self.max_messages:
                break
            row = {}
            for col in columns:
                row[col] = message.value.get(col, None)
            count += 1
            yield row

    def end_scan(self):
        # You could optionally close the consumer here if you stored it as an instance variable
        pass
