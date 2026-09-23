import os

from ib_insync import Forex, Stock

from models.hft_model_1 import HftModel1

if __name__ == '__main__':
	TWS_HOST = os.environ.get('TWS_HOST', '127.0.0.1')
	TWS_PORT = os.environ.get('TWS_PORT', 4002)

	print('Connecting on host:', TWS_HOST, 'port:', TWS_PORT)

	model = HftModel1(
		host=TWS_HOST,
		port=TWS_PORT,
		client_id=2,
	)

	to_trade = [
		('AAPL', Stock('AAPL', 'SMART', 'USD')),
		('AAL', Stock('AAL', 'SMART', 'USD')),
		('AMZN', Stock('AMZN', 'SMART', 'USD')),
		('AMD', Stock('AMD', 'SMART', 'USD')),
		('BA', Stock('BA', 'SMART', 'USD')),
		('BABA', Stock('BABA', 'SMART', 'USD')),
		('TSLA', Stock('TSLA', 'SMART', 'USD')),
		('FB', Stock('FB', 'SMART', 'USD')),
		('DIS', Stock('DIS', 'SMART', 'USD')),
		('QQQ', Stock('QQQ', 'SMART', 'USD')),
		('SPY', Stock('SPY', 'SMART', 'USD')),
		('NVDA', Stock('NVDA', 'SMART', 'USD')),
		('NFLX', Stock('NFLX', 'SMART', 'USD')),
		('ROKU', Stock('ROKU', 'SMART', 'USD')),
		('ZM', Stock('ZM', 'SMART', 'USD')),
		('DAL', Stock('DAL', 'SMART', 'USD'))
	]

	model.run(to_trade=to_trade, trade_qty=1)
