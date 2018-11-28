Return-Path: <amir73il@gmail.com>
MIME-Version: 1.0
References: <20181010233441.5337-1-amir73il@gmail.com> <20181010233441.5337-3-amir73il@gmail.com>
 <20181120160751.GA18182@rei.lan>
In-Reply-To: <20181120160751.GA18182@rei.lan>
From: Amir Goldstein <amir73il@gmail.com>
Date: Wed, 28 Nov 2018 18:50:49 +0200
Message-ID: <CAOQ4uxiBkQAZwwziXgB8njLm3bXdkwc=gN1h9MCw56uA-kKH+w@mail.gmail.com>
Subject: Re: [PATCH v3 2/6] syscalls/readahead02: Convert to newlib and cleanup
Content-Type: text/plain; charset="UTF-8"
To: Cyril Hrubis <chrubis@suse.cz>
Cc: ltp@lists.linux.it, Jan Stancek <jstancek@redhat.com>, Miklos Szeredi <miklos@szeredi.hu>, overlayfs <linux-unionfs@vger.kernel.org>
List-ID: <linux-unionfs@vger.kernel.org>

...
> >  static int check_ret(long expected_ret)
> >  {
> > -     if (expected_ret == TEST_RETURN) {
> > -             tst_resm(TPASS, "expected ret success - "
> > -                      "returned value = %ld", TEST_RETURN);
> > +     if (expected_ret == TST_RET) {
> > +             tst_res(TPASS, "expected ret success - "
> > +                     "returned value = %ld", TST_RET);
> >               return 0;
> >       }
> > -     tst_resm(TFAIL | TTERRNO, "unexpected failure - "
> > -              "returned value = %ld, expected: %ld",
> > -              TEST_RETURN, expected_ret);
> > +     tst_res(TFAIL | TTERRNO, "unexpected failure - "
> > +             "returned value = %ld, expected: %ld",
> > +             TST_RET, expected_ret);
> >       return 1;
> >  }
>
> I would be happier if we got rid of this function.
>

Done. (In next patch)

> Maybe we should just move the loop from read_file() to a separate
> function do_readahead() then the indentation would be one level less
> there and the code could be put directly there.
>
...

> >       if (gettimeofday(&now, NULL) == -1)
> > -             tst_brkm(TBROK | TERRNO, cleanup, "gettimeofday failed");
> > +             tst_brk(TBROK | TERRNO, "gettimeofday failed");
>
> We should really switch to posix timers here, using wall clock for
> elapsed time measurements in not a good idea for several reasons.
>
> And we even do have nice API for this, see:
>
> https://github.com/linux-test-project/ltp/wiki/Test-Writing-Guidelines#2221-measuring-elapsed-time-and-helper-functions
>

Nice! done in a separate patch.

...

> > -             sprintf(testfile, MNTPOINT"/testfile");
> > -     }
> > +     sprintf(testfile, "%s/testfile", mntpoint);
>
> This just a static string defined on the top of the test.
>

It is going to be modified per test case in patch
"test readahead() on an overlayfs file"

v4 posted.

Thanks,
Amir.
