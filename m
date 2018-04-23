Return-Path: <amir73il@gmail.com>
MIME-Version: 1.0
In-Reply-To: <CAJfpegsKYh5hWofQxO5gVCLL3PoAGSaVEF8O+K72tk+TBjEJwQ@mail.gmail.com>
References: <1524061018-20413-1-git-send-email-amir73il@gmail.com>
 <CAJfpegsQ01V9Jyboy+9W9eahMDNM7nggLHFkbD=13hNhX+Du0g@mail.gmail.com>
 <CAOQ4uxg=aQpHWFEz4M+Kz9gOtu6XJd8rGw1oa4zrtyMZ+T7ogQ@mail.gmail.com> <CAJfpegsKYh5hWofQxO5gVCLL3PoAGSaVEF8O+K72tk+TBjEJwQ@mail.gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Mon, 23 Apr 2018 07:50:10 -0700
Message-ID: <CAOQ4uxhQku0jchmxynrQ2CXunSnDuWppaK3d2e41+txzsJQPzQ@mail.gmail.com>
Subject: Re: [PATCH 0/2] Fix failing overlay nonsamefs fstests
Content-Type: text/plain; charset="UTF-8"
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Eryu Guan <eguan@redhat.com>, overlayfs <linux-unionfs@vger.kernel.org>, fstests <fstests@vger.kernel.org>
List-ID: <linux-unionfs@vger.kernel.org>

On Mon, Apr 23, 2018 at 6:37 AM, Miklos Szeredi <miklos@szeredi.hu> wrote:
> On Wed, Apr 18, 2018 at 4:30 PM, Amir Goldstein <amir73il@gmail.com> wrote:
>> On Wed, Apr 18, 2018 at 5:23 PM, Miklos Szeredi <miklos@szeredi.hu> wrote:
>>> On Wed, Apr 18, 2018 at 4:16 PM, Amir Goldstein <amir73il@gmail.com> wrote:
>>>
>>>> FYI, Miklos has a patch set in review to fix the last of the
>>>> non-standard behavior tracking test that is still failing (overlay/016).
>>>> After that patch set is merged, all overlay tests will be expected to
>>>> pass on master - new era ;-)
>>>
>>> Oh, we can write new tests that don't pass ;)
>
> Another one:
>
> fstat() returns incorrect st_ctime after unlink of a lower file/directory.
>
> Alternative fixes:
>
> 1) take some attributes from whiteout
>
> 2) metacopy up to tmpfile
>
> But first of all, we need a test case that fails, otherwise there's no
> motivation to do the fix ;)
>

I admit that the failing xfstests I wrote have had a "motivating"
effect, but going forward, I feel that xfstests is not really the place
for these sort of weird behavior tests. I find it to be more suiting as
a regression tracking test suite and special test case coverage.

IMO, parent ctime fits better to a POSIX compliance test suite, such
as pdjfstest.

And besides, overlayfs now feels it is in a functional state that is worthy
of PASS. Sure, that is a very subjective observation.

> I'm wondering, would it make sense to manually add "rotation points"
> to plain xfstest test cases?

Can you give an example of an xfstest and a rotation point?
We actually had to duplicate a whole bunch of test cases, just to
test the nonsamefs flavor, so adding a 'flavor' to run all tests with is
not really the xfstests way.

I rather we add rotation related tests to unionmount testsuite
as it already supports a whole bunch of rotation techniques.
If you have any specific use cases in mind I can work on adding
those to unionmount.

Thanks,
Amir.
