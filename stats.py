import os
from datetime import datetime
import numpy as np
import json
import glob
import argparse

class stats() :

    def __init__(self, full):
        self.runname = os.path.basename(os.path.abspath(os.curdir))
        print(self.runname)
        self.full = full
        self.delimiter = ">>>>> "
        self.confdict = {}
        self.timedict = {'total':[], 'untar':[], 'evtgen':[], 'upload':[]}
        self.timekeys = {'total': ['START', 'UPLOAD'],
                         'untar': ['START', 'UNTAR'],
                         'evtgen': ['UNTAR', 'RUN'],
                         'upload': ['RUN', 'UPLOAD']}

    def run(self):
        self.collect()
        self.output()

    def collect(self):
        for f in glob.glob('slurm-*.out'):
            fh = open(f)
            ldict = {}
            for l in fh.readlines():
                if l[:9] == self.delimiter + "MG5":
                    ll = [x.strip() for x in l[:-1].split(">>>>>")][1:]
                    if ll[0] == "MG5_TIME":
                        ldict[ll[1]] = datetime.strptime(ll[2].replace("CEST ",""), "%c")
                    elif ll[0] == "MG5_CONF":
                        self.confdict[ll[1].strip()] = ll[2].strip()

            for k,v in self.timekeys.items():
                self.timedict[k].append(ldict[v[1]] - ldict[v[0]])

            fh.close()

    def output(self):
        statsdict = {}
        process = self.confdict['PROC_DIR']
        runopts = self.confdict['RUN_OPTS']
        numevts = self.confdict['NUM_EVTS']
        if self.full:
            header = "\n%s, run.sh %s %s <seed>\n\nTIME   DURATION(s)   STD DEV       MIN       MAX   SERIES\n%s" % (process, runopts, numevts, '-'*57)
            entry = "{val}\t{mean:10.2f}{stdev:10.2f}{minv:10.2f}{maxv:10.2f}   {series}"   
            # '%s\t%10.2f%10.2f' % (k, mean, stdev) 
        else:
            header = "\n%s, run.sh %s %s <seed>\n\nTIME   DURATION(s)   STD DEV\n%s" % (process, runopts, numevts, '-'*28)
            entry = "{val}\t{mean:10.2f}{stdev:10.2f}"
            #'%s\t%10.2f%10.2f' % (k, mean, stdev)
        print(header)
        for k in self.timedict:
            times = [x.seconds for x in self.timedict[k]]
            mean  = np.mean(times)
            stdev = np.std(times)
            minv  = np.min(times)
            maxv  = np.max(times)
            if self.full:
                print(entry.format(val=k, mean=mean, stdev=stdev, minv=minv, maxv=maxv, series=str(times)))
            else:
                print(entry.format(val=k, mean=mean, stdev=stdev))
            statsdict[k] = {'mean': str(mean), 'stdev': str(stdev), 'max': str(maxv), 'min': str(minv), 'times': [str(x) for x in times]}
        print()

        data = {'conf': {'proc': process, 'runopts': runopts, 'numevts': numevts},
                'stat': statsdict}
        fh = open('stats_%s.json' % self.runname, 'w')
        fh.write(json.dumps(data, indent=2))
        fh.close()


if __name__ == '__main__':
    parser = argparse.ArgumentParser()
    parser.add_argument('-f', '--full', action="store_true")
    args = parser.parse_args()
    
    stats(full=args.full).run()
