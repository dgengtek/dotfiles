#!/bin/env python3
import os, sys, pathlib
import functools, itertools
import math, fractions
import random
import string

frac = fractions.Fraction
dec = fractions.Decimal

size = 10
char_a = 97
char_A = 65

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
    {"list_{}".format(i): list(string.__getattribute__(i)) for i in list_asciis}
)
del list_asciis

list_N010 = list_digits
list_Z = list(range(-size, size))
list_Q = [x / size for x in range(-size, size)]
dictionary_a_n = dict(zip(string.ascii_lowercase, list_N010))
dictionary_n_a = {v: k for k, v in dictionary_a_n.items()}

dictionary_lexicographic = {
    "1": 1,
    "100": 2,
    "200": 3,
    "3": 4,
    "4": 4,
    "50": 1,
    "a-100": 1,
    "a-5": 1,
    "a-1": 1,
    "a-50": 1,
    "a-200": 1,
    "a-2": 1,
    "a-110": 1,
    "a-111": 1,
    "a-101": 1,
    "a-11": 1,
    "ab-1": 1,
    "az-1: ": 1,
    "aa": 1,
    "aaz": 1,
    "default-1": 1,
    "default-a": 1,
    "default-z": 1,
    "default-1a": 1,
    "default-1z": 1,
    "default-aa": 1,
    "defaulta-1": 1,
    "defaulta": 1,
    "default-ccc": 1,
    "default-zzz": 1,
    "default-100": 1,
    "default-999": 1,
    "default-111": 1,
    "default-900": 1,
    "default-c11": 1,
    "default-a11": 1,
    "default-cc1": 1,
    "default-c1111": 1,
    "default-cc111": 1,
    "default-c1": 1,
    "default-c10": 1,
    "default-911": 1,
    "default-955": 1,
    "a-120": 1,
    "a-150": 1,
    "a-090": 1,
    "a-009": 1,
    "default-ccc-long description": 1,
    "default-aaa- just another longer description": 1,
}
dictionary_lexicographic_keys = sorted(dictionary_lexicographic.keys())
