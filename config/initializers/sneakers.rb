require 'sneakers'

Sneakers.configure(
  amqp: 'amqp://user:password@rabbitmq:5672',
  vhost: '/',
  exchange: 'sneakers',
  exchange_type: :fanout,
  durable: true,
  ack: true,
  heartbeat: 2,
  workers: 10,
  threads: 10,
  prefetch: 10,
  timeout_job_after: 0,
  hooks: {},
  handler: Sneakers::Handlers::Oneshot
)

Sneakers.logger.level = Logger::INFO
