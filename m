MIME-Version: 1.0
In-Reply-To: <CAOQ4uxg=aQpHWFEz4M+Kz9gOtu6XJd8rGw1oa4zrtyMZ+T7ogQ@mail.gmail.com>
References: <1524061018-20413-1-git-send-email-amir73il@gmail.com>
	<CAJfpegsQ01V9Jyboy+9W9eahMDNM7nggLHFkbD=13hNhX+Du0g@mail.gmail.com>
	<CAOQ4uxg=aQpHWFEz4M+Kz9gOtu6XJd8rGw1oa4zrtyMZ+T7ogQ@mail.gmail.com>
Date: Mon, 23 Apr 2018 15:37:58 +0200
Message-ID: <CAJfpegsKYh5hWofQxO5gVCLL3PoAGSaVEF8O+K72tk+TBjEJwQ@mail.gmail.com>
Subject: Re: [PATCH 0/2] Fix failing overlay nonsamefs fstests
From: Miklos Szeredi <miklos@szeredi.hu>
Content-Type: text/plain; charset="UTF-8"
To: Amir Goldstein <amir73il@gmail.com>
Cc: Eryu Guan <eguan@redhat.com>, overlayfs <linux-unionfs@vger.kernel.org>, fstests <fstests@vger.kernel.org>
List-ID: <linux-unionfs@vger.kernel.org>

On Wed, Apr 18, 2018 at 4:30 PM, Amir Goldstein <amir73il@gmail.com> wrote:
> On Wed, Apr 18, 2018 at 5:23 PM, Miklos Szeredi <miklos@szeredi.hu> wrote:
>> On Wed, Apr 18, 2018 at 4:16 PM, Amir Goldstein <amir73il@gmail.com> wrote:
>>
>>> FYI, Miklos has a patch set in review to fix the last of the
>>> non-standard behavior tracking test that is still failing (overlay/016).
>>> After that patch set is merged, all overlay tests will be expected to
>>> pass on master - new era ;-)
>>
>> Oh, we can write new tests that don't pass ;)

Another one:

fstat() returns incorrect st_ctime after unlink of a lower file/directory.

Alternative fixes:

1) take some attributes from whiteout

2) metacopy up to tmpfile

But first of all, we need a test case that fails, otherwise there's no
motivation to do the fix ;)

I'm wondering, would it make sense to manually add "rotation points"
to plain xfstest test cases?

Thanks,
Miklos
