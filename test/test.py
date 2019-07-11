import matplotlib
matplotlib.use('Agg')

import pylab
import nest
import nest.voltage_trace
nest.ResetKernel()

neuron = nest.Create('iaf_psc_exp')


spikegenerator = nest.Create('spike_generator')
voltmeter = nest.Create('voltmeter')

nest.SetStatus(spikegenerator, {'spike_times': [10., 50.]})
nest.Connect(spikegenerator, neuron, syn_spec={'weight': 1e3})
nest.Connect(voltmeter, neuron)

nest.Simulate(100.)

nest.voltage_trace.from_device(voltmeter)
nest.voltage_trace.show()
pylab.savefig('/home/nest/data/test.svg')