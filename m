Return-Path: <amir73il@gmail.com>
MIME-Version: 1.0
In-Reply-To: <CAJfpegsQ01V9Jyboy+9W9eahMDNM7nggLHFkbD=13hNhX+Du0g@mail.gmail.com>
References: <1524061018-20413-1-git-send-email-amir73il@gmail.com> <CAJfpegsQ01V9Jyboy+9W9eahMDNM7nggLHFkbD=13hNhX+Du0g@mail.gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Wed, 18 Apr 2018 17:30:35 +0300
Message-ID: <CAOQ4uxg=aQpHWFEz4M+Kz9gOtu6XJd8rGw1oa4zrtyMZ+T7ogQ@mail.gmail.com>
Subject: Re: [PATCH 0/2] Fix failing overlay nonsamefs fstests
Content-Type: text/plain; charset="UTF-8"
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Eryu Guan <eguan@redhat.com>, overlayfs <linux-unionfs@vger.kernel.org>, fstests <fstests@vger.kernel.org>
List-ID: <linux-unionfs@vger.kernel.org>

On Wed, Apr 18, 2018 at 5:23 PM, Miklos Szeredi <miklos@szeredi.hu> wrote:
> On Wed, Apr 18, 2018 at 4:16 PM, Amir Goldstein <amir73il@gmail.com> wrote:
>
>> FYI, Miklos has a patch set in review to fix the last of the
>> non-standard behavior tracking test that is still failing (overlay/016).
>> After that patch set is merged, all overlay tests will be expected to
>> pass on master - new era ;-)
>
> Oh, we can write new tests that don't pass ;)
>
> For example -ostrictatime mounts are not going to behave POSIX'ly (and
> probably nobody cares, but still).  And we have that minor weirdness
> with directory nlink being constant 1.   And probably some others.

FYI, ext4 also has directories with nlink 1 with the dir_nlink feature,
so no big deal.

Thanks,
Amir.
