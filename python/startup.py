#!/bin/env python3
import os, sys, pathlib
import functools, itertools
import math, fractions
import random
import string

frac = fractions.Fraction
dec = fractions.Decimal

size = 10
char_a=97
char_A=65

list_asciis = [
        "digits",
        "hexdigits",
        "octdigits",
        "printable",
        "punctuation",
        "ascii_lowercase",
        "ascii_uppercase",
        "ascii_letters",
        "ascii_uppercase",
        "ascii_uppercase",
        ]
globals().update(
        { "list_{}".format(i):list(string.__getattribute__(i)) for i in list_asciis }
        )
del list_asciis

list_N010 = list_digits
list_Z = list(range(-size, size))
list_Q = [ x/size for x in range(-size, size) ]
dictionary_a_n = dict(zip(string.ascii_lowercase, list_N010))
dictionary_n_a = { v: k for k,v in dictionary_a_n.items() }
