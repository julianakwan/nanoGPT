import re
import string
import matplotlib
import matplotlib.pyplot as plt
import numpy as np
import argparse
import pathlib

matplotlib.use('Agg')

def read_output(input_filename):

    IS_THIS_LOSS = r'(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+'

    iter_no = []
    loss = []
    with open(input_filename, 'r') as slurm_output:
        while True:
            line = slurm_output.readline()
            if "mfu" in line:
                match = re.search(IS_THIS_LOSS, line)
                current_iter = match.group(2)
                current_loss = match.group(4)
                current_iter = current_iter.replace(':', '')
                current_loss = current_loss.replace(',', '')
                iter_no.append(current_iter)
                loss.append(current_loss)

            if not line:
                break

    iter_no = np.array(iter_no, dtype='int')
    loss = np.array(loss, dtype='float32')

    return iter_no, loss

if __name__ == '__main__':
    parser = argparse.ArgumentParser(
        prog='plot_loss',
        description='Plot the loss as a function of the iteration number from parsing the Slurm outputs of nanoGPT')
    parser.add_argument("input_filename", type=pathlib.Path, help="Name of Slurm outputs (can be more than one)", nargs='*')
    parser.add_argument("-f", "--output_filename", type=pathlib.Path, help="(optional) Name of figure to be saved (including extension), defaults to loss.pdf", default="loss.pdf")
    args = parser.parse_args()
    
#   "/home/jk945/slurm-15010487.out"  has interesting behaviour. 

    nfiles = len(args.input_filename)
    for i in range(nfiles):
        print("Plotting {:}...".format(args.input_filename[i]))
        iter_no, loss = read_output(args.input_filename[i])
        plt.plot(iter_no, loss, color='b')
        
    plt.xlabel('iteration')
    plt.ylabel('loss')
    plt.savefig(args.output_filename)
