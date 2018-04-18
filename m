MIME-Version: 1.0
In-Reply-To: <1524061018-20413-1-git-send-email-amir73il@gmail.com>
References: <1524061018-20413-1-git-send-email-amir73il@gmail.com>
Date: Wed, 18 Apr 2018 16:23:18 +0200
Message-ID: <CAJfpegsQ01V9Jyboy+9W9eahMDNM7nggLHFkbD=13hNhX+Du0g@mail.gmail.com>
Subject: Re: [PATCH 0/2] Fix failing overlay nonsamefs fstests
From: Miklos Szeredi <miklos@szeredi.hu>
Content-Type: text/plain; charset="UTF-8"
To: Amir Goldstein <amir73il@gmail.com>
Cc: Eryu Guan <eguan@redhat.com>, overlayfs <linux-unionfs@vger.kernel.org>, fstests <fstests@vger.kernel.org>
List-ID: <linux-unionfs@vger.kernel.org>

On Wed, Apr 18, 2018 at 4:16 PM, Amir Goldstein <amir73il@gmail.com> wrote:

> FYI, Miklos has a patch set in review to fix the last of the
> non-standard behavior tracking test that is still failing (overlay/016).
> After that patch set is merged, all overlay tests will be expected to
> pass on master - new era ;-)

Oh, we can write new tests that don't pass ;)

For example -ostrictatime mounts are not going to behave POSIX'ly (and
probably nobody cares, but still).  And we have that minor weirdness
with directory nlink being constant 1.   And probably some others.

Not that there's a hurry to test these... So yeah, having all tests
pass would be nice :)

Thanks,
Miklos
