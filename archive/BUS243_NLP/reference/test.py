import unittest
from president_guesser import *


test_cases = [
    "Who was president on Wed Mar 01 04:23:40 2023",
    "Who was president on Tue Jan 20 13:00:00 2009",
    "Who was president on Fri Nov 22 16:00:00 1963",
    "Who was president on Tue Apr 12 20:00:00 1949",
    "Who was president on Sat Mar 04 21:00:00 1933",
    "Who was president on Sat Apr 15 15:00:00 1865",
    "Who was president on Thu Apr 30 17:00:00 1789",
]


class TestPresidentGuessers(unittest.TestCase):
    def setUp(self):
        self.reference = test_cases
        self.pg = PresidentGuesser()
        self.pg.train(training_data)

    def test_basic(self):
        for ii in self.reference:
            guess = self.pg(ii)["guess"]
            self.assertTrue(guess in self.reference[ii])

if __name__ == '__main__':
    unittest.main()